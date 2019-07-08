//
//  UIImage+Util.h
//  HeiNiu
//
//  Created by Su Xiaozhou on 27/7/15.
//  Copyright (c) 2015 Su Xiaozhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)
- (UIImage *)imageScaledToSize:(CGSize)size;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage *)imageFromView:(UIView *)theView withRect:(CGRect)rect;
//+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
//将选择的照片缩放到指定尺寸
- (UIImage *)bzAntiAlias;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

//将照片命名保存到document目录下
+(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor Alpha:(CGFloat)alpha;

+ (UIImage *)circularImageWithImage:(UIImage *)image rectSize:(CGRect)rect;

+(CAShapeLayer *)createLinesDashPatten:(UIView *)view withColor:(UIColor *)color;
+ (UIImage *)screenshot;
//拍照显示处理
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end
