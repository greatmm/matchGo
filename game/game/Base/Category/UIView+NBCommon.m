//
//  UIView+Common.m
//  MaiTalk
//
//  Created by Joy on 15/4/10.
//  Copyright (c) 2015年 duomai. All rights reserved.
//

#import "UIView+NBCommon.h"

@implementation UIView (NBCommon)

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}
- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor
{
    CGColorRef ref = self.layer.borderColor;
    if (ref) {
        return [UIColor colorWithCGColor:ref];
    } else {
        return nil;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    CGFloat scale = [UIScreen mainScreen].scale;
    NSInteger pixelNum = borderWidth / (1 / scale);
    CGFloat usedWith = pixelNum ? (CGFloat)pixelNum/scale : borderWidth;
    self.layer.borderWidth = usedWith;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setTop:(CGFloat)top
{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect rect = self.frame;
    rect.origin.y = bottom - self.frame.size.height;
    self.frame = rect;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setLeft:(CGFloat)left
{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect rect = self.frame;
    rect.origin.x = right - self.frame.size.width;
    self.frame = rect;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame =rect;
}

- (CGFloat)height
{
    return  self.frame.size.height;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)centerY
{
    return self.center.y;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    id view = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    return view;
}

+ (instancetype)getViewFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    return nil;
}

- (UIView *)findFirstResponder{
    
    UIView *firstResponder = nil;
    if (self.isFirstResponder) {
        firstResponder = self;
    } else {
        for (UIView *view in self.subviews) {
            if (view.isFirstResponder) {
                firstResponder = view;
                break;
            } else {
                firstResponder = [view findFirstResponder];
                if (firstResponder) {
                    break;
                }
            }
        }
    }
    return firstResponder;
}

- (BOOL)nbBZLazyInitialization
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        NSArray *typeStringComponents = [propertyAttributes componentsSeparatedByString:@","];
        NSString *typeInfo = [typeStringComponents objectAtIndex:0];
        NSScanner *scanner = [NSScanner scannerWithString:typeInfo];
        scanner.scanLocation += 2;
        if ([scanner scanString:@"\"" intoString:NULL]) {
            NSString *objectClassName = nil;
            [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                                intoString:&objectClassName];
            
            Class classtmp = NSClassFromString(objectClassName);
            if ([classtmp isSubclassOfClass:[UIView class]]) {
                NSString *stringIvarName=[NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                SEL selector = NSSelectorFromString(stringIvarName);
                if ([self respondsToSelector:selector]) {
                    //解决黄点警告
                    UIView *m_nsUsrName=((id (*)(id, SEL))[self methodForSelector:selector])(self, selector);
                    //                    IMP imp = [self methodForSelector:selector];
                    //                    id (*func)(id, SEL) = (id id *)imp;
                    //                    id m_nsUsrName=[self performSelector:NSSelectorFromString(stringIvarName)];
                    //                    id m_nsUsrName=func(self, selector);
                    if (m_nsUsrName) {
                        [self addSubview:m_nsUsrName];
                    }
                }
            }
        }
    }
    free(properties);
    
    return true;
}
- (UIView *)addLineWithTop:(float)top
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, top, kScreenWidth, H(8))];
    view.backgroundColor=MTK16RGBCOLOR(0xF9F9F9);
    [self addSubview:view];
    return view;
}
@end
