//
//  KKRoomItem.m
//  game
//
//  Created by GKK on 2018/9/28.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKRoomItem.h"

@implementation KKRoomItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"roomId": @"id"};
}
@end
