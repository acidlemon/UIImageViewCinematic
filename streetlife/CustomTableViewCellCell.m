//
//  CustomTableViewCellCell.m
//  streetlife
//
//  Created by Kawazoe Masatoshi on 12/07/18.
//  Copyright (c) 2012年 Kayac Inc. All rights reserved.
//

#import "CustomTableViewCellCell.h"
#import "UIImageView+Cinematic.h"

@implementation CustomTableViewCellCell

@synthesize alignRight = _alignRight;
@synthesize squareFill = _squareFill;
@synthesize thumbnailView = _thumbnailView;
@synthesize thumbnailImage = _thumbnailImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _thumbnailView = [[UIImageView alloc] initWithImage:nil];
        _thumbnailView.cinematic = YES;
        _thumbnailView.userInteractionEnabled = YES;
        [self addSubview:_thumbnailView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageView.userInteractionEnabled = YES;
    
    // 画像のアスペクト比を見てUIImageViewのサイズをきめる
    UIImage* img = self.thumbnailView.image;
    CGFloat width = self.bounds.size.width - 120;
    CGFloat imageViewHeight = width * img.size.height / img.size.width;
    self.thumbnailView.clipsToBounds = YES;
    if (self.squareFill) {
        imageViewHeight = width;
        self.thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    // ラベルの高さ決める
    CGSize textLabelSize = [self.textLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]
                                           constrainedToSize:CGSizeMake(width, 30000)];
    self.textLabel.numberOfLines = 0;
    
    
    if (!self.alignRight) {
        self.textLabel.frame = CGRectMake(10, 10, textLabelSize.width, textLabelSize.height);
        self.thumbnailView.frame = CGRectMake(10, 20 + textLabelSize.height, width, imageViewHeight);
        self.imageView.hidden = YES;
    } else {
        self.textLabel.frame = CGRectMake(110, 10, textLabelSize.width, textLabelSize.height);
        self.thumbnailView.frame = CGRectMake(110, 20 + textLabelSize.height, width, imageViewHeight);
        self.imageView.hidden = YES;
    }
    
    NSLog(@"imgview=%@", self.imageView);
    
    // フォント指定する
    self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
}

+ (CGFloat)heightForCell:(CGFloat)width  text:(NSString*)text image:(UIImage*)img square:(BOOL)square{
    CGFloat imageViewHeight = square ? width : width * img.size.height / img.size.width;
    
    
    // ラベルの高さ決める
    CGSize textLabelSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]
                                           constrainedToSize:CGSizeMake(width, 30000)];
    
    return 30 + textLabelSize.height + imageViewHeight;
}

@end
