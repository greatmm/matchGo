//
//  PBPayBasicDataManager.m
//  PayBusSDK
//
//  Created by linsheng on 2018/4/19.
//  Copyright © 2018年 linsheng. All rights reserved.
// 结算这边流程应该都ok了
#define PBPayCheckTimes 10
#define PBPayCheckDuring 3
#import "PBNoticeDatamanager.h"
#import "PBPayBasicDataManager.h"
#import "PBErrorCode.h"
@implementation PBPayBasicDataManager
- (id)init
{
    if (self=[super init]) {
        _arrayRequest=[@[] mutableCopy];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadInfo) name:KKViewNeedReloadNotification object:nil];
    }
    return self;
}
- (BOOL)payWithInfo:(NSString *)strInfo order:(PBBillInfo *)order
{
    return false;
}
- (BOOL)payWithDiamond:(NSInteger)diamond channel:(PBPayChannel)channel
{
    self.billInfo=[[PBBillInfo alloc] init];
    hnuSetWeakSelf;
    [self.billInfo getChannel:channel diamond:diamond completion:^(BOOL isSucceeded, NSString *msg,NSError * _Nullable error)
     {
         if (isSucceeded&&[HNUBZUtil checkStrEnable:weakSelf.billInfo.params]) {
             //             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.billInfo.wapurl]];
             [weakSelf payWithInfo:weakSelf.billInfo.params order:weakSelf.billInfo];
         }
     }];
    return true;
}
- (void)reloadInfo
{
    if (self.billInfo) {
        [self checkWithOutTradeNo:self.billInfo.orderid channel:self.billInfo.channel];
        self.billInfo=nil;
    }
}
- (void)checkWithOutTradeNo:(nullable NSString*)outTradeNo channel:(PBPayChannel )channel
{
    for (PBPayResultCheckModel *model in _arrayRequest) {
        if ([HNUBZUtil checkEqualFirst:outTradeNo second:model.orderId]) {
            return;
        }
    }
    PBPayResultCheckModel *checkResult=[[PBPayResultCheckModel alloc] init];
    checkResult.intCount=0;
    [_arrayRequest addObject:checkResult];
    __weak PBPayResultCheckModel *weakCheckApi=checkResult;
    hnuSetWeakSelf;
    [checkResult checkWithOutTradeNo:outTradeNo channel:channel completion:^(BOOL isSucceeded, NSString *msg, NSError *error){
        [weakSelf checkEndWithModel:weakCheckApi];
        
    }];
}
- (void)checkStartWithModel:(PBPayResultCheckModel *)checkResult
{
    if (checkResult.boolRequesting) {
        return;
    }
    __weak PBPayResultCheckModel *weakCheckApi=checkResult;
    hnuSetWeakSelf;
    if (checkResult.intCount>=PBPayCheckTimes) {
        [_arrayRequest removeObject:checkResult];
        //bz 纠结 是否走报错 轮训超时
         [PBNoticeDatamanager noticePayFailueWithCode:PAYBUS_ERROR_QUERY msg:@"查询失败"];
        return;
    }
    [checkResult reRequestWithCompletion:^(BOOL isSucceeded, NSString *msg, NSError *error){
        [weakSelf checkEndWithModel:weakCheckApi];
        
    }];
}
- (void)checkEndWithModel:(PBPayResultCheckModel *)model
{
    if (!model.success) {
        [self performSelector:@selector(checkStartWithModel:) withObject:model afterDelay:PBPayCheckDuring];
        return;
    }
//    if (model.code==0) {
        if (model.statusType==PBPayResultCheckModelStatusCreate) {
            //轮训
            [self performSelector:@selector(checkStartWithModel:) withObject:model afterDelay:PBPayCheckDuring];
            return;
        }
        else if (model.statusType==PBPayResultCheckModelStatusSuccess) {
        
            PBBillInfo *model=[[PBBillInfo alloc] init];
            [model injectDataWithModel:model];
            //检测成功 去掉以前代码 直接通知
            [PBNoticeDatamanager noticePaySuccessWithInfo:model];
            
        }
        else if(model.statusType==PBPayResultCheckModelStatusClose)
        {
            [PBNoticeDatamanager noticePayFailueWithCode:PAYBUS_ERROR_QUERY_CLOSE msg:@"查询订单交易已关闭"];
        }
        else
        {
          [PBNoticeDatamanager noticePayFailueWithCode:PAYBUS_ERROR_QUERY_PAY_FAIL msg:model.msg];
        }
        
//    }
//    else
//    {
//
//        [PBNoticeDatamanager noticePayFailueWithCode:PAYBUS_ERROR_QUERY_PAY_FAIL msg:@"查询订单失败"];
//    }
}
@end
