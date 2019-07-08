//
//  KKMallTopCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/9/9.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMallTopCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "KKShopListViewController.h"
#import "Masonry.h"
@interface KKMallTopCollectionViewCell()<SDCycleScrollViewDelegate>
@property (strong, nonatomic)SDCycleScrollView *bannerView;
@end

@implementation KKMallTopCollectionViewCell
- (IBAction)clickControl:(UIView *)sender {
    UIViewController * vc = [self viewController];
    KKShopListViewController * shopVC = [[UIStoryboard storyboardWithName:@"KKMall" bundle:nil] instantiateViewControllerWithIdentifier:@"shopList"];
    [vc.navigationController pushViewController:shopVC animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
        [self addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(ScreenWidth * 450/375);
        }];
    [self bringSubviewToFront:self.subviews[0]];
}
-(SDCycleScrollView *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [SDCycleScrollView new];
        _bannerView.delegate = self;
        _bannerView.localizationImageNamesGroup = @[@"mall_banner",@"mall_banner_2",@"mall_banner"];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
       _bannerView.pageDotImage = [UIImage imageNamed:@"dotShort"];
       _bannerView.currentPageDotImage = [UIImage imageNamed:@"dotLong"];
        _bannerView.pageControlDotSize = CGSizeMake(15, 5);
        _bannerView.pageControlBottomOffset = 30;
        _bannerView.layer.masksToBounds = NO;
    }
    return _bannerView;
}
@end
