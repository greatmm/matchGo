//
//  XDDTool.m
//  XiaoDD
//
//  Created by JOY on 2017/7/24.
//  Copyright © 2017年 NiuBang. All rights reserved.
//

#import "XDDTool.h"

@implementation XDDTool


+(CGFloat)percentageHight:(CGFloat)hight{
    CGFloat HK ;
    if ([UIApplication sharedApplication].statusBarOrientation == 3||[UIApplication sharedApplication].statusBarOrientation == 4) {
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]<8.0)){
            HK=kScreenWidth;
            
        }else{
            HK=kScreenHeight;
        }
    }else{
        HK=kScreenWidth;
    }
    CGFloat KB = ((HK) * ((hight) / 375.0));
    
    return KB;
}

+(CGFloat)percentageWidth:(CGFloat)width{
    CGFloat HK ;
//    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
//        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]<8.0)){
//            HK=kScreenHeight;
//        }else{
//            HK=kScreenWidth;
//        }
//    }else{
    HK=kScreenHeight;
    if (HNUIPhoneX) {
        CGFloat KB = ((HK) * ((width) / 812.0));
        return KB;
    }
//    }
    CGFloat KB = ((HK) * ((width) / 667.0));
    return KB;
}
+(CGFloat)percentageXWidth:(CGFloat)width{
    CGFloat HK ;
    if ([UIApplication sharedApplication].statusBarOrientation == 3||[UIApplication sharedApplication].statusBarOrientation == 4) {
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]<8.0)){
            HK=kScreenHeight-kNavStatusBarHeight+20;
        }else{
            HK=kScreenWidth;
        }
    }else{
        HK=kScreenHeight-kNavStatusBarHeight+20;
    }
    //    if (HNUIPhoneX) {
    //        CGFloat KB = ((HK) * ((width) / 812.0));
    //        return KB;
    //    }
    CGFloat KB = ((HK) * ((width) / 667.0));
    return KB;
}

/**
 判断该字符串是否为数字
 
 @param string 单个字符
 @return YES 为数字
 */
+ (BOOL)isFigure:(NSString *)string
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:string];
    if (res == TRUE) {
        return FALSE;
    } else {
        return TRUE;
    }
}
//手机号有效性
+(BOOL)isMobileNumber:(NSString*)mobileNum{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(BOOL)isValidateByRegex:(NSString *)regex phone:(NSString*)phone{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:phone];
}
+(UIWindow*)mainWindow{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}
/**
 计算左侧label的最长宽度
 
 @param labels label数组
 @return 最长宽度
 */
+(CGFloat)caculateMaxWidth:(NSArray *)labels height:(CGFloat)height{
    if (!labels||labels.count <= 0) {
        return 0;
    }
    UILabel *label0 = labels[0];
    CGFloat maxW = [label0 sizeThatFits:CGSizeMake(kScreenWidth, height)].width;
    for (UILabel *label in labels) {
        CGFloat W = [label sizeThatFits:CGSizeMake(kScreenWidth, height)].width;
        if (W>maxW) {
            maxW = W;
        }
    }
    return maxW;
}

/**
 格式化股票代码
 SS -- .1  SZ -- .2
 @param stockCode 股票代码
 @return 格式化后的股票代码
 */
+(NSString*)formatStockCode:(NSString*)stockCode{
    
    NSString *fullCode = @"";
    if (stockCode != nil) {
        
        NSString *code = [stockCode componentsSeparatedByString:@"."].firstObject;
        NSString *market = [stockCode componentsSeparatedByString:@"."].lastObject;
        if ([market isEqualToString:@"SS"]) {
            
            fullCode = [NSString stringWithFormat:@"%@.1",code];
            
        }else if ([market isEqualToString:@"SZ"]){
            
            fullCode = [NSString stringWithFormat:@"%@.2",code];
            
        }
    }
    
    return fullCode;
}
/**
 获取当前屏幕显示的viewcontroller

 @return ViewController
 */
+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
