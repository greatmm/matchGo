//
//  HNUPushModel.m
//  HeiNiu
//
//  Created by 卢晓琼 on 16/7/9.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import "HNUPushModel.h"



@implementation HNUPushModel
- (void)setMatchid:(NSNumber *)matchid
{
    _matchid=matchid;
    self.matchType=KKMatchTypeBattle;
    
}
- (void)setChampionid:(NSNumber *)championid
{
    _championid=championid;
    self.matchType=KKMatchTypeChampionships;
}
@end
