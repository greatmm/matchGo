//
//  KKDeleteImgCollectionViewCell.m
//  game
//
//  Created by greatkk on 2018/12/13.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKDeleteImgCollectionViewCell.h"

@implementation KKDeleteImgCollectionViewCell
-(UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(self.contentView);
        }];
    }
    return _imgView;
}
@end
