//
//  KKNotiMessageTableViewCell.m
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKNotiMessageTableViewCell.h"


@interface KKNotiMessageTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@end
@implementation KKNotiMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)assignWithItem:(NotiMessageItem *)item
{
    self.titleLabel.text = item.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@""]];
    self.contentLabel.text = item.content;
    NSNumber * t = item.sendtime;
    if (t && t.integerValue != 0) {
        NSDate * d = [NSDate dateWithTimeIntervalSince1970:t.integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateFormat:@"MM/dd HH:mm"];
        NSString* string = [formatter stringFromDate:d];
        self.timeLabel.text = string;
    } else {
        self.timeLabel.text = @"";
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
