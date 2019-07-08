//
//  KKUser.h
//  game
//
//  Created by GKK on 2018/8/22.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUser : NSObject

@property (nonatomic, strong) NSNumber * userId;

@property (nonatomic, strong) NSNumber * sex;

@property (nonatomic, strong) NSString * nickname;

@property (nonatomic, strong) NSString * mobile;

@property (nonatomic, strong) NSString * location;

@property (nonatomic, strong) NSString * avatar;

@property (strong,nonatomic) NSString * inv_code;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, assign) BOOL enable;

@property (nonatomic, strong) NSNumber *inviter;
/*
 d =     {
 avatar = "";
 id = 3;
 location = "";
 mobile = "176****0521";
 nickname = 17637500521;
 sex = 0;
 };
 */
@end
