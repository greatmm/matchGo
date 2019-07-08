//
//  KKEnsureOrderViewController.m
//  game
//
//  Created by GKK on 2018/9/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKEnsureOrderViewController.h"
#import "KKEnsurePayView.h"
#import "Masonry.h"
@interface KKEnsureOrderViewController ()
@property (weak, nonatomic) IBOutlet UIControl *addressView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *btmPriceLabel;

@end

@implementation KKEnsureOrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)clickAddAddress:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    UILabel * l = [UILabel new];
    l.text = @"+添加收货地址";
    l.textColor = [UIColor colorWithRed:20/255.0 green:25/255.0 blue:30/255.0 alpha:1];
    l.font = [UIFont systemFontOfSize:14];
    [self.addressView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.addressView);
    }];
}

- (IBAction)add:(id)sender {
    NSInteger count = self.numberLabel.text.integerValue + 1;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)(6600 * count)];
    self.btmPriceLabel.text = self.priceLabel.text;
}
- (IBAction)min:(id)sender {
     NSInteger count = self.numberLabel.text.integerValue - 1;
    if (count == 0) {
        return;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
    self.priceLabel.text = [NSString stringWithFormat:@"%ld",6600 * count];
    self.btmPriceLabel.text = self.priceLabel.text;
}
//提交订单
- (IBAction)clickSubmitOrder:(id)sender {
//    KKEnsurePayView * payView = [KKEnsurePayView sharePayView];
//    [[UIApplication sharedApplication].delegate.window addSubview:payView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
