//
//  PBPayBasicDataManager.h
//  PayBusSDK
//
//  Created by linsheng on 2018/4/19.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBPayApiModel.h"
#import "PBBillInfo.h"
@interface PBPayBasicDataManager : NSObject
@property (nonatomic, strong,nonnull)NSMutableArray<PBPayResultCheckModel *> *arrayRequest;
@property (nonatomic, strong) PBBillInfo *billInfo;
- (void)checkWithOutTradeNo:(nullable NSString*)outTradeNo channel:(PBPayChannel )channel;
- (BOOL)payWithInfo:(nonnull NSString *)strInfo order:(PBBillInfo *)order;
- (BOOL)payWithDiamond:(NSInteger)diamond channel:(PBPayChannel)channel;
@end
