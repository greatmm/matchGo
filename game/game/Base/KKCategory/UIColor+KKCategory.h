//
//  UIColor+KKCategory.h
//  EasyToWork
//
//  Created by GKK on 2017/12/7.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KKCategory)
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
