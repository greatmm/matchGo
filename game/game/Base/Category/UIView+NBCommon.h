//
//  UIView+Common.h
//  MaiTalk
//
//  Created by Joy on 15/4/10.
//  Copyright (c) 2015年 duomai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NBCommon)<NSCopying>

@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@property (nonatomic,readwrite) IBInspectable CGFloat cornerRadius;
@property (nonatomic,readwrite) IBInspectable UIColor *borderColor;
@property (nonatomic,readwrite) IBInspectable CGFloat borderWidth;

/**
 *  从xib加载view,默认加载当前类名的xib
 */
+ (instancetype)getViewFromNib;

- (UIView *)findFirstResponder;
//懒人初始化
- (BOOL)nbBZLazyInitialization;
- (UIView *)addLineWithTop:(float)top;
@end
