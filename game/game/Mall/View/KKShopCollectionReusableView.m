//
//  KKShopCollectionReusableView.m
//  game
//
//  Created by GKK on 2018/9/7.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKShopCollectionReusableView.h"

@implementation KKShopCollectionReusableView
-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.frame = CGRectMake(10, 20, 200, 28);
    }
    return _titleLabel;
}
@end
