//
//  KKEnsureGameAccountView.m
//  game
//
//  Created by GKK on 2018/8/23.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKEnsureGameAccountView.h"

@implementation KKEnsureGameAccountView
+(instancetype)shareAccountView
{
    KKEnsureGameAccountView * accountView = [[NSBundle mainBundle] loadNibNamed:@"KKEnsureGameAccountView" owner:nil options:nil].firstObject;
    UIWindow * w = [KKDataTool shareTools].alertWindow;
    [[KKDataTool shareTools].alertWindow makeKeyAndVisible];
    w.backgroundColor = [UIColor clearColor];
    accountView.frame = [UIScreen mainScreen].bounds;
    [w addSubview:accountView];
    return accountView;
}
- (IBAction)clickCloseBtn:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
    [[KKDataTool shareTools] destroyAlertWindow];
}
- (IBAction)clickEnsureBtn:(id)sender {
    if (self.ensureBlock) {
        self.ensureBlock();
    }
}


@end
