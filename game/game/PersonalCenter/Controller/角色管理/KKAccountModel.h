//
//  KKAccountModel.h
//  game
//
//  Created by greatkk on 2019/1/11.
//  Copyright © 2019 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKAccountModel : MTKJsonModel

@property (nonatomic, strong) NSNumber *gameid;

@property (nonatomic, strong) NSNumber *uid;

@property (nonatomic, strong) NSString *region;

@property (nonatomic, strong) NSNumber *gamerid;

@property (nonatomic, strong) NSNumber *device;

@property (nonatomic, strong) NSString *server;

@property (nonatomic, strong) NSString *gamer;

@property (nonatomic, strong) NSNumber *isdefault;

@property (nonatomic, strong) NSString *gamerank;

@property (nonatomic, strong) NSNumber *status;

@end

NS_ASSUME_NONNULL_END
