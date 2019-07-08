//
//  PBPayApiModel.m
//  PayBusSDK
//
//  Created by linsheng on 2018/4/13.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import "PBPayApiModel.h"

//@implementation PBPayApiModel
//
//- (void)getPayApiWithBillInfo:(PBBillInfo *)billInfo channel:(PBPayChannel )channel completion:(MTKCompletionBlock)completeBlock
//{
//    
//    NSError *error=[billInfo checkEnable];
//    if (error) {
//        completeBlock(false,error.domain,nil);
//        return;
//    }
//    [self fetchWithPath:@"payment/order" type:MTKFetchModelTypePOST completion:completeBlock];
//}
//@end
@implementation PBPayResultCheckModel
- (void)setStatus:(NSInteger)status
{
    _status=status;
    switch (status) {
        case 1:
            {
                _statusType=PBPayResultCheckModelStatusSuccess;
            }
            break;
            
        default:
        {
            _statusType=PBPayResultCheckModelStatusCreate;
        }
            break;
    }
//    if ([HNUBZUtil checkEqualFirst:@"paySuccess" second:status]) {
//        _statusType=PBPayResultCheckModelStatusSuccess;
//    }
//    else if([HNUBZUtil checkEqualFirst:@"payFail" second:status])
//    {
//        _statusType=PBPayResultCheckModelStatusFail;
//    }
//    else if([HNUBZUtil checkEqualFirst:@"payClose" second:status])
//    {
//        _statusType=PBPayResultCheckModelStatusClose;
//    }
//    else if([HNUBZUtil checkEqualFirst:@"payCreate" second:status])
//    {
//        _statusType=PBPayResultCheckModelStatusCreate;
//    }
//    else
//    {
//        NSLog(@"bz error unknow status:%@",_status);
//        _statusType=PBPayResultCheckModelStatusOther;
//    }
}
- (void)checkWithOutTradeNo:(nullable NSString*)outTradeNo channel:(PBPayChannel )channel completion:(MTKCompletionBlock)completeBlock
{
    _intCount+=1;
    self.channelType=channel;
    self.orderId=outTradeNo;
    [self fetchWithPath:[NSString stringWithFormat:@"payment/order/%@",outTradeNo] type:MTKFetchModelTypeGET completion:completeBlock];
}
- (void)reRequestWithCompletion:(MTKCompletionBlock)completeBlock
{
    if (!self.code&&self.status) {
        return;
    }
    self.code=-1;
    [self checkWithOutTradeNo:_orderId channel:_channelType completion:completeBlock];
}
@end
