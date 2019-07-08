//
//  KKUpgradesModel.h
//  game
//
//  Created by greatkk on 2018/12/20.
//  Copyright © 2018 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKUpgradesModel : MTKJsonModel

@property (nonatomic, assign) int forceupgrade;

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *version;

@end

NS_ASSUME_NONNULL_END
