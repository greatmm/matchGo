//
//  UILabel+Common.h
//  MaiTalk
//
//  Created by Duomai on 16/4/1.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)
/**
 *  初始化label
 *
 *  @param text     文字
 *  @param color label文字颜色
 *  @param fontSize 大小
 *  @param frame    labelFrame
 *
 *  @return label
 */

-(id)initWithText:(NSString *)text color:(UIColor *)colorStr fontSize:(CGFloat)fontSize forFrame:(CGRect)frame;
+ (float)getWidthWithText:(NSString *)text font:(UIFont*)font;
- (void)bzAutoSizeFit;
@end
