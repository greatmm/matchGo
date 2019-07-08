//
//  KKRemoveView.m
//  game
//
//  Created by GKK on 2018/10/12.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKRemoveView.h"

@implementation KKRemoveView
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.removeBlock) {
        self.removeBlock();
    }
}
@end
