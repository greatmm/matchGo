//
//  KKBattleMatchModel.m
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBattleMatchModel.h"

@implementation KKBattleMatchModel
- (NSInteger)getCountDownTime
{
    return 0;
}
+ (NSDictionary *)mtkJsonModelKeyMapper
{
    return @{@"id":@"mid"};
}
- (KKMatchStatus )getMatchStatus
{
    return KKSmallHouseStatusNone;
}
-(NSString *)getMatchInfo
{
    if (self.matchtype == 2) {
        return [NSString stringWithFormat:@"%@1V1单挑",self.choice];
    }
    return [super getMatchInfo];
}
@end
