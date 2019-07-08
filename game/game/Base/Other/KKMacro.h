//
//  KKMacro.h
//  Created by GKK on 2018/8/6.
//  Copyright © 2018年 MM. All rights reserved.
//

#ifndef KKMacro_h
#define KKMacro_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define isIphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height == 20 ? NO : YES)
#define kThemeColor [UIColor colorWithRed:41/255.0 green:194/255.0 blue:158/255.0 alpha:1]
#define kThemeColorTranslucence [UIColor colorWithRed:41/255.0 green:194/255.0 blue:158/255.0 alpha:0.5]
#define kBackgroundColor [UIColor colorWithWhite:245/255.0 alpha:1]
#define kTitleColor [UIColor colorWithRed:16/255.0 green:29/255.0 blue:55/255.0 alpha:1]
#define kSubtitleColor [UIColor colorWithWhite:126/255.0 alpha:1]
#define k153Color [UIColor colorWithWhite:153/255.0 alpha:1]
#define kOrangeColor [UIColor colorWithRed:245/255.0 green:69/255.0 blue:69/255.0 alpha:1]
#define kYellowColor [UIColor colorWithRed:245/255.0 green:198/255.0 blue:69/255.0 alpha:1]

#define kSmallHouseHeight 56
#define kLeftMargin 16

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define documentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]
#define ST_PULLTOREFRESH_HEADER_HEIGHT MJRefreshHeaderHeight

#ifdef DEBUG
#define KKLog(...) NSLog(__VA_ARGS__)
#else
#define KKLog(...)
#endif
#define kkLoginMacro \
  if ([KKDataTool token] == nil) {\
       [KKDataTool showLoginVc];\
        return;\
  }

#endif /* KKMacro_h */
