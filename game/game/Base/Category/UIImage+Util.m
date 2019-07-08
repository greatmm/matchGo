//
//  UIImage+Util.m
//  HeiNiu
//
//  Created by Su Xiaozhou on 27/7/15.
//  Copyright (c) 2015 Su Xiaozhou. All rights reserved.
//

#import "UIImage+Util.h"

#define DegreesToRadians(x) (M_PI * (x) / 180.0)

@implementation UIImage (Util)
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor Alpha:(CGFloat)alpha
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    CGFloat aph = 0.0f;
    if (alpha) {
        aph = alpha;
    }
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:aph];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
//透明边
- (UIImage *)bzAntiAlias
{
    CGFloat border = 1.0f;
    CGRect rect = CGRectMake(border, border, self.size.width-2*border, self.size.height-2*border);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height));
    [self drawInRect:CGRectMake(-1, -1, self.size.width, self.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.size);
    [img drawInRect:rect];
    UIImage* antiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antiImage;
}
+ (UIImage *) imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    //bz 修改清理
    CFRelease(newImageRef);
    return newImage;
}

+ (UIImage *)imageFromView:(UIView *)theView withRect:(CGRect)rect{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
//    UIRectClip(rect);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self imageFromImage:theImage inRect:rect];    
}
//缩小
- (UIImage *)imageScaledToSize:(CGSize)size
{
    size.height/=self.scale;
    size.width/=self.scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//将选择的照片缩放到指定尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    [[self class]saveImage:image WithName:@"testold.png"];

    // Create a graphics image context
    int _width=image.size.width;
    int _height=image.size.height;
    if(_width>_height) _width=_height;
    if(_width<_height) _height=_width;
    
     CGSize  _size=CGSizeMake(_width,_width);
    UIGraphicsBeginImageContext(_size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    UIRectFill(CGRectMake(0,0, _width, _height));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake((_width-image.size.width)/2,(_height-image.size.height)/2,image.size.width,image.size.height)];
    
    // Get the new image from the context
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    [[self class]saveImage:image WithName:@"test.png"];
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    [[self class]saveImage:newImage WithName:@"testNew.png"];

    // Return the new image.
//            CGSize asize = CGSizeMake(kRoundRect.size.width, kRoundRect.size.height);
//            UIGraphicsBeginImageContext(asize);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
//            UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
//    
//            CGRect drawRect = CGRectMake(CGRectGetMinX(self.snapImageView.frame)-CGRectGetMinX(kRoundRect), CGRectGetMinY(self.snapImageView.frame)-CGRectGetMinY(kRoundRect), CGRectGetWidth(self.snapImageView.frame), CGRectGetHeight(self.snapImageView.frame));

    return newImage;
}

//将照片命名保存到document目录下
+(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    
    //NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}
+ (UIImage *)circularImageWithImage:(UIImage *)image rectSize:(CGRect)rect
{
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = imageWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.height, self.size.width)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.height / 2, -self.size.width / 2, self.size.height, self.size.width), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(CAShapeLayer *)createLinesDashPatten:(UIView *)view withColor:(UIColor *)color
{
    if (view.frame.size.width!=0) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.bounds = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        borderLayer.position = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
        
        //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:0].CGPath;
        borderLayer.lineWidth = 0.5;
        //虚线边框
        borderLayer.lineDashPattern = @[@4, @4];
        //实线边框
        //    borderLayer.lineDashPattern = nil;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = color.CGColor;
        [view.layer addSublayer:borderLayer];
        
        return borderLayer;

    }
    else
        return nil;
    
}
+ (UIImage *)screenshot {
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f && UIInterfaceOrientationIsLandscape(orientation)) {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 2.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f) {
            if (orientation == UIInterfaceOrientationLandscapeLeft) {
                CGContextRotateCTM(context, M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
            } else if (orientation == UIInterfaceOrientationLandscapeRight) {
                CGContextRotateCTM(context, -M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                CGContextRotateCTM(context, M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
        }
        
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
