//
//  KKGameCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKGameCollectionViewCell.h"
#import "Masonry.h"
@implementation KKGameCollectionViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.nameLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(45);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self);
    }];
}
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor colorWithWhite:51/255.0 alpha:1.0];
    }
    return _nameLabel;
}
@end
