//
//  KKManageRoleTableViewCell.h
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"
#import "KKAccountModel.h"

@interface KKManageRoleTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic,strong) void(^clickRightBtnBlock)(void);
-(void)assignWithItem:(KKAccountModel *)item;
@end
