//
//  KKChongzhiViewController.m
//  game
//
//  Created by GKK on 2018/8/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKChongzhiViewController.h"
#import "KKWebViewController.h"
#import "KKChongzhiControl.h"
#import "KKBottomButton.h"
#import "KKSelectPaytypeView.h"
#import "PBAlipayApiManager.h"
@interface KKChongzhiViewController ()
@property (nonatomic,strong) UIControl * priceControl;
@property (nonatomic,assign) NSInteger payType;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;//当前余额
@property (weak, nonatomic) IBOutlet UILabel *label1;//描述 钻石余额还是金币余额
@property (weak, nonatomic) IBOutlet UILabel *label2;//充值金额还是兑换金额
@property (strong, nonatomic) IBOutletCollection(KKChongzhiControl) NSArray *controlArr;
@property (weak, nonatomic) IBOutlet KKBottomButton *btmBtn;
@property (weak, nonatomic) IBOutlet UIView *goldView;//金币兑换时下边的view，包括支付方式，钻石余额显示
@property (weak, nonatomic) IBOutlet UILabel *currentZuanLabel;//兑换时，显示当前的钻石余额
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImgView;//右上角的图标
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginCons;//第一个label距离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldViewHeight;//充值时显示下边view的高度
@property (strong,nonatomic) UITextField * goldTf;//输入其它余额
@property (strong,nonatomic) UILabel * feeLabel;//花费多少钻石
@property (strong,nonatomic) UILabel * showZuanLabel;//有其它金额时显示当前的钻石余额
@property (weak, nonatomic) IBOutlet UIView *btmView;//显示用户充值手册view
@property (strong,nonatomic) KKSelectPaytypeView * aliPaytypeView;//支付宝支付的方式
@property (strong,nonatomic) KKSelectPaytypeView * wechatPaytypeView;//微信支付的方式
#warning 暂时去掉苹果支付，添加支付宝支付
@end

@implementation KKChongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseBtm = isIphoneX?(34 + 59):(59);
    NSString * navTitle = @"钻石充值";
    if (self.isChongzhi == NO) {
        navTitle = @"金币兑换";
        self.rightTopImgView.image = [UIImage imageNamed:@"coin_big"];
        self.label1.text = @"金币余额";
        self.label2.text = @"兑换金额";
        [self.btmBtn setTitle:@"金币兑换" forState:UIControlStateNormal];
        self.btmView.hidden = YES;
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDiamondSuccess) name:KKRechargeSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDiamondFail:) name:KKRechargeFailureNotification object:nil];
    }
    self.navigationItem.title = navTitle;
    [self assignControl];
    if (self.isChongzhi) {
        //需要哪种就打开哪种，选择一种UI即可
        [self layoutAliPay];
//        [self layoutApplePay];
//        [self layoutWeixinPayAndAliPay];
    }
    if (self.isChongzhi == NO && self.lackGold > 0) {
        [self addTopHintView];
        [self dealGoldView];
    }
    [self getCurrentAccount];
}
#pragma mark - 苹果支付的UI
- (void)layoutApplePay
{
    self.goldView.hidden = self.isChongzhi;//充值就把下边的内容隐藏
    self.payType = 1;//苹果支付
}
#pragma mark - 仅添加支付宝支付
- (void)layoutAliPay
{
    [self.goldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel * l = [UILabel new];
    l.text = @"支付方式";
    l.textColor = [UIColor colorWithHexString:@"#9399A5"];
    l.font = [UIFont systemFontOfSize:16];
    [self.goldView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.goldView);
    }];
//    __weak typeof(self) weakSelf = self;
    self.aliPaytypeView = [KKSelectPaytypeView new];
    self.aliPaytypeView.textLabel.text = @"支付宝";
    self.aliPaytypeView.imageView.image = [UIImage imageNamed:@"aliPay"];
    self.aliPaytypeView.tag = 2;
    [self.goldView addSubview:self.aliPaytypeView];
    self.aliPaytypeView.selectImgView.highlighted = true;
    self.payType = 2;//支付宝支付
//    self.aliPaytypeView.clickBlock = ^{
//        weakSelf.wechatPaytypeView.selectImgView.highlighted = NO;
//        weakSelf.payType = 2;
//    };

    [self.aliPaytypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.goldView);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(l.mas_bottom).offset(14);
    }];
    self.goldViewHeight.constant = 80;
    [self.view layoutIfNeeded];
}
#pragma mark - 微信和支付宝支付
- (void)layoutWeixinPayAndAliPay
{
    [self.goldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel * l = [UILabel new];
    l.text = @"支付方式";
    l.textColor = [UIColor colorWithHexString:@"#9399A5"];
    l.font = [UIFont systemFontOfSize:16];
    [self.goldView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.goldView);
    }];
    __weak typeof(self) weakSelf = self;
    self.aliPaytypeView = [KKSelectPaytypeView new];
    self.aliPaytypeView.textLabel.text = @"支付宝";
    self.aliPaytypeView.imageView.image = [UIImage imageNamed:@"aliPay"];
    self.aliPaytypeView.tag = 2;
    [self.goldView addSubview:self.aliPaytypeView];
    self.aliPaytypeView.clickBlock = ^{
        weakSelf.wechatPaytypeView.selectImgView.highlighted = NO;
        weakSelf.payType = 2;
    };
    self.wechatPaytypeView = [KKSelectPaytypeView new];
    self.wechatPaytypeView.textLabel.text = @"微信";
    self.wechatPaytypeView.imageView.image = [UIImage imageNamed:@"wechatPay"];
    self.wechatPaytypeView.tag = 3;
    [self.goldView addSubview:self.wechatPaytypeView];
    self.wechatPaytypeView.clickBlock = ^{
        weakSelf.aliPaytypeView.selectImgView.highlighted = NO;
        weakSelf.payType = 3;
    };
    [self.wechatPaytypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.goldView);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(l.mas_bottom).offset(14);
    }];
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor colorWithWhite:112/255.0 alpha:0.1];
    [self.goldView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goldView).offset(30);
        make.right.mas_equalTo(self.goldView).offset(16);
        make.top.mas_equalTo(self.wechatPaytypeView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.aliPaytypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.wechatPaytypeView);
        make.top.mas_equalTo(line.mas_bottom);
    }];
    self.goldViewHeight.constant = 110;
    [self.view layoutIfNeeded];
}
//添加顶部的提示view
- (void)addTopHintView
{
    self.topMarginCons.constant = self.topMarginCons.constant + 36;
    UIView * hintView = [UIView new];
    hintView.backgroundColor = [UIColor colorWithHexString:@"#FBF1CD"];
    hintView.frame = CGRectMake(0, 0, ScreenWidth, 36);
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning"]];
    imgView.frame = CGRectMake(16, 10, 16, 16);
    [hintView addSubview:imgView];
    UILabel * l = [UILabel new];
    l.font = [UIFont boldSystemFontOfSize:14];
    l.textColor = [UIColor colorWithHexString:@"#4F3E02"];
    l.text = [NSString stringWithFormat:@"金币不足，还需要%ld金币!",self.lackGold];
    l.frame = CGRectMake(42, 0, ScreenWidth - 42, 36);
    [hintView addSubview:l];
    [self.view addSubview:hintView];
}
- (void)dealGoldView
{
    [self.goldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel * l = [UILabel new];
    l.text = @"其它金额";
    l.textColor = kTitleColor;
    l.font = [UIFont systemFontOfSize:16];
    [self.goldView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.goldView);
    }];
    UIImageView * goldIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin_big"]];
    [self.goldView addSubview:goldIcon];
    [self.goldView addSubview:self.goldTf];
    [goldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goldView);
        make.centerY.mas_equalTo(self.goldTf);
        make.width.height.mas_equalTo(18);
    }];
    [self.goldTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(l.mas_bottom).offset(20);
        make.left.mas_equalTo(goldIcon.mas_right).offset(5);
        make.right.mas_equalTo(self.goldView);
        make.height.mas_equalTo(30);
    }];
    UIView * line = [UIView new];
    line.backgroundColor = kBackgroundColor;
    [self.goldView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.goldView);
        make.top.mas_equalTo(self.goldTf.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    UILabel * l1 = [UILabel new];
    l1.text = @"使用钻石";
    l1.textColor = kTitleColor;
    l1.font = [UIFont systemFontOfSize:12];
    [self.goldView addSubview:l1];
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(20);
        make.left.mas_equalTo(line);
    }];
    [self.goldView addSubview:self.feeLabel];
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(l1);
        make.left.mas_equalTo(l1.mas_right).offset(5);
    }];
    [self.goldView addSubview:self.showZuanLabel];
    [self.showZuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goldView);
        make.centerY.mas_equalTo(l1);
    }];
    self.goldViewHeight.constant = 112;
    [self.view layoutIfNeeded];
    self.goldTf.text = [NSString stringWithFormat:@"%ld",self.lackGold];
    [self goldChanged:self.goldTf];
}
- (UITextField *)goldTf
{
    if (_goldTf) {
        return _goldTf;
    }
    _goldTf = [UITextField new];
    _goldTf.textColor = kThemeColor;
    _goldTf.font = [UIFont fontWithName:@"bahnschrift" size:24];
    _goldTf.keyboardType = UIKeyboardTypeNumberPad;
    [_goldTf addTarget:self action:@selector(goldChanged:) forControlEvents:UIControlEventEditingChanged];
    return _goldTf;
}
- (void)goldChanged:(UITextField *)tf
{
    NSInteger gold = tf.text.integerValue;
    NSInteger zuanNo = ceilf(gold/10.0);
    self.feeLabel.text = [NSString stringWithFormat:@"%ld",zuanNo];
}
-(UILabel *)feeLabel
{
    if (_feeLabel) {
        return _feeLabel;
    }
    _feeLabel = [UILabel new];
    _feeLabel.textColor = kTitleColor;
    _feeLabel.font = [UIFont systemFontOfSize:12];
    return _feeLabel;
}
-(UILabel *)showZuanLabel
{
    if (_showZuanLabel) {
        return _showZuanLabel;
    }
    _showZuanLabel = [UILabel new];
    _showZuanLabel.font = [UIFont systemFontOfSize:12];
    _showZuanLabel.textColor = [UIColor colorWithHexString:@"#9399A5"];
    return _showZuanLabel;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)addDiamondSuccess
{
    [KKAlert showText:@"充值成功" toView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addDiamondFail:(NSNotification *)noti
{
    PBPayResultInfo *info = noti.object;
    [KKAlert showText:info.resultView toView:self.view];
}
- (void)assignControl
{
    NSArray * arr;
    if (self.isChongzhi) {
//        arr = @[@{@"coin":@"42",@"price":@"6元"},@{@"coin":@"84",@"price":@"12元"},@{@"coin":@"210",@"price":@"30元"},@{@"coin":@"350",@"price":@"50元"},@{@"coin":@"896",@"price":@"128元"},@{@"coin":@"4326",@"price":@"618元"}];//苹果支付的值
        arr = @[@{@"coin":@"9",@"price":@"1元"},@{@"coin":@"90",@"price":@"10元"},@{@"coin":@"450",@"price":@"50元"},@{@"coin":@"900",@"price":@"100元"},@{@"coin":@"4500",@"price":@"500元"},@{@"coin":@"9000",@"price":@"1000元"}];
    } else {
        arr = @[@{@"coin":@"10",@"price":@"1钻"},@{@"coin":@"100",@"price":@"10钻"},@{@"coin":@"500",@"price":@"50钻"},@{@"coin":@"1000",@"price":@"100钻"},@{@"coin":@"5000",@"price":@"500钻"},@{@"coin":@"10000",@"price":@"1000钻"}];
    }
    for (int i = 0 ; i < 6; i ++) {
        KKChongzhiControl * control = self.controlArr[i];
        control.dataDic = arr[i];
    }
}
//获取当前账户余额
- (void)getCurrentAccount
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    [KKNetTool getMyWalletSuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
//        NSArray * keys = @[@"diamond",@"gold",@"ticket"];
        NSString * key;
        if (self.isChongzhi) {
            key = @"diamond";
        } else {
            key = @"gold";
            NSString * zuanY = [NSString stringWithFormat:@"钻石余额:%@",dic[@"diamond"]];
            if(self.lackGold > 0){
                self.showZuanLabel.text = zuanY;
            } else {
                self.currentZuanLabel.text = zuanY;
            }
        }
        NSNumber * dia = dic[key];
        self.yueLabel.text = [KKDataTool decimalNumber:dia fractionDigits:0];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
    }];
}
- (IBAction)selectPrice:(UIControl *)sender {
    if (self.priceControl == sender) {
        return;
    }
    if (self.priceControl) {
        [self.priceControl setSelected:NO];
    }
    [sender setSelected:!sender.selected];
    self.priceControl = sender;
    if (self.lackGold > 0) {
        NSArray * arr = @[@"10",@"100",@"500",@"1000",@"5000",@"10000"];
        self.goldTf.text = arr[self.priceControl.tag];
        [self goldChanged:self.goldTf];
    }
}
//- (IBAction)selectPayType:(UIView *)sender {
////    if (sender.tag == self.payType) {
////        return;
////    }
////    self.payType = sender.tag;
////    self.aliCycle.highlighted = self.payType == 1;
////    self.wepayCycle.highlighted = !self.aliCycle.highlighted;
//}

//充值
- (IBAction)gotoPay:(id)sender {
    NSInteger zuanCount = 0;
    if (self.lackGold > 0) {
        zuanCount = self.feeLabel.text.integerValue;
        if (zuanCount <= 0) {
            [KKAlert showText:@"请输入兑换数量" toView:self.view];
            return;
        }
    } else {
        if (self.priceControl == nil) {
            NSString * hintTitle = self.isChongzhi?@"请选择充值数量":@"请选择兑换数量";
            [KKAlert showText:hintTitle toView:self.view];
            return;
        }
    }
    
    if (self.isChongzhi) {
        if (self.payType == 0) {
            [KKAlert showText:@"请选择支付方式" toView:self.view];
            return;
        }
        NSArray * arr;
//        [KKAlert showAnimateWithText:nil toView:self.view];
        switch (self.payType) {
            case 1:
            {
                //苹果支付
                arr = @[@42,@84,@210,@350,@896,@4326];
//                [[PBAlipayApiManager sharedManager] payWithDiamond:((NSNumber *)(arr[self.priceControl.tag])).integerValue channel:PBPayChannelAppstore];
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 2:
            {
                //支付宝支付
                arr = @[@9,@90,@450,@900,@4500,@9000];
                NSNumber * dia = arr[self.priceControl.tag];
//#ifdef kkDEBUGEnvironment
//                dia = @1;
//#else
//                dia = arr[self.priceControl.tag];
//#endif
                [[PBAlipayApiManager sharedManager] payWithDiamond:dia.integerValue channel:PBPayChannelAlipay];
                break;
            }
                case 3:
            {
                //微信支付
                arr = @[@9,@90,@450,@900,@4500,@9000];
                [[PBAlipayApiManager sharedManager] payWithDiamond:((NSNumber *)(arr[self.priceControl.tag])).integerValue channel:PBPayChannelWechat];
                break;
            }
            default:
                break;
        }
//    channel:1苹果 2支付宝 3微信 4其它
//        switch (_payType) {
//            case 1:
//                {
//                    [[PBAlipayApiManager sharedManager] payWithDiamond:((NSNumber *)(arr[self.priceControl.tag])).integerValue channel:PBPayChannelAlipay];
//                }
//                break;
//            case 2:
//            {
//
//            }
//                break;
//            default:
//                break;
//        }
        
//        [KKNetTool createPaymentOrderWithParm:@{@"channel":@2,@"diamond":arr[self.priceControl.tag]} SuccessBlock:^(NSDictionary *dic) {
//            [KKAlert dismissWithView:self.view];
//            [[PBAlipayApiManager sharedManager] payWithInfo:dic[@"wapurl"] order:nil];
//            //调起苹果支付的通知
//            NSNumber * index = [NSNumber numberWithInteger:self.priceControl.tag];
//
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"buydDiamond" object:@{@"orderId":dic[@"orderid"],@"index":index}];
//        } erreorBlock:^(NSError *error) {
//            [KKAlert dismissWithView:self.view];
//            [KKAlert showText:@"生成订单失败" toView:self.view];
//        }];
    } else {
        [KKAlert showAnimateWithText:nil toView:self.view];
        NSArray * arr = @[@1,@10,@50,@100,@500,@1000];
        NSNumber * diaCount;
        if (self.lackGold > 0) {
            diaCount = [NSNumber numberWithInteger:zuanCount];
        } else {
            diaCount = arr[self.priceControl.tag];
        }
        [KKNetTool exchangeGlodWithDiamond:diaCount SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:self.view];
            [KKAlert showText:@"兑换成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.chongzhiBlock) {
                self.chongzhiBlock();
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:self.view];
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            } else {
                [KKAlert showText:@"兑换失败" toView:self.view];
            }
        }];
    }
}
//阅读充值手册
- (IBAction)readProtocal:(id)sender {
    KKWebViewController * webVc = [KKWebViewController new];
    webVc.webTitle = @"Match go充值服务协议";
    [webVc loadLocalFile:@"MatchGoChongzhiProtocal.docx"];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
