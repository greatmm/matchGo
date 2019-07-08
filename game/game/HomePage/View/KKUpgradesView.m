//
//  KKUpgradesView.m
//  game
//
//  Created by greatkk on 2018/12/20.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKUpgradesView.h"

@implementation KKUpgradesView
//点击关闭按钮
- (IBAction)clickCloseBtn:(id)sender {
    [self removeFromSuperview];
    [[KKDataTool shareTools] destroyAlertWindow ];
}
//点击更新按钮
- (IBAction)clickUpgradesBtn:(id)sender {
    if (self.upgradesBlock) {
        self.upgradesBlock();
    } else {
        [self removeFromSuperview];
        [[KKDataTool shareTools] destroyAlertWindow ];
    }
}
//快速返回一个提示框
+(instancetype)shareUpgradesView
{
    KKUpgradesView * upgradesView = [[NSBundle mainBundle] loadNibNamed:@"KKUpgradesHintView" owner:nil options:nil].firstObject;
    upgradesView.frame = [UIScreen mainScreen].bounds;
    [KKDataTool shareTools].alertWindow.backgroundColor = [UIColor clearColor];
    [[KKDataTool shareTools].alertWindow addSubview:upgradesView];
    [[KKDataTool shareTools].alertWindow makeKeyAndVisible];
    return upgradesView;
}

@end
