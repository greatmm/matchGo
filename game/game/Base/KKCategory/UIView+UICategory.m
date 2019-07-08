//
//  UIView+UICategory.m
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "UIView+UICategory.h"

@implementation UIView (UICategory)
@dynamic borderC,borderW,cornerR,showShadow,shadowOffset;

- (void)setBorderW:(CGFloat)borderW{
    self.layer.borderWidth = borderW;
}
- (void)setCornerR:(CGFloat)cornerR{
    self.layer.cornerRadius = cornerR;
    self.layer.masksToBounds = YES;
}
- (void)setBorderC:(UIColor *)borderC{
    self.layer.borderColor = borderC.CGColor;
}
-(void)setShowShadow:(BOOL)showShadow
{
    self.layer.shadowOpacity = 0.05;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.masksToBounds = NO;
}
-(void)setShadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOpacity = 0.15;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = shadowOffset;
}
@end
