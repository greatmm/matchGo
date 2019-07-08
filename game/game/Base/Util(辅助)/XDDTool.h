//
//  XDDTool.h
//  XiaoDD
//
//  Created by JOY on 2017/7/24.
//  Copyright © 2017年 NiuBang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kResignAllFirstResponder [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]

#define kWindow [UIApplication sharedApplication].keyWindow

#define H(value) [XDDTool percentageHight:(value/1.0)]
#define W(value) [XDDTool percentageWidth:(value/1.0)]
#define WX(value) [XDDTool percentageXWidth:(value/1.0)]

@interface XDDTool : NSObject
//缩放长度
+ (CGFloat)percentageHight:(CGFloat)hight;
//缩放宽度
+ (CGFloat)percentageWidth:(CGFloat)width;
+ (CGFloat)percentageXWidth:(CGFloat)width;
//把股票代码转成.1.2的形式
//+ (NSString *)convertStockCodeToNormal:(NSString *)originCode;

//手机号校验
+(BOOL)isMobileNumber:(NSString*)mobileNum;
+(UIWindow*)mainWindow;
/**
 计算左侧label的最长宽度
 
 @param labels label数组
 @return 最长宽度
 */
+(CGFloat)caculateMaxWidth:(NSArray *)labels height:(CGFloat)height;

/**
 格式化股票代码
 SS -- .1  SZ -- .2
 @param stockCode 股票代码
 @return 格式化后的股票代码
 */
+(NSString*)formatStockCode:(NSString*)stockCode;
/**
 获取当前屏幕显示的viewcontroller
 
 @return ViewController
 */
+(UIViewController *)getCurrentVC;

@end
