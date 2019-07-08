//
//  KKRoomUser.h
//  game
//
//  Created by GKK on 2018/10/15.
//  Copyright © 2018 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol KKRoomUser <NSObject>

@end
@interface KKRoomUser : MTKJsonModel

@property (nonatomic, strong) NSNumber *state;

@property (nonatomic, strong) NSNumber *award;

@property (nonatomic, strong) NSNumber *uid;

@property (nonatomic, strong) NSNumber *gamerId;

@property (nonatomic, strong) NSNumber *seatNO;

@property (nonatomic, strong) NSNumber *total;

@property (nonatomic, strong) NSString *gamerank;

@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSNumber *win;

@property (nonatomic, strong) NSNumber *diamond;

@property (nonatomic, strong) NSNumber *rankinmatch;

@property (nonatomic, strong) NSString *gamer;

@property (nonatomic, strong) NSString *images;

@property (strong,nonatomic) NSString * image;

@property (nonatomic, strong) NSNumber *result;

@property (nonatomic, strong) NSString *name;

@property (strong,nonatomic) NSNumber * reasoncode;
//获取当前胜率
- (float)getRateOfWinning;
@end

NS_ASSUME_NONNULL_END
