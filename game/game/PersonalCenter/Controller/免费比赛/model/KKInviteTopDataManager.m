//
//  KKInviteTopDataManager.m
//  game
//
//  Created by greatkk on 2019/1/16.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKInviteTopDataManager.h"
#import "KKInviteTopModel.h"
@implementation KKInviteTopDataManager
- (void)checkWithResponse:(id)responseObjectData
{
    [self.array_main addObjectsFromArray:self.modelForLoading.arrayOutput];
    NSInteger count = self.array_main.count;
    for (NSInteger i = 0; i < count; i ++) {
        KKInviteTopModel * m = self.array_main[i];
        m.rank = i + 1;
    }
//    [self.array_main sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        KKInviteTopModel * m1 = obj1;
//        KKInviteTopModel * m2 = obj2;
//        return m1.rankinmatch.integerValue - m2.rankinmatch.integerValue;
//    }];
}
@end
