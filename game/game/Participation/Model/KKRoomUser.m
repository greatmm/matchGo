//
//  KKRoomUser.m
//  game
//
//  Created by GKK on 2018/10/15.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKRoomUser.h"

@implementation KKRoomUser
- (float)getRateOfWinning
{
    NSInteger w = self.win.integerValue;
    if (w != 0) {
        NSInteger v = self.total.integerValue;
        float a = floor(w * 1.0/v*100);
        return a;
    }
    return 0;
}
@end
