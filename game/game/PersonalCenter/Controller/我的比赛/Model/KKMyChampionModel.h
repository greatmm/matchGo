//
//  KKMyChampionModel.h
//  game
//
//  Created by greatkk on 2019/1/10.
//  Copyright © 2019 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKMyChampionModel : MTKJsonModel

@property (nonatomic, strong) NSNumber *cid;

@property (nonatomic, strong) NSNumber *cost;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *choicecode;

@property (nonatomic, strong) NSNumber *starttime;

@property (nonatomic, strong) NSNumber *endtime;

@property (nonatomic, strong) NSNumber *rebuycost;

@property (nonatomic, strong) NSString *choice;

@property (nonatomic, strong) NSNumber *rebuytimes;

@property (nonatomic, strong) NSNumber *showaward_total;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSString *banner;

@property (nonatomic, strong) NSNumber *choicetype;

@property (nonatomic, strong) NSNumber *times;

@property (nonatomic, strong) NSString *images;

@property (nonatomic, strong) NSNumber *game;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *freetickets;

@end

NS_ASSUME_NONNULL_END
