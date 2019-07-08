//
//  KKChampionMoneyRankTableViewCell.m
//  game
//
//  Created by greatkk on 2018/11/6.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChampionMoneyRankTableViewCell.h"
#import "KKChampionTopModel.h"

@interface KKChampionMoneyRankTableViewCell ()
@property (strong,nonatomic) UILabel * winCountLabel;//胜利次数
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;//排名
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//用户昵称
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//赢了多少钱

@property (strong,nonatomic) UIImageView * arrowImageView;//查看的箭头
@property (strong,nonatomic) UILabel * lookLabel;//查看label
@end
@implementation KKChampionMoneyRankTableViewCell
- (UIView *)getLine
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 00, kScreenWidth, 8)];
    view.backgroundColor=MTK16RGBCOLOR(0xF9F9F9);
    [self addSubview:view];
    return view;
}
- (void)setShowLines:(BOOL)show
{
    //零时方案 绘制上下line
    UIView *line1=[self viewWithTag:1234];
    UIView *line2=[self viewWithTag:1235];
    if (show) {
        
        if (!line1) {
            line1=[self getLine];
            
            line1.tag=1234;
        }
        line1.hidden=false;
        
        if (!line2) {
            line2=[self getLine];
            line2.bottom=65+16;
            line2.tag=1235;
        }
        line1.hidden=false;
    }
    else
    {
        if (line1) {
            line1.hidden=true;
        }
        if (line2) {
            line2.hidden=true;
        }
        
    }
}
-(void)setRank:(NSInteger)rank
{
    if (_rank == rank) {
        return;
    }
    _rank = rank;
    if (_rank < 6) {
        NSString * imgName = [NSString stringWithFormat:@"NO%ld",(long)_rank];
        UIImage * image = [UIImage imageNamed:imgName];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]init];
        NSTextAttachment * attchment = [NSTextAttachment new];
        attchment.bounds = CGRectMake(0, 0, 18, 20);
        attchment.image = image;
        NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
        [str appendAttributedString:string];
        self.rankLabel.attributedText = str;
    } else {
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)_rank];
    }
}
- (void)arrowShow:(BOOL)show
{
    if (show) {
        self.avatarImgView.hidden=false;
        self.lookLabel.hidden=false;
        hnuSetWeakSelf;
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView).offset(-10);
        }];
        [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.arrowImageView.mas_left).offset(-8);
            make.top.mas_equalTo(weakSelf.contentView.centerY);
        }];
    }
    else
    {
        self.avatarImgView.hidden=true;
        self.lookLabel.hidden=true;
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.winCountLabel = [UILabel new];
    self.winCountLabel.text = @"8";
    self.winCountLabel.textColor = [UIColor colorWithHexString:@"#101D37"];
    self.winCountLabel.font = [UIFont systemFontOfSize:12];
    self.winCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.winCountLabel];
    [self.winCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ScreenWidth * 0.5 + 25-26);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(100);
    }];
}
- (void)resetWithData:(id)data
{
    KKChampionTopModel *model=data;
    if (model.firstShow) {
        [self setShowLines:true];
    }
    else [self setShowLines:false];
    self.rank=model.rank;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.nickNameLabel.text = model.name;
    NSMutableAttributedString * s = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",model.award] attributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    UIImage * image = [UIImage imageNamed:@"coin_big"];
    NSTextAttachment * attchment = [NSTextAttachment new];
    attchment.bounds = CGRectMake(0, 0, 18, 20);
    attchment.image = image;
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
    [s appendAttributedString:string];
    self.moneyLabel.attributedText = s;
    if (model.type==KKChampionshipsTypeLadder) {
        self.winCountLabel.text = [NSString stringWithFormat:@"%0.1f",model.total_value];
        [self arrowShow:model.canLook];
    }
    else
    {
        self.winCountLabel.text = [NSString stringWithFormat:@"%ld",model.win];
    }
   
}
-(void)assignWithDic:(NSDictionary *)dic
{
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.nickNameLabel.text = dic[@"name"];
    NSMutableAttributedString * s = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dic[@"award"]] attributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    UIImage * image = [UIImage imageNamed:@"coin_big"];
    NSTextAttachment * attchment = [NSTextAttachment new];
    attchment.bounds = CGRectMake(0, 0, 18, 20);
    attchment.image = image;
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
    [s appendAttributedString:string];
    self.moneyLabel.attributedText = s;
    self.winCountLabel.text = [NSString stringWithFormat:@"%@",dic[@"win"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark set/get
-(UIImageView *)arrowImageView
{
    if (_arrowImageView) {
        return _arrowImageView;
    }
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_gray"]];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    return _arrowImageView;
}
-(UILabel *)lookLabel
{
    if (_lookLabel) {
        return _lookLabel;
    }
    _lookLabel = [UILabel new];
    _lookLabel.font = [UIFont systemFontOfSize:10];
    _lookLabel.text = @"查看";
    _lookLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    [self.contentView addSubview:_lookLabel];
    return _lookLabel;
}
@end
