//
//  KKAccountModel.m
//  game
//
//  Created by greatkk on 2019/1/11.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKAccountModel.h"

@implementation KKAccountModel
+ (NSDictionary *)mtkJsonModelKeyMapper
{
    return @{@"id":@"gamerid"};
}
@end
