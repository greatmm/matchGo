//
//  KKMyMatchManager.m
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMyMatchManager.h"

@interface KKMyMatchManager()
//基础的循环 用来倒计时计算
@property (nonatomic, strong) NSTimer *timerBasic;
@end
@implementation KKMyMatchManager
//单例
+(instancetype)sharedMatchManager
{
    static KKMyMatchManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KKMyMatchManager alloc]init];
    });
    return manager;
}
- (id)init
{
    if (self=[super init]) {
        //读取缓存
        //开启runloop
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomNote:) name:kJoinRoom object:nil];//有人加入房间
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveRoomNote:) name:kLeaveRoom object:nil];//有人离开房间
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waitToBeginNote
                                                                                  :) name:kEnterGame object:nil];//等待开始
        [self startTimer];
    }
    return self;
}
#pragma mark Timer
//开启runloop
- (void)startTimer
{
//    [supernatantMatchVC updateInfo];
    if (!_timerBasic) {
        _timerBasic = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(sendMatchUpdateInfo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timerBasic forMode:NSRunLoopCommonModes];
    }
}
- (void)stopTimer
{
    if ([self.timerBasic isValid]) {
         [self.timerBasic invalidate];
    }
    self.timerBasic=nil;
}
- (void)sendMatchUpdateInfo
{
    if (_supernatantMatchVC&&!_supernatantMatchVC.view.hidden&&_matchModel) {
        //处理倒计时信息 假设需要的话
        [_supernatantMatchVC updateMatchStatus];
    }
    
}
#pragma mark set/get
- (KKSmallHouseViewController *)supernatantMatchVC
{
    if (!_supernatantMatchVC) {
        _supernatantMatchVC = [KKSmallHouseViewController new];
        hnuSetWeakSelf;
        _supernatantMatchVC.clickBlock = ^{
//            [weakSelf openRoom];
        };
    }
    return _supernatantMatchVC;
}
#pragma mark Method
- (NSString *)getGameIcon
{
    NSArray * gameIconImgs = @[@"PUBGIcon",@"GKIcon",@"ZCIcon",@"LOLIcon"];
    if (_matchModel.game>0&&_matchModel.game<=4) {
        return gameIconImgs[_matchModel.game-1];
    }
    return @"";
}
- (void)addNewUser:(KKRoomUser *)user
{
    if (_matchModel) {
        for (KKRoomUser *tmpUid in _matchModel.users) {
            if ([tmpUid.uid isEqualToNumber:user.uid]) {
                return;
            }
        }
        NSMutableArray *array=[_matchModel.users mutableCopy];
        [array addObject:user];
        _matchModel.users=array;
    }
    else
    {
        //需要刷新数据
    }
}
- (void)removeWithUserId:(NSInteger )userId
{
    if (_matchModel) {
        for (KKRoomUser *tmpUid in _matchModel.users) {
            if (tmpUid.uid.integerValue == userId) {
                NSMutableArray *array=[_matchModel.users mutableCopy];
                [array removeObject:tmpUid];
                _matchModel.users=array;
                return;
            }
        }
    }
    else
    {
        
    }
    //需要刷新数据
}
#pragma mark notification
- (void)joinRoomNote:(NSNotification *)notification
{
//    leaveRoomNote
    //处理房间
//    if (_matchModel) {
        NSDictionary * dic = notification.userInfo;
        KKRoomUser * user = [KKRoomUser mj_objectWithKeyValues:dic[@"user"]];
    [self addNewUser:user];
//    }
}
- (void)leaveRoomNote:(NSNotification *)notification
{
//    if (_matchModel) {
    NSDictionary * dic = notification.userInfo;
    NSNumber * uid = dic[@"uid"];
    [self removeWithUserId:uid.integerValue];
//    }
}
- (void)waitToBeginNote:(NSNotification *)notification
{
    NSDictionary * beignDic = notification.userInfo;
    if (beignDic) {
        KKBattleMatchModel *model=[[KKBattleMatchModel alloc] initWithJSONDict:beignDic];
        _statusMatch=KKSmallHouseStatusStart;
        _matchModel=model;
    }
}
@end
