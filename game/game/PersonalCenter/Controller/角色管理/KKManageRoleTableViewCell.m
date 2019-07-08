//
//  KKManageRoleTableViewCell.m
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKManageRoleTableViewCell.h"

@implementation KKManageRoleTableViewCell

-(void)assignWithItem:(KKAccountModel *)item
{
    if (item) {
        if ([HNUBZUtil checkStrEnable:item.gamer]) {
            self.gameLabel.text = item.gamer;
        } else {
            self.gameLabel.text = @"";
        }
        if ([HNUBZUtil checkStrEnable:item.gamerank]) {
            self.gameDesLabel.text = item.gamerank;
        } else {
            self.gameDesLabel.text = @"";
        }
        [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
        self.rightBtn.layer.borderColor = kThemeColor.CGColor;
        self.rightBtn.layer.borderWidth = 1;
        self.rightBtn.backgroundColor = [UIColor whiteColor];
        [self.rightBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
    } else {
        self.gameDesLabel.text = @"请绑定游戏角色开始夺金挑战";
        [self.rightBtn setTitle:@"绑定" forState:UIControlStateNormal];
        self.rightBtn.layer.borderWidth = 0;
        self.rightBtn.backgroundColor = kThemeColor;
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (IBAction)clickRightBtn:(id)sender {
    if (self.clickRightBtnBlock) {
        self.clickRightBtnBlock();
    }
}

@end
