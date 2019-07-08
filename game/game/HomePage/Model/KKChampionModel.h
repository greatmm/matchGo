//
//  KKChampionModel.h
//  game
//
//  Created by linsheng on 2018/12/19.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChampionModel : MTKJsonModel
//id
@property (nonatomic, copy) NSString *choice;

@property (nonatomic, copy) NSString *choicecode;

@property (nonatomic, assign) long endtime;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, assign) long starttime;

@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSNumber *choicetype;

@property (nonatomic, strong) NSString *images;

@property (nonatomic, strong) NSNumber *game;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *freetickets;
@end

NS_ASSUME_NONNULL_END
