//
//  KKBattleMatchModel.h
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMatchBasicModel.h"

NS_ASSUME_NONNULL_BEGIN
//对战比赛信息
@interface KKBattleMatchModel : KKMatchBasicModel
//id
@property (nonatomic, strong) NSString *mid;
//
@property (nonatomic, strong) NSString *uuid;
//比赛类型
@property (nonatomic, assign) NSInteger matchtype;


@property (nonatomic, strong) NSString *isprivate;
//金币
@property (nonatomic, assign) NSInteger gold;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *deadline;
@property (nonatomic, assign) NSInteger awardmax;
@end

NS_ASSUME_NONNULL_END
