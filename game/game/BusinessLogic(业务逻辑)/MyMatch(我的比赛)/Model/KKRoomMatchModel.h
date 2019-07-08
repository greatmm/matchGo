//
//  KKRoomMatchModel.h
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMatchBasicModel.h"


NS_ASSUME_NONNULL_BEGIN
//对战开房信息

@interface KKRoomMatchModel : KKMatchBasicModel
@property (nonatomic, strong) NSString *rid;

@property (nonatomic, assign) NSInteger matchtype;
@property (nonatomic, strong) NSString *awardmax;
@property (nonatomic, strong) NSString *gold;
@property (nonatomic, strong) NSString *left;

@end

NS_ASSUME_NONNULL_END
