//
//  UIView+UICategory.h
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UICategory)
@property (nonatomic, assign) IBInspectable CGFloat borderW;
@property (nonatomic, assign) IBInspectable CGFloat cornerR;
@property (nonatomic, strong) IBInspectable UIColor * borderC;
@property (nonatomic, assign) IBInspectable BOOL showShadow;
@property (nonatomic, assign) IBInspectable CGSize shadowOffset;
@end
