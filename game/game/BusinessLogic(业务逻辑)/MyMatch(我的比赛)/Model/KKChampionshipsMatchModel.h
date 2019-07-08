//
//  KKChampionshipsMatchModel.h
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMatchBasicModel.h"
//比赛状态
typedef NS_ENUM(NSInteger, KKChampionshipsType) {
    KKChampionshipsTypeRating=1,        // 平分
    KKChampionshipsTypeLadder=2,        // 阶梯
};

NS_ASSUME_NONNULL_BEGIN
@interface KKChampionshipsMatchModel :MTKJsonModel
@property (nonatomic, strong) NSString *cmid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *gamerid;
@property (nonatomic, strong) NSString *championid;
@property (nonatomic, strong) NSString *images;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSNumber *reasoncode;
@property (nonatomic, assign) NSInteger result;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *step;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) NSString *status;
//开始时间
@property (nonatomic, strong) NSNumber *starttime;
//结束时间
@property (nonatomic, strong) NSString *deadline;

@end

@interface KKChampionshipsMyTicketsModel : MTKJsonModel

@property (nonatomic, assign) NSInteger rebuytimes;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, assign) BOOL costin;

@property (nonatomic, assign) NSInteger first;
@property (nonatomic, assign) NSInteger rebuy;
@property (nonatomic, assign) NSInteger used;
@property (nonatomic, assign) NSInteger buy;
@end
@interface KKChampionshipsModel : KKMatchBasicModel
@property (nonatomic, strong) NSNumber *cid;
@property (nonatomic, strong) NSString *uuid;
//方形图
@property (nonatomic, strong) NSString *images;
//banner图片
@property (nonatomic, strong) NSString *banner;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, assign) KKChampionshipsType type;

//锦标赛比赛信息
@property (nonatomic, strong) KKChampionshipsMatchModel *modelChampionMatch;
//免费次数
@property (nonatomic, assign) NSInteger freetickets;
//首次购买次数 当freetickets有值时 times为0
@property (nonatomic, assign) NSInteger times;
//再买花费
@property (nonatomic, assign) NSInteger rebuycost;
//再买次数
@property (nonatomic, assign) NSInteger rebuytimes;

//总金额
@property (nonatomic, strong) NSString *showaward_total;
#pragma mark Expansion
//我d对于当前锦标赛属性
@property (nonatomic, strong) KKChampionshipsMyTicketsModel *ticketsModel;
//锦标赛名字
@property (nonatomic, strong) NSString *exChampionName;
//锦标赛颜色
@property (nonatomic, strong) UIColor *exChampionColor;
//我拥有的免费券
@property (nonatomic, assign) NSInteger tickets;
- (void)getChampionWithData:(MTKCompletionWithModelData)completeBlock;
//仅限地步按钮需要根据时间来显示颜色
- (UIColor *)getTimeShowColor;
@end



NS_ASSUME_NONNULL_END
