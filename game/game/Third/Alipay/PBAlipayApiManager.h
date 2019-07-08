//
//  PBAlipayApiManager.h
//  PayBusSDK
//
//  Created by linsheng on 2018/4/3.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "APOrderInfo.h"
#import "PBPayBasicDataManager.h"
@interface PBAlipayApiManager : PBPayBasicDataManager
+ (instancetype)sharedManager;
- (BOOL)dealWithOpenUrl:(NSURL *)openUrl;
@end
