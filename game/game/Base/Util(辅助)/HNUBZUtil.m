//
//  HNUBZUtil.m
//  HeiNiu
//
//  Created by linsheng on 2017/10/29.
//  Copyright © 2017年 niubang. All rights reserved.
//

#import "HNUBZUtil.h"
#import <AFNetworking/AFNetworking.h>
@implementation HNUBZUtil

+ (void)isNetworking
{
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        //    NSOperationQueue *operationQueue = manager.operationQueue;
        __weak AFNetworkReachabilityManager *weakManager=manager;
    __block NSInteger index=0;
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    NSLog(@"asd");
                    if (index==-1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KKNetworkUpdateNotification object:nil];
                    }
                    [weakManager stopMonitoring];
                }
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                default:
                {
                    index=-1;
                    NSLog(@"zxc");
                }
                    break;
            }
            
        }];
        // 开始监听
        [manager startMonitoring];
        
}
//找回原来的keywindow
+ (UIViewController *)getKeyWindowVisibleViewController
{
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([window class]==[UIWindow class]&&window.windowLevel==UIWindowLevelNormal) {
            UIViewController *vc=window.rootViewController;
            while (1) {
                if ([vc isKindOfClass:[UITabBarController class]]) {
                    vc = ((UITabBarController*)vc).selectedViewController;
                }
                else if ([vc isKindOfClass:[UINavigationController class]]) {
                    vc = ((UINavigationController*)vc).visibleViewController;
                }
                else if (vc.presentedViewController) {
                    vc = vc.presentedViewController;
                }else{
                    break;
                }
                
            }
            return vc;
        }
    }
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
+ (BOOL)checkNumber1:(NSNumber *)number1 biggerThenNumber2:(NSNumber *)number2
{
    if (number1&&number2) {
        return ([number1 integerValue]>[number2 integerValue])?true:false;
    }
    return false;
}
+ (BOOL)checkStrEmpty:(NSString *)string
{
    if ([HNUBZUtil checkStrEnable:string]) {
        NSString *asd=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([HNUBZUtil checkStrEnable:asd]) {
            return false;
        }
    }
    return true;
}
+ (BOOL)checkStrEnable:(NSString *)string
{
    if (string&&[string isKindOfClass:[NSString class]]&&string.length>0) {
        return true;
    }
    return false;
}
+ (BOOL)checkArrEnable:(NSArray *)array
{
    if (array&&[array isKindOfClass:[NSArray class]]&&array.count>0)
    {
        return true;
    }
    return false;
}
+ (BOOL)checkDictEnable:(NSDictionary *)dictionary
{
    if (dictionary&&[dictionary isKindOfClass:[NSDictionary class]])
    {
        return true;
    }
    return false;
}

+ (BOOL)checkEqualFirst:(NSString *)str1 second:(NSString *)str2
{
    if (![HNUBZUtil checkStrEnable:str1]) {
        return false;
    }
    if (![HNUBZUtil checkStrEnable:str2]) {
        return false;
    }
    if ([str1 isEqualToString:str2]) {
        return true;
    }
    return false;
}
@end
