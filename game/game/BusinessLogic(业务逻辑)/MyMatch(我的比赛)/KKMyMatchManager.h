//
//  KKMyMatchManager.h
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKBigHouseViewController.h"
#import "KKSmallHouseViewController.h"

@class KKMatchBasicModel;
NS_ASSUME_NONNULL_BEGIN
//比赛类型（房间只是比赛的一种情况）
typedef NS_ENUM(NSInteger, KKMatchType) {
    KKMatchTypeNone=0,         // 无比赛
    KKMatchTypeRoom,         // 房间中等待
    KKMatchTypeBattle,         // 对战
    KKMatchTypeChampionships   // 锦标赛
};
//比赛状态
typedef NS_ENUM(NSInteger, KKMatchStatus) {
    KKSmallHouseStatusNone=0,         // 无比赛
    KKSmallHouseStatusRoom,           // 房间中等待(锦标赛无此类型，对战显示人数)
    KKSmallHouseStatusStart,          // 开始比赛倒计时
    KKSmallHouseStatusSubmission,     // 提交战绩倒计时
    KKSmallHouseStatusFinish          // 结束
};
@interface KKMyMatchManager : NSObject
//当前比赛类型 后期可以进行多场比赛 type/model 组合
@property (nonatomic, assign) KKMatchType typeMatch;
//比赛状态
@property (assign, nonatomic) KKMatchStatus statusMatch;
//当前比赛 现在默认就只有一个比赛
@property (nonatomic, strong) KKMatchBasicModel *matchModel;
//浮层控件
@property (nonatomic, strong) KKSmallHouseViewController *supernatantMatchVC;
//静态化控制器
+(instancetype)sharedMatchManager;
- (NSString *)getGameIcon;
@end

NS_ASSUME_NONNULL_END
