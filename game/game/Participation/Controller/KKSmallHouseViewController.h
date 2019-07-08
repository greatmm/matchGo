//
//  KKSmallHouseViewController.h
//  game
//
//  Created by greatkk on 2018/11/14.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMyMatchManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKSmallHouseViewController : UIViewController

@property (assign,nonatomic) NSInteger type;
@property (strong,nonatomic) UIImageView * gameIcon;//游戏图标
@property (strong,nonatomic) UILabel * titleLabel;//房间标题，KDA15分32人赛
@property (strong,nonatomic) UIButton * __nullable rightBtn;//提交战绩，开始比赛
@property (strong,nonatomic) UIImageView * __nullable clockIcon;//时间图标
@property (strong,nonatomic) UILabel * __nullable timeLabel;//时间label
@property (strong,nonatomic) UILabel * __nullable countLabel;//人数
@property (strong,nonatomic) UIButton * __nullable closeBtn;//右边的×
@property (strong,nonatomic) UIButton * __nullable cancelBtn;//取消按钮
@property (strong,nonatomic) UIButton * __nullable ensureQuitBtn;//确认退出按钮
@property (strong,nonatomic) void(^__nullable clickRightBtnBlock)(void);//点击右边的按钮
@property (strong,nonatomic) void(^clickBlock)(void);//点击放大block

@property (strong,nonatomic) void(^clickEnsureQuitBlock)(void);//点击确认退出
//更新控件状态
- (void)updateShowInfo;
//更新倒计时
- (void)updateShowTime;
//更新比赛状态
- (void)updateMatchStatus;
- (void)removeCloseUI;//移除退出按钮
@end

NS_ASSUME_NONNULL_END
