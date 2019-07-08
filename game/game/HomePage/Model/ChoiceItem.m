//
//  ChoiceItem.m
//  game
//
//  Created by GKK on 2018/9/25.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "ChoiceItem.h"

@implementation ChoiceItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"choiceId": @"id",@"choiceName":@"name"};
}

@end
