//
//  KKAgainstTableViewCell.m
//  game
//
//  Created by GKK on 2018/10/8.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKAgainstTableViewCell.h"


@interface KKAgainstTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;//游戏图标
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;//金币数
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;//右边按钮
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;// 8/8
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;//8人赛
@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;//KDA最高
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;//几张金币
@end
@implementation KKAgainstTableViewCell
- (void)assignWithDic:(NSDictionary *)dic
{
    self.choiceLabel.text = [NSString stringWithFormat:@"  %@  ",dic[@"choice"]];
    self.peopleCount.text = [NSString stringWithFormat:@"  %@人  ",dic[@"slots"]];
    self.ticketLabel.text = [NSString stringWithFormat:@"  %@金币/场  ",dic[@"gold"]];
    self.coinCountLabel.text = [NSString stringWithFormat:@"%@",dic[@"awardmax"]];
    self.titleLabel.text = dic[@"name"];
    NSNumber * totalP = dic[@"slots"];//房间总数
    NSNumber * leftP = dic[@"left"];//剩余空位
    NSInteger currentP = totalP.integerValue - leftP.integerValue;
    if (leftP.integerValue == 0) {
        NSNumber * s = dic[@"status"];
        NSString * btnTitle = @"比赛中";
        if (s.integerValue == 3) {
            btnTitle = @"已结束";
        }
        [self.rightBtn setTitle:btnTitle forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = [UIColor colorWithRed:206/255.0 green:209/255.0 blue:214/255.0 alpha:1];
    } else {
        [self.rightBtn setTitle:@"加入比赛" forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = kThemeColor;
    }
    self.rightLabel.text = [NSString stringWithFormat:@"  %ld/%@  ",(long)currentP,totalP];
    
    NSArray * imgNames = @[@"Chiji_Icon",@"GK_Icon",@"Qiusheng_Icon",@"LOL_Icon"];
    NSNumber * gameId = dic[@"game"];
    if (gameId.integerValue < 5 && gameId.integerValue > 0) {
        self.gameIcon.image = [UIImage imageNamed:imgNames[gameId.integerValue - 1]];
    }
    /*
    wardmax = 10000;
    choice = "\U51fb\U6740\U6570";
    choicecode = 2;
    choicetype = 2;
    deadline = 0;
    game = 1;
    id = 20;
    left = 1;
    matchtype = 1;
    name = "\U51fb\U6740\U65702\U4eba\U8d5b";
    slots = 2;
    starttime = 0;
    status = 1;
    tickets = 10;
     */
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
