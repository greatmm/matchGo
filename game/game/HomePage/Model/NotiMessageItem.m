//
//  NotiMessageItem.m
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//

#import "NotiMessageItem.h"

@implementation NotiMessageItem
+ (NSDictionary *)mtkJsonModelKeyMapper
{
    return @{@"id":@"messageid"};
}
@end
