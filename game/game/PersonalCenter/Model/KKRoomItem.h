//
//  KKRoomItem.h
//  game
//
//  Created by GKK on 2018/9/28.
//  Copyright © 2018 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRoomItem : NSObject

@property (nonatomic, strong) NSNumber *awardmax;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *report_update;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSNumber *game;

@property (nonatomic, strong) NSNumber *starttime;

@property (nonatomic, strong) NSNumber *matchtype;

@property (nonatomic, strong) NSString *choice;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *choicetype;

@property (nonatomic, strong) NSNumber *choicecode;

@property (nonatomic, strong) NSNumber *tickets;

@property (nonatomic, strong) NSNumber *state;

@property (nonatomic, strong) id roomId;

@property (nonatomic, strong) NSNumber *uid;

@property (nonatomic, strong) NSNumber *gamerid;

@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSNumber *deadline;

@property (nonatomic, strong) NSNumber *result;

@property (nonatomic, strong) NSNumber *slots;

@property (nonatomic, strong) NSNumber *report_create;

@property (nonatomic, strong) NSNumber *rankinmatch;

@property (nonatomic, strong) NSNumber *isprivate;

@property (nonatomic, strong) NSNumber *left;

@property (nonatomic, strong) NSNumber *gold;

@property (nonatomic, strong) NSNumber *seatNO;

@property (strong,nonatomic) NSString * uuid;

@property (strong,nonatomic) NSNumber * reasoncode;

@end

NS_ASSUME_NONNULL_END
