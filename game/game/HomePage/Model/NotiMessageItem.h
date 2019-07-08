//
//  NotiMessageItem.h
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTKJsonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NotiMessageItem : MTKJsonModel
@property (nonatomic,strong) NSNumber * messageid;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSDictionary * data;
@property (nonatomic,strong) NSNumber * sendtime;
@property (nonatomic,strong) NSNumber * isread;
@end

NS_ASSUME_NONNULL_END
