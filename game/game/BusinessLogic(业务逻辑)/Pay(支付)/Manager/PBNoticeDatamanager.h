//
//  PBNoticeDatamanager.h
//  PayBusSDK
//
//  Created by linsheng on 2018/4/18.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBBillInfo.h"
@interface PBNoticeDatamanager : NSObject
//待完善 需要增加订单号
+ (BOOL)noticePayFailueWithCode:(NSInteger)code msg:(NSString *)msg;
+ (BOOL)noticePayFailueWithCode:(NSInteger)code msg:(NSString *)msg order:(PBBillInfo *)order;
+ (BOOL)noticePaySuccessWithInfo:(PBBillInfo *)order;
@end
