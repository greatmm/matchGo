//
//  KKInviteTopTableViewCell.m
//  game
//
//  Created by greatkk on 2019/1/16.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKInviteTopTableViewCell.h"
#import "KKInviteTopModel.h"

@interface  KKInviteTopTableViewCell()
@property (strong,nonatomic) UILabel * rankLabel;//排名
@property (strong,nonatomic) UIImageView * avatarView;//头像
@property (strong,nonatomic) UILabel * nickNameLabel;//昵称
@property (strong,nonatomic) UILabel * ticketLabel;//几张入场券
@property (strong,nonatomic) UILabel * inviteCountLabel;//邀请人数
@end

@implementation KKInviteTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubviews];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    self.rankLabel = [UILabel new];
    self.rankLabel.textColor = kTitleColor;
    self.rankLabel.font = [UIFont systemFontOfSize:14];
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(54, 20));
    }];
    self.avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    self.avatarView.layer.cornerRadius = 16;
    self.avatarView.layer.masksToBounds = true;
    [self.contentView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.rankLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.textColor = kTitleColor;
    self.nickNameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.avatarView.mas_right).offset(8);
    }];
    self.inviteCountLabel = [UILabel new];
    self.inviteCountLabel.font = [UIFont systemFontOfSize:14];
    self.inviteCountLabel.textColor = kTitleColor;
    self.inviteCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.inviteCountLabel];
    [self.inviteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(76);
    }];
    self.ticketLabel = [UILabel new];
    self.ticketLabel.textAlignment = NSTextAlignmentCenter;
    self.ticketLabel.textColor = [UIColor colorWithHexString:@"#FF801B"];
    self.ticketLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.ticketLabel];
    [self.ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ScreenWidth * 0.5);
        make.right.mas_equalTo(self.inviteCountLabel.mas_left);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
-(void)resetWithData:(id)data
{
    KKInviteTopModel * model = (KKInviteTopModel*)data;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.nickNameLabel.text = model.nickname;
    self.inviteCountLabel.text = [NSString stringWithFormat:@"%@",model.invitee_count];
    if (model.sum_tickets) {
        NSString * str = [NSString stringWithFormat:@"%@入场券",model.sum_tickets];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        UIImage * image = [UIImage imageNamed:@"awardTicketIcon"];
        NSTextAttachment * attchment = [NSTextAttachment new];
        attchment.bounds = CGRectMake(0, 0, 19, 13);
        attchment.image = image;
        NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
        [attrStr appendAttributedString:string];
        self.ticketLabel.attributedText = attrStr;
    } else {
        self.ticketLabel.text = @"";
    }
    if (model.rank < 6) {
        UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"NO%ld",model.rank]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        NSTextAttachment * attchment = [NSTextAttachment new];
        attchment.bounds = CGRectMake(0, 0, 18, 20);
        attchment.image = img;
        NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
        [attrStr appendAttributedString:string];
        self.rankLabel.attributedText = attrStr;
    } else {
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.rank];
    }
}
@end
