//
//  UIView+KKCategory.m
//  MinSu
//
//  Created by  on 2017/12/5.
//

#import "UIView+KKCategory.h"

@implementation UIView (KKCategory)
-(void)addShadowWithFrame:(CGRect)frame shadowOpacity:(CGFloat)shadowOpacity shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset{
    if (self.layer.shadowPath) {
        return;
    }
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:frame].CGPath;
    self.layer.shadowOpacity = shadowOpacity;
    if (shadowColor) {
        self.layer.shadowColor = shadowColor.CGColor;
    } else {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    self.layer.shadowOffset = shadowOffset;
    self.clipsToBounds = NO;
}
-(void)removeShadow
{
    self.layer.shadowPath = nil;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeZero;
}
- (void)addCornersWithRectCorner:(UIRectCorner)rectCorner cornerSize:(CGSize)cornerSize
{
    if (self.layer.mask) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:cornerSize];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = path.CGPath;
    self.layer.mask = shaperLayer;
}
- (UIViewController *)viewController
{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        object = [object nextResponder];
    }
    return object;
}
@end
