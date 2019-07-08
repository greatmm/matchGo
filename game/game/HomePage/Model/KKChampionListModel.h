//
//  KKChampionListModel.h
//  game
//
//  Created by greatkk on 2018/12/27.
//  Copyright © 2018 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChampionListModel : MTKJsonModel

@property (nonatomic, strong) NSNumber * cid;

@property (nonatomic, strong) NSNumber *cost;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *choicecode;

@property (nonatomic, strong) NSNumber *starttime;

@property (nonatomic, strong) NSNumber *endtime;

@property (nonatomic, strong) NSString *choice;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSNumber *choicetype;

@property (nonatomic, strong) NSString *images;

@property (nonatomic, strong) NSNumber *game;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *freetickets;

@property (strong,nonatomic) NSString * banner;

@property (strong,nonatomic) NSNumber * showaward_total;

@end

NS_ASSUME_NONNULL_END
