//
//  KKRoomMatchModel.m
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKRoomMatchModel.h"

@implementation KKRoomMatchModel
+ (NSDictionary *)mtkJsonModelKeyMapper
{
    return @{@"id":@"rid"};
}
- (NSInteger)getCountDownTime
{
    return 0;
}
- (KKMatchStatus )getMatchStatus
{
    return KKSmallHouseStatusRoom;
}
@end
