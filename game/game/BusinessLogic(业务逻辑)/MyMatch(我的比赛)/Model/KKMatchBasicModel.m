//
//  KKMatchBasicModel.m
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMatchBasicModel.h"

@implementation KKMatchBasicModel
- (KKMatchStatus )getMatchStatus
{
    return KKSmallHouseStatusNone;
}
- (NSInteger)getCountDownTime
{
    return 0;
}
- (NSString *)getMatchInfo
{
    if (self.slots>=2) {
//        if (self.slots==2) {
//            return [NSString stringWithFormat:@"%@1V1单挑",self.choice];
//        }
        return [NSString stringWithFormat:@"%@%ld人赛",self.choice,(long)self.slots];
    }
    if ([HNUBZUtil checkStrEnable:_name]) {
        return _name;
    } else {
        return @"锦标赛";
    }
}
@end
