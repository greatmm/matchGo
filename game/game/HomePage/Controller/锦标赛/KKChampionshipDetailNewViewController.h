//
//  KKChampionshipDetailNewViewController.h
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "BZPagingScrollViewController.h"
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionshipDetailNewViewController : BZPagingScrollViewController
@property (strong, nonatomic) KKChampionshipsModel *modelChampionships;
@property (strong,nonatomic) NSDictionary * dataDic;
@property (assign,nonatomic) BOOL isSmall;
@property (assign,nonatomic) BOOL secondWindow;
@property (strong,nonatomic) NSNumber * cId;//锦标赛id
@property (strong,nonatomic) NSNumber * __nullable matchId;//当前比赛id
@property (strong,nonatomic) NSNumber * gameId;
//@property (strong, nonatomic) UIView *smallView;

@property (assign, nonatomic) BOOL boolSelectResult;
@property (strong,nonatomic) KKSmallHouseViewController * smallHouse;
- (void)openRoom;//放大，在外边要调用
- (void)dismiss;//消失
- (void)dealData;//更新数据

@end

NS_ASSUME_NONNULL_END
