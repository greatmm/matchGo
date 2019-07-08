//
//  GameItem.m
//  game
//
//  Created by GKK on 2018/8/23.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "GameItem.h"

@implementation GameItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"gameId": @"id",@"gameName":@"name"};
}
@end
