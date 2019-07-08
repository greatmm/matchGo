//
//  PBNoticeDatamanager.m
//  PayBusSDK
//
//  Created by linsheng on 2018/4/18.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import "PBNoticeDatamanager.h"

@implementation PBNoticeDatamanager
+ (BOOL)noticePayFailueWithCode:(NSInteger)code msg:(NSString *)msg
{
    return [PBNoticeDatamanager noticePayFailueWithCode:code msg:msg order:nil];
}
+ (BOOL)noticePayFailueWithCode:(NSInteger)code msg:(NSString *)msg order:(PBBillInfo *)order
{
    PBPayResultInfo *info=[PBPayResultInfo new];
    info.success=false;
    info.orderInfo=order;
    info.resultCode=code;
    info.resultView=(msg?msg:@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:KKRechargeFailureNotification object:info];
    return true;
}
+ (BOOL)noticePaySuccessWithInfo:(PBBillInfo *)order
{

    PBPayResultInfo *info=[PBPayResultInfo new];
    info.success=true;
    info.orderInfo=order;
    [[NSNotificationCenter defaultCenter] postNotificationName:KKRechargeSuccessNotification object:info];
    return true;
}
@end
