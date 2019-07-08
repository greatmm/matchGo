//
//  KKInviteTopModel.h
//  game
//
//  Created by greatkk on 2019/1/16.
//  Copyright © 2019 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKInviteTopModel : MTKJsonModel

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *uid;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSNumber *sum_tickets;//获得的入场券数量

@property (nonatomic, strong) NSNumber *sex;

@property (nonatomic, strong) NSNumber *invitee_count;//邀请人数

@property (assign,nonatomic) NSInteger rank;//排名

@end

NS_ASSUME_NONNULL_END
