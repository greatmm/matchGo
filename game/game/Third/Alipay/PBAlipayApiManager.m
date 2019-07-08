//
//  PBAlipayApiManager.m
//  PayBusSDK
//
//  Created by linsheng on 2018/4/3.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import "PBAlipayApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PBPayApiModel.h"
#import "PBErrorCode.h"
#import "PBNoticeDatamanager.h"
#import "NSDictionary+Json.h"
@interface PBAlipayApiManager()
//@property (nonatomic, copy) NSString *tradeCodeTmp;
@end
@implementation PBAlipayApiManager
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PBAlipayApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PBAlipayApiManager alloc] init];
    });
    return instance;
}

- (BOOL)payWithInfo:(NSString *)strInfo order:(PBBillInfo *)order
{
    if ([HNUBZUtil checkStrEnable:strInfo]) {
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:strInfo fromScheme:KKMachGoScheme callback:^(NSDictionary *resultDic) {
            //bz 这边处理异常或者支付结果
            [self dealAlipayWithDict:resultDic];
        }];
        
        return true;
    }
     [PBNoticeDatamanager noticePayFailueWithCode:PAYBUS_ERROR_PRE msg:@"预定单出错" order:order];
    return false;
}
- (void)dealAlipayWithDict:(NSDictionary *)resultDic
{
    if ([resultDic[@"resultStatus"] intValue]==9000) {
        // 解析 auth code
        if ([HNUBZUtil checkStrEnable:resultDic[@"result"]]) {
            NSDictionary *dictPayResult=[NSDictionary DictionaryWithJsonString:resultDic[@"result"]];
            if ([dictPayResult isKindOfClass:[NSDictionary class]]&&[dictPayResult[@"alipay_trade_app_pay_response"] isKindOfClass:[NSDictionary class]]) {
                //dictPayResult[@"alipay_trade_app_pay_response"][@"trade_no"]
                //dictPayResult[@"alipay_trade_app_pay_response"][@"out_trade_no"]
                 [super checkWithOutTradeNo:dictPayResult[@"alipay_trade_app_pay_response"][@"out_trade_no"] channel:PBPayChannelAlipay];
            }
            else
            {
                //是否通知失败 比较纠结
            }
           
        }
    }
    else if ([resultDic[@"resultStatus"] intValue]==6001) {
        [PBNoticeDatamanager noticePayFailueWithCode:PAYBUS_ERROR_THIRD_CANCEL msg:@"支付宝支付取消"];
    }
    else
    {
        //处理支付宝错误
        [PBNoticeDatamanager noticePayFailueWithCode:PAYBUS_ERROR_THIRD_FAIL msg:@"支付宝支付失败"];
    }
}
- (BOOL)dealWithOpenUrl:(NSURL *)openUrl
{
    if (![openUrl.host isEqualToString:@"safepay"]) {
        return true;
    }
    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:openUrl standbyCallback:^(NSDictionary *resultDic) {
        //无论支付结果  都向服务器询问
        [self dealAlipayWithDict:resultDic];
        
    }];
    return true;
}
@end
