//
//  UIView+KKCategory.h
//  MinSu
//
//  Created by  on 2017/12/5.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE

@interface UIView (KKCategory)

- (UIViewController *)viewController;
- (void)addCornersWithRectCorner:(UIRectCorner)rectCorner cornerSize:(CGSize)cornerSize;
-(void)addShadowWithFrame:(CGRect)frame shadowOpacity:(CGFloat)shadowOpacity shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset;
-(void)removeShadow;
@end
