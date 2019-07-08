//
//  KKChampionRewardTableViewCell.m
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionRewardTableViewCell.h"
@interface KKChampionRewardTableViewCell()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *imageVIcon;
@end
@implementation KKChampionRewardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        // Initialization code
        [self addSubview:self.labelTitle];
        hnuSetWeakSelf;
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(weakSelf).offset(-H(37));
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(150);
        }];
        [self addSubview:self.imageVIcon];
        [self.imageVIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(H(37));
            //       make.top.equalTo(weakSelf).offset(H(10));
            make.centerY.equalTo(weakSelf.labelTitle);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark set/get
- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle=[[UILabel alloc] initWithText:@"" color:MTK16RGBCOLOR(0x101D37) fontSize:14 forFrame:CGRectZero];
        _labelTitle.textAlignment=NSTextAlignmentRight;
    }
    return _labelTitle;
}
- (UIImageView *)imageVIcon
{
    if (!_imageVIcon) {
        _imageVIcon=[[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageVIcon;
}
#pragma mark Method
- (void)resetWithData:(id)data
{
    _labelTitle.text=[NSString stringWithFormat:@"%@%%",data];
    NSString *imageName=[NSString stringWithFormat:@"NO%d",_index];
    _imageVIcon.image=MTKImageNamed(imageName);
}
@end
