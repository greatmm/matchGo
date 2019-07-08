//
//  HNUBZUtil.h
//  HeiNiu
//
//  Created by linsheng on 2017/10/29.
//  Copyright © 2017年 niubang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNUBZUtil : NSObject
+ (BOOL)checkStrEmpty:(NSString *)string;
+ (BOOL)checkStrEnable:(NSString *)string;
+ (BOOL)checkArrEnable:(NSArray *)array;
+ (BOOL)checkDictEnable:(NSDictionary *)dictionary;
+ (BOOL)checkEqualFirst:(NSString *)str1 second:(NSString *)str2;
+ (BOOL)checkNumber1:(NSNumber *)number1 biggerThenNumber2:(NSNumber *)number2;
//判断网络状态
+ (void)isNetworking;
//获取最上层
+ (UIViewController *)getKeyWindowVisibleViewController;
@end
