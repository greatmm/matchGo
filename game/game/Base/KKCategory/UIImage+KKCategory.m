//
//  UIImage+KKCategory.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "UIImage+KKCategory.h"

@implementation UIImage (KKCategory)
+ (UIImage *)imageWithColor:(UIColor *)imgColor
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [imgColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
