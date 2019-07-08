//
//  KKBindingGamerModel.h
//  game
//
//  Created by linsheng on 2018/12/26.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKBindingGamerModel : MTKJsonModel
@property (nonatomic, strong) NSString *bid;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, assign) KKGameType gameid;

@property (nonatomic, strong) NSString *region;

@property (nonatomic, strong) NSString *device;

@property (nonatomic, strong) NSString *server;

@property (nonatomic, strong) NSString *gamer;

@property (nonatomic, strong) NSString *isdefault;

@property (nonatomic, strong) NSString *gamerank;

@property (nonatomic, strong) NSString *status;
+  (NSString *)getJPushInfo:(KKGameType)game;
-  (NSString *)getJPushInfo;
@end

NS_ASSUME_NONNULL_END
