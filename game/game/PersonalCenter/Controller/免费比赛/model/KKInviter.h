//
//  KKInviter.h
//  game
//
//  Created by greatkk on 2019/1/16.
//  Copyright © 2019 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKInviter : MTKJsonModel
@property (nonatomic, strong) NSNumber * userid;

@property (nonatomic, strong) NSNumber * sex;

@property (nonatomic, strong) NSString * nickname;

@property (nonatomic, strong) NSString * mobile;

@property (nonatomic, strong) NSString * location;

@property (nonatomic, strong) NSString * avatar;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, assign) BOOL enable;

@property (nonatomic, strong) NSNumber *inviter;

@property (strong,nonatomic) NSArray * inv_status;

@property (strong,nonatomic) NSNumber * inv_update;

@property (strong,nonatomic) NSNumber * inv_create;
@end

NS_ASSUME_NONNULL_END
