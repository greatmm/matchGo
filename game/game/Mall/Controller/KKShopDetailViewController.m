//
//  KKShopDetailViewController.m
//  game
//
//  Created by GKK on 2018/9/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKShopDetailViewController.h"
#import "SDCycleScrollView.h"
#import "Masonry.h"
#import "KKEnsureOrderViewController.h"
@interface KKShopDetailViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightCons;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (nonatomic,strong) SDCycleScrollView * bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewToTopCons;

@end

@implementation KKShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([KKDataTool statusBarH] == 20) {
        self.scrollViewToTopCons.constant = -20;
    }
    self.bannerHeightCons.constant = ScreenWidth * 450/375.0;
    [self.bannerBackView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.bannerBackView);
    }];
    self.houseBtm = isIphoneX?(34 + 59):(59);
}
-(SDCycleScrollView *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [SDCycleScrollView new];
        _bannerView.delegate = self;
        _bannerView.localizationImageNamesGroup = @[@"shouban",@"shouban",@"shouban"];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.pageDotImage = [UIImage imageNamed:@"dotShort"];
        _bannerView.currentPageDotImage = [UIImage imageNamed:@"dotLong"];
        _bannerView.pageControlDotSize = CGSizeMake(15, 5);
//        _bannerView.pageControlBottomOffset = 30;
        _bannerView.layer.masksToBounds = NO;
    }
    return _bannerView;
}
- (IBAction)backToFoward:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)share:(id)sender {
    
}
- (IBAction)clickKefu:(id)sender {
}
//兑换
- (IBAction)clickDuhuanBtn:(id)sender {
    KKEnsureOrderViewController * ensureOrderVC = [[UIStoryboard storyboardWithName:@"KKMall" bundle:nil] instantiateViewControllerWithIdentifier:@"ensureOrder"];
    [self.navigationController pushViewController:ensureOrderVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
