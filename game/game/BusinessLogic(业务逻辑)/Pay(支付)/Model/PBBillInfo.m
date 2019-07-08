//
//  PBBillInfo.m
//  game
//
//  Created by linsheng on 2019/1/8.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "PBBillInfo.h"
#import "PBErrorCode.h"
@implementation PBBillInfo
- (NSError *)checkEnable
{
    if (_orderid) {
        return [NSError errorWithDomain:@"订单号不能为空" code:PAYBUS_ERROR_PRE userInfo:nil];
    }
    if (_cny<=0) {
        //增加方法
        return [NSError errorWithDomain:@"金额不能为空" code:PAYBUS_ERROR_PRE userInfo:nil];
    }
    return nil;
}
- (void)getChannel:(PBPayChannel )channel diamond:(NSInteger)diamond completion:(MTKCompletionBlock)completeBlock
{
    _channel=channel;
    _diamond=diamond;
    self.requestParams=@{@"diamond":@(diamond),@"channel":@(channel)};
    [self fetchWithPath:@"payment/order" type:MTKFetchModelTypePOST completion:completeBlock];
}
@end
@implementation PBPayResultInfo

@end
