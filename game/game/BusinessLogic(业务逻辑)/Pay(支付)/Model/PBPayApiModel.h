//
//  PBPayApiModel.h
//  PayBusSDK
//
//  Created by linsheng on 2018/4/13.
//  Copyright © 2018年 linsheng. All rights reserved.
//
#import "PBBillInfo.h"

typedef NS_ENUM(NSInteger, PBPayResultCheckModelStatus) {
    PBPayResultCheckModelStatusSuccess = 0,
    PBPayResultCheckModelStatusFail ,
    PBPayResultCheckModelStatusClose ,
    PBPayResultCheckModelStatusCreate ,
    PBPayResultCheckModelStatusOther
};



//@interface PBPayApiModel : MTKFetchModel
//@property (nonatomic ,strong, nonnull) NSString *params;
//- (void)getPayApiWithBillInfo:(nonnull PBBillInfo *)billInfo channel:(PBPayChannel )channel completion:(nullable MTKCompletionBlock)completeBlock;
//@end
@interface PBPayResultCheckModel:MTKFetchModel
//@property (nonatomic ,strong, nonnull) NSString *tradeNo;
//0 1 1表示支付完成
@property (nonatomic ,assign) NSInteger status;
@property (nonatomic ,assign) PBPayResultCheckModelStatus statusType;
@property (nonatomic ,strong, nonnull) NSString *diamond;
@property (nonatomic ,assign) NSInteger cny;//精确到分
//request data
@property (nonatomic ,assign) PBPayChannel channelType;
@property (nonatomic ,assign) NSInteger intCount;
@property (nonatomic ,strong, nonnull) NSString * orderId;
- (void)checkWithOutTradeNo:(nullable NSString*)outTradeNo channel:(PBPayChannel )channel completion:(MTKCompletionBlock)completeBlock;
- (void)reRequestWithCompletion:(MTKCompletionBlock _Nullable )completeBlock;
@end



