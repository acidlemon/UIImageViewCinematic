//
//  CustomTableViewCellCell.h
//  streetlife
//
//  Created by Kawazoe Masatoshi on 12/07/18.
//  Copyright (c) 2012年 Kayac Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellCell : UITableViewCell

@property (nonatomic) BOOL alignRight;
@property (nonatomic) BOOL squareFill;
@property (strong, nonatomic) UIImageView* thumbnailView;
@property (strong, nonatomic) UIImage* thumbnailImage;

+ (CGFloat)heightForCell:(CGFloat)width  text:(NSString*)text image:(UIImage*)img square:(BOOL)square;

@end
