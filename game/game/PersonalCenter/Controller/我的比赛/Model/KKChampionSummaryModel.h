//
//  KKChampionSummaryModel.h
//  game
//
//  Created by greatkk on 2019/1/10.
//  Copyright © 2019 MM. All rights reserved.
//

#import "MTKJsonModel.h"
#import "KKMyChampionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionSummaryModel : MTKJsonModel

@property (nonatomic, strong) NSNumber *costin;

@property (nonatomic, strong) NSNumber *uid;

@property (nonatomic, strong) NSNumber *updatetime;

@property (nonatomic, strong) NSNumber *times;

@property (nonatomic, strong) NSNumber *win;

@property (nonatomic, strong) NSNumber *championid;

@property (nonatomic, strong) NSNumber *total_value;

@property (nonatomic, strong) NSNumber *total;

@property (nonatomic, strong) NSNumber *rebuytimes;

@property (nonatomic, strong) NSNumber *award;

@property (strong,nonatomic) KKMyChampionModel * championModel;

@end

NS_ASSUME_NONNULL_END
