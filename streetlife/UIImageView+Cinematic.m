//
//  UIImageView+Cinematic.m
//  calayer
//
//  Created by Kawazoe Masatoshi on 12/03/19.
//  Copyright (c) 2012年 Kayac Inc. All rights reserved.
//

#import "UIImageView+Cinematic.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>


// private view for Cinematic UIImageView

@class CinematicContainerView;

@interface UIImageView (CinematicPrivate) 
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event from:(CinematicContainerView*)view;
@end

// private class for Cinematic UIImageView
@interface CinematicContainerView : UIView <UIScrollViewDelegate>
@property (nonatomic, retain) UIImageView* origin;
@end

@implementation CinematicContainerView
@synthesize origin = _origin;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [center addObserver:self selector:@selector(rotated:)
                       name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)endEnteringAnimation {
    // 現在の画面の向きに合わせて回転を入れる
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation != UIDeviceOrientationPortrait) {
        [self updateRotation:orientation];
    }     
}
    
- (void)rotated:(NSNotification*)n {
    // まわすぜぇー
    UIDeviceOrientation orientation = [[n object] orientation];
    if (orientation != UIDeviceOrientationUnknown) {
        [self updateRotation:orientation];
    }
}
    
- (void)updateRotation:(UIDeviceOrientation)orientation {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect rotatedRect = {0};
    CGAffineTransform rotate = CGAffineTransformIdentity;

    switch (orientation) {
        case UIDeviceOrientationPortrait:
            rotatedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
            break;

        case UIDeviceOrientationLandscapeLeft:
            rotate = CGAffineTransformMakeRotation(M_PI_2);
            rotatedRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
            break;
            
        case UIDeviceOrientationLandscapeRight:
            rotate = CGAffineTransformMakeRotation(-M_PI_2);
            rotatedRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
            break;

        default:
            // まわしません。
            break; 
    }
    
    if (rotatedRect.size.width != 0){
        // まわします
        UIView* scrollView = [self.subviews objectAtIndex:1];
        UIImageView* imgView = [scrollView.subviews objectAtIndex:0];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"anim" context:context];
        [UIView setAnimationDuration:0.3];
        scrollView.bounds = rotatedRect;
        [scrollView setTransform:rotate];
        imgView.frame = [self calcImageRect:imgView.image.size withFrameRect:scrollView.bounds]; 
        [self updateImageViewOrigin];
        [UIView commitAnimations];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView.subviews objectAtIndex:0];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateImageViewOrigin];
}

- (CGRect)calcImageRect:(CGSize)imageSize withFrameRect:(CGRect)windowFrame {
    
	CGFloat imageAspect = imageSize.width / imageSize.height;
	CGFloat frameAspect = windowFrame.size.width / windowFrame.size.height;
    CGRect imageRect;
	if (imageAspect >= frameAspect) {
        // 横長だ = 上下に黒帯
        imageRect = CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.width * imageSize.height / imageSize.width);
        imageRect.origin.y = (windowFrame.size.height - imageRect.size.height) / 2;
    } else {
        // 縦長だ = 左右に黒帯
        imageRect = CGRectMake(0, 0, windowFrame.size.height * imageSize.width  / imageSize.height, windowFrame.size.height);
        imageRect.origin.x = (windowFrame.size.width - imageRect.size.width) / 2;
	}
    
    return imageRect;
}                
                         
- (void)updateImageViewOrigin {
    // originを更新するぞ
    UIScrollView* scrollView = [self.subviews objectAtIndex:1];
    UIView* contentView = [self viewForZoomingInScrollView:scrollView];
    
    // ズームしたりするとscrollViewのboundsのsizeもscaleするので普通に比較すればよい
    CGRect bounds = scrollView.bounds;
    CGRect frame = contentView.frame;
    frame.origin = CGPointZero;
    if (bounds.size.width > frame.size.width) {
        frame.origin.x = (bounds.size.width - frame.size.width) / 2;
    }
    if (bounds.size.height > frame.size.height) {
        frame.origin.y = (bounds.size.height - frame.size.height) / 2;
    }
    
    contentView.frame = frame;
}

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[_origin touchesEnded:touches withEvent:event from:self];
}
@end  


@implementation UIImageView (Cinematic)

#pragma Properties accessors

static char cinematicAddr, showCinematicAddr, tempViewAddr, statusBarStyleAddr;
- (void) setCinematic:(BOOL)cinematic {
	objc_setAssociatedObject(self, &cinematicAddr,
							 [NSNumber numberWithBool:cinematic], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL) cinematic {
	NSNumber* val = (NSNumber*)objc_getAssociatedObject(self, &cinematicAddr);
	return [val boolValue];
}
- (void) setShowCinematic:(BOOL)showCinematic {
	objc_setAssociatedObject(self, &showCinematicAddr,
							 [NSNumber numberWithBool:showCinematic], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL) showCinematic {
	NSNumber* val = (NSNumber*)objc_getAssociatedObject(self, &showCinematicAddr);
	return [val boolValue];
}
- (void) setTemporaryView:(CinematicContainerView*)view {
	objc_setAssociatedObject(self, &tempViewAddr, view, OBJC_ASSOCIATION_ASSIGN);
}
- (CinematicContainerView*) temporaryView {
	return (CinematicContainerView*)objc_getAssociatedObject(self, &tempViewAddr);
}

- (void) setStatusBarBlack:(BOOL)black {
	objc_setAssociatedObject(self, &statusBarStyleAddr,
							 [NSNumber numberWithBool:black], OBJC_ASSOCIATION_RETAIN_NONATOMIC);	
}
- (BOOL) statusBarBlack {
	NSNumber* val = (NSNumber*)objc_getAssociatedObject(self, &statusBarStyleAddr);
	return [val boolValue];
}

#pragma - Cinematic view routine

// UIImageViewをタッチしたら呼ばれる
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.cinematic) {
		[self.nextResponder touchesEnded:touches withEvent:event];
		return;
	}
	
	UIWindow* window = [[UIApplication sharedApplication] keyWindow];
	CGRect windowFrame = window.bounds;
	CinematicContainerView* view = [[CinematicContainerView alloc] initWithFrame:windowFrame];
	[window addSubview:view];

	UIView* bgView = [[UIView alloc] initWithFrame:windowFrame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.0;

    UIView* imgView = [[UIImageView alloc] initWithImage:self.image];
    imgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    imgView.contentMode = self.contentMode;

    
    CGRect scrollViewRect = [self.superview convertRect:self.frame toView:view];
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    [scrollView addSubview:imgView];
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.zoomScale = 1.0;

    scrollView.delegate = view;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [scrollView addGestureRecognizer:gesture];

	
	[view addSubview:bgView];
    [view addSubview:scrollView];
    
    [self setTemporaryView:view];
	view.origin = self;
    
    
	[view release];
	
	// Viewを配置するため一旦メインループにもどす (これをサボるとアニメーションしない)
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

    // calc rect (aspect fit)
    CGRect imageRect = [view calcImageRect:self.image.size withFrameRect:windowFrame];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"anim" context:context];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:view];
    [UIView setAnimationDidStopSelector:@selector(endEnteringAnimation)];
    
	[[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
    imgView.frame = imageRect;
    scrollView.frame = windowFrame;
    scrollView.minimumZoomScale = 1.0f;
    scrollView.maximumZoomScale = scrollView.minimumZoomScale * 5.0;
    scrollView.zoomScale = scrollView.minimumZoomScale;
    bgView.alpha = 1.0;

    [UIView commitAnimations];
}




- (void)tapped:(id)sender {
    
    CinematicContainerView* view = [self temporaryView];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIView* bgView = [view.subviews objectAtIndex:0];
    UIScrollView* scrollView = [view.subviews objectAtIndex:1];
    UIView* imgView = [scrollView.subviews objectAtIndex:0];
    
    [UIView beginAnimations:@"restore_anim" context:context];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endRestoreAnimation)];
    bgView.alpha = 0;
    
    CGRect newFrame = [self.superview convertRect:self.frame toView:view];

    // 回転を元に戻す
    scrollView.transform = CGAffineTransformIdentity;
    // フレーム位置を調整
    scrollView.frame = newFrame;

    // 現在のScrollViewの表示領域にあわせてimgViewのRectを調整
    CGRect newImageRect = CGRectZero;
    newImageRect.origin = scrollView.contentOffset;
    newImageRect.size = scrollView.bounds.size;
    imgView.frame = newImageRect;
    
    [UIView commitAnimations];
    
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationFade];
    
}

// Cinematicモードの画像をクリックしたら委譲されて呼ばれる
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event from:(CinematicContainerView*)view{
    [self tapped:view];
}

- (void) endRestoreAnimation {
	if (![self statusBarBlack]) {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	}
	[[self temporaryView] removeFromSuperview];
	[self setTemporaryView:nil];
}

@end
