//
//  KKConstants.h
//  game
//
//  Created by linsheng on 2018/12/18.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
////预生产环境 生产环境注视掉
//#define kkPreproductionEnevironment 1



#ifdef kkDEBUGEnvironment
//测试环境umeng
#define kUMKey @"5c1b0753b465f5891e0000ae"
#define kUMQQAppId @"101543220"
#define kUMQQAppKey @"1facd56770f42d9f828d4c0fb86a9967"
#define kUMWechatAppId @"wxf71c55663659c68d"
#define kUMWechatAppSecret @"233b29d47c97b9d400509c3acb5daa35"
#define kJPushKey @"59b1abefcab8fddd9309e21b"
//0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。此字段的值要与Build Settings的Code Signing配置的证书环境一致。
#define kJPpushApsForProduction 0
#define KKMachGoScheme @"matchGoDebug"
#else
//生产环境umeng
#define KKMachGoScheme @"matchGo"
#define kUMKey @"5c1b04b7b465f5486f0001a7"
#define kJPushKey @"1d3879c1ee170b50baf52b4e"
#define kUMQQAppId @"101543220"
#define kUMQQAppKey @"1facd56770f42d9f828d4c0fb86a9967"
#define kUMWechatAppId @"wxf71c55663659c68d"
#define kUMWechatAppSecret @"233b29d47c97b9d400509c3acb5daa35"
//0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。此字段的值要与Build Settings的Code Signing配置的证书环境一致。
#define kJPpushApsForProduction 1
#endif

//dlog 增加了输出控制
#ifdef DEBUG

#define DLOG(...) do { \
time_t __now = time(NULL); \
struct tm *__local = localtime(&__now); \
printf("\033[fg0,0,255;[D] %02d:%02d:%02d\033[; \033[fg255,0,255;%s:%d\033[; \033[fg0,0,255;%s\n\033[;", __local->tm_hour, __local->tm_min, __local->tm_sec, __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]); \
} while (0)

#define INFO(...) do { \
time_t __now = time(NULL); \
struct tm *__local = localtime(&__now); \
printf("\033[fg0,255,0;[I] %02d:%02d:%02d\033[; \033[fg255,0,255;%s:%d\033[; \033[fg0,255,0;%s\n\033[;", __local->tm_hour, __local->tm_min, __local->tm_sec, __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]); \
} while (0)

#define WARN(...) do { \
time_t __now = time(NULL); \
struct tm *__local = localtime(&__now); \
printf("\033[fg255,127,0;[W] %02d:%02d:%02d\033[; \033[fg255,0,255;%s:%d\033[; \033[fg255,127,0;%s\n\033[;", __local->tm_hour, __local->tm_min, __local->tm_sec, __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]); \
} while (0)

#define ERROR(...) do { \
time_t __now = time(NULL); \
struct tm *__local = localtime(&__now); \
printf("\033[fg255,0,0;[E] %02d:%02d:%02d\033[; \033[fg255,0,255;%s:%d\033[; \033[fg255,0,0;%s\n\033[;", __local->tm_hour, __local->tm_min, __local->tm_sec, __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]); \
} while (0)

#else
#define DLOG(...) do {} while(0)
#define INFO(...) do {} while(0)
#define WARN(...) do {} while(0)
#define ERROR(...) do {} while(0)
#endif

//id
#define KKAlipayAppid @"2018101961716605"


#define  MTKRGBCOLOR(r,g,b)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define  MTKRGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define MTK16RGBCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define  MTKApplicationFrameWidth  [UIScreen mainScreen].applicationFrame.size.width
#define  MTKApplicationFrameHeight [UIScreen mainScreen].applicationFrame.size.height
#define  kScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNavStatusBarHeight (HNUIPhoneX?44:20)//iphonex 待完善
#define kNavigationBarHeight 44//prefersLargeTitles 为76
#define kNavigationAllHeight (kNavStatusBarHeight+kNavigationBarHeight)
// autoScrollBar height
#define kAutoScrollBarHeight W(26)
#define kNavigationDefaultHeight 64
#define kTabStatusBarHeight (HNUIPhoneX?83:49)//iphonex 待完善
#define kIPhonexSaleButtomHeight (HNUIPhoneX?20:0)//iphonex 待完善
//
#define  HNUIPhoneX (((kScreenHeight/kScreenWidth)>2) ? YES : NO)

//定义weakself
#define hnuSetWeakSelf  __weak __typeof(self)weakSelf = self

//fast define
#define MTKImageNamed(name) [UIImage imageNamed:name]
#define MTKSingleString(name,value) [NSString stringWithFormat:name,value]
#define MTKDoubleString(name,value1,value2) [NSString stringWithFormat:name,value1,value2]
//version
#define kkiOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//path
#define kkBundlePath(name,type) [[NSBundle mainBundle] pathForResource:name ofType:type]
NS_ASSUME_NONNULL_BEGIN

@interface KKConstants : NSObject

@end

NS_ASSUME_NONNULL_END
