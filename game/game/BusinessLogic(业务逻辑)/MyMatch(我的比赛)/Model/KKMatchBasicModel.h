//
//  KKMatchBasicModel.h
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKFetchModel.h"
#import "KKRoomUser.h"
NS_ASSUME_NONNULL_BEGIN
//GameItem * item = [KKDataTool itemWithGameId:self.gameId]; 倒计时用
typedef NS_ENUM(NSInteger, KKGameType) {
    KKGameTypeJuediQS=1,        // 绝地求生
    KKGameTypeWangzheRY=2,      // 王者荣耀
    KKGameTypeCijiZC=3,         // 刺激战场
    KKGameTypeYingxiongLM,      // 英雄联盟
};
@interface KKMatchBasicModel : MTKFetchModel
//几人赛 2->"choice+1V1单挑" >2->"choice+slots+人赛"
@property (nonatomic, assign) NSInteger slots;
//游戏类型
@property (nonatomic, strong) NSString *choice;
@property (nonatomic, strong) NSString *choicecode;
@property (nonatomic, strong) NSString *choicetype;
//比赛名字
@property (nonatomic, strong) NSString *name;
//游戏类型
@property (nonatomic, assign) KKGameType game;
@property (nonatomic, strong) NSArray <KKRoomUser>*users;
//@property (nonatomic, assign) KKMatchStatus statusMatch;
- (NSInteger)getCountDownTime;
- (NSString *)getMatchInfo;
- (KKMatchStatus )getMatchStatus;
@end

NS_ASSUME_NONNULL_END
