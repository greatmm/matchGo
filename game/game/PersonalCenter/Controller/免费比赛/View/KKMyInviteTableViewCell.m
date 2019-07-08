//
//  KKMyInviteTableViewCell.m
//  game
//
//  Created by greatkk on 2019/1/16.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKMyInviteTableViewCell.h"
#import "KKInviter.h"

@interface KKMyInviteTableViewCell()
@property (strong,nonatomic) UIImageView * avatarView;
@property (strong,nonatomic) UILabel * nickNameLabel;
@property (strong,nonatomic) UILabel * dateLabel;
@property (strong,nonatomic) UILabel * desLabel;
@end
@implementation KKMyInviteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSubviews];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    self.avatarView.layer.cornerRadius = 16;
    self.avatarView.layer.masksToBounds = true;
    [self.contentView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(16);
        make.width.height.mas_equalTo(32);
    }];
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView);
        make.left.mas_equalTo(self.avatarView.mas_right).offset(8);
    }];
    self.dateLabel = [UILabel new];
    self.dateLabel.textColor = k153Color;
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel);
        make.bottom.mas_equalTo(self.avatarView);
    }];
    self.desLabel = [UILabel new];
    self.desLabel.font = [UIFont systemFontOfSize:14];
    self.desLabel.textColor = k153Color;
    [self.contentView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-16);
    }];
}
-(void)resetWithData:(id)data
{
    KKInviter * inviter = (KKInviter *)data;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:inviter.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
    NSNumber * date = inviter.inv_create;
    if (date && date.integerValue > 0) {
        self.dateLabel.text = [KKDataTool timeStrWithTimeStamp:date.integerValue withTimeFormate:@"yyyy/MM/dd"];
    } else {
        self.dateLabel.text = @"";
    }
    NSString * phoneNumber = inviter.mobile;
    if (phoneNumber && phoneNumber.length == 11) {
        self.nickNameLabel.text = [NSString stringWithFormat:@"%@****%@",[phoneNumber substringToIndex:3],[phoneNumber substringFromIndex:7]];
    }
    if ([HNUBZUtil checkArrEnable:inviter.inv_status]) {
        NSNumber * r = inviter.inv_status.firstObject;
        NSString * des = @"";
        if (r.integerValue == 1) {
            des = @"邀请好友注册";
        } else if (r.integerValue == 2) {
            des = @"好友首次充值";
        } else if (r.integerValue == 4) {
            des = @"好友首次参赛";
        }
        self.desLabel.text = des;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
