//
//  PBBillInfo.h
//  game
//
//  Created by linsheng on 2019/1/8.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
     *  订单信息
     *
     *  @property diamond      钻石z数量
     *  @property cny     订单总金额，单位为分
     *  @property orderid      订单号
     */
typedef NS_OPTIONS(NSUInteger, PBPayChannel) {
    PBPayChannelAppstore = 1,//苹果内购
    PBPayChannelAlipay = 2,  //支付宝
    PBPayChannelWechat = 3   //微信
    
};
@interface PBBillInfo : MTKFetchModel
@property (nonatomic,assign) NSInteger diamond;
@property (nonatomic,copy,nonnull) NSString *orderid;
@property (nonatomic,assign) NSInteger cny;
@property (nonatomic,copy) NSString *wapurl;
@property (nonatomic,copy) NSString *params;
@property (nonatomic,assign) PBPayChannel channel;

/**
 * 检测订单有效性
 *
 * @return 返回检测结果，空表示验证通过
 */
- (nullable NSError *)checkEnable;
- (void)getChannel:(PBPayChannel )channel diamond:(NSInteger)diamond completion:(MTKCompletionBlock)completeBlock;
@end

/**
 *  订单信息
 *
 *  @property success       是否成功YES：成功，NO：失败
 *  @property orderInfo    订单信息
 *  @property resultCode        错误号
 *  @property resultView        错误信息
 *  @property channel      支付渠道 ：微信 ，支付宝
 *  @property realFee      实际支付金额
 *
 */
@interface PBPayResultInfo : MTKJsonModel
@property (nonatomic,assign) BOOL success;
@property (nonatomic,assign) NSInteger resultCode;
@property (nonatomic,strong) NSString *resultView;
@property (nonatomic,strong) NSString *resultDesc;
@property (nonatomic,strong,nonnull) PBBillInfo *orderInfo;
@property (nonatomic,strong,nullable) NSString * channel;
@property (nonatomic,strong,nullable) NSString *realFee;

@end
NS_ASSUME_NONNULL_END
