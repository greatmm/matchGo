//
//  KKPersonalTableViewController.m
//  game
//
//  Created by GKK on 2018/8/8.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKPersonalTableViewController.h"
#import "KKNavigationController.h"
#import "KKUser.h"
#import "KKDataTool.h"
#import "KKChongzhiViewController.h"
#import "KKUpdownBtn.h"
#import "KKWalletViewController.h"
#import "KKChongzhiViewController.h"
#import "KKAccountBalanceModel.h"
#import "KKEnterInvcodeView.h"
#import "KKMyInviteViewController.h"
@interface KKPersonalTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;//用户昵称
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;//头像
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮
@property (strong, nonatomic) IBOutletCollection(KKUpdownBtn) NSArray *btns;//钻石，金币，入场券按钮
//@property (strong,nonatomic) NSDictionary * personWallet;//获取到的用户账户余额
@property (weak, nonatomic) IBOutlet UIView *chongzhiView;//充值棕色view
@property (weak, nonatomic) IBOutlet UIImageView *arrowRight;//右侧的小箭头
@property (strong,nonatomic) KKAccountBalanceModel* model;//获取到的用户账户余额
@property (assign,nonatomic) BOOL hasInvited;//是否已经邀请过了(暂时使用)
@end

@implementation KKPersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUi];
    [self addNoti];
    [self refreshData];
}
//初始化界面
- (void)initUi
{
    //    self.houseBtm = [KKDataTool tabBarH];
    self.navigationItem.title = @"";
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //左上角我的
    self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"message_white"];
    UILabel * l = [UILabel new];
    l.text = @"我的";
    l.font = [UIFont boldSystemFontOfSize:20];
    l.textColor = [UIColor whiteColor];
    l.frame = CGRectMake(0, 0, 50, 40);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:l];
    self.tableView.tableHeaderView.backgroundColor = kThemeColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 52;
    //给账户余额赋初始值
    NSArray * arr = @[@{@"title":@"钻石",@"number":@0},@{@"title":@"金币",@"number":@0},@{@"title":@"入场券",@"number":@0}];
    for (int i = 0; i < 3; i ++) {
        NSDictionary * dict = arr[i];
        KKUpdownBtn * btn = self.btns[i];
        NSString * tit = dict[@"title"];
        if (tit) {
            btn.textLabel.text = tit;
        }
        NSNumber * num = dict[@"number"];
        if (num) {
            //换成带逗号的格式
            btn.numberLabel.text = [KKDataTool decimalNumber:num fractionDigits:0];
        }
    }
}
//添加通知
- (void)addNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KKLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KKLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:KKRechargeSuccessNotification object:nil];
}
//登录或退出登录对数据的处理
- (void)refreshData
{
    [self refreshUI];
    KKUser * user = [KKDataTool user];
    if (user && user.inv_code == nil) {
        //登录了，并且没有邀请码的数据
        [self refreshUserData];
    } else {
        if (user) {
            //有值直接更新
            self.hasInvited = (user.inviter.integerValue != 0);
        } else {
            //未登录
            self.hasInvited = false;
        }
    }
}
-(void)setHasInvited:(BOOL)hasInvited
{
    if (_hasInvited == hasInvited) {
        return;
    }
    _hasInvited = hasInvited;
    [self.tableView reloadData];
}
//点击充值
- (IBAction)clickChongzhiBtn:(id)sender {
    kkLoginMacro
    KKChongzhiViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"chongzhiVC"];
    vc.isChongzhi = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.chongzhiView addCornersWithRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerSize:CGSizeMake(10, 10)];
}
//点击顶部，跳至个人资料
- (IBAction)clickTopControl:(id)sender {
    if ([KKDataTool token] == nil) {
        [self loginIn:nil];
        return;
    }
    UIViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"peronalInfo"];
    [self.navigationController pushViewController:cv animated:YES];
}

//点击上边三个button，跳到账户列表
- (IBAction)clickTopBtn:(UIButton *)sender {
    if ([KKDataTool token] == nil) {
        [self loginIn:nil];
        return;
    }
    KKWalletViewController * walletVC = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"myWallet"];
    walletVC.type = sender.tag;
    walletVC.model = self.model;
    [self.navigationController pushViewController:walletVC animated:YES];
}
//点击登录按钮
- (IBAction)loginIn:(id)sender {
    [KKDataTool showLoginVc];
}
//给用户赋值
- (void)assignUI
{
    KKUser * user = [KKDataTool user];
    if (user) {
        self.loginBtn.hidden = YES;
        self.arrowRight.hidden = NO;
        self.userNameLabel.text = user.nickname;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
    } else {
        self.loginBtn.hidden = NO;
        self.arrowRight.hidden = YES;
        self.userNameLabel.text = @"";
        self.avatarImageView.image = [UIImage imageNamed:@"icon"];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kThemeColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden = NO;
    KKNavigationController * nav = (KKNavigationController *)self.navigationController;
    [nav removeShadow];
    [self refreshUI];
}
#pragma mark - 刷新邀请码等用户数据
- (void)refreshUserData
{
    [KKDataTool refreshUserInfoWithSuccessBlock:^(NSDictionary *dic) {
        KKUser * u = [KKDataTool user];
        self.hasInvited = (u.inviter.integerValue != 0);
    } erreorBlock:^(NSError *error) {}];
}
- (void)refreshUI
{
    [self assignUI];
    //由于账户余额变化较为频繁，每次都刷新
    if ([KKDataTool token]) {
        if (self.model.boolRequesting == true) {
            return;
        }
        __weak typeof(self) weakSelf = self;
        [self.model fetchWithPath:[NSString stringWithFormat:@"%@account/wallet",baseUrl] type:MTKFetchModelTypeGET completion:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error) {
            if (isSucceeded) {
                KKUpdownBtn * btn = self.btns[0];
                btn.numberLabel.text = [KKDataTool decimalNumber:weakSelf.model.diamond fractionDigits:0];
                KKUpdownBtn * btn1 = self.btns[1];
                btn1.numberLabel.text = [KKDataTool decimalNumber:weakSelf.model.gold fractionDigits:0];
                KKUpdownBtn * btn2 = self.btns[2];
                btn2.numberLabel.text = [KKDataTool decimalNumber:weakSelf.model.ticket fractionDigits:0];
            }
        }];
    } else {
        for (int i = 0; i < 3; i ++) {
            KKUpdownBtn * btn = self.btns[i];
            btn.numberLabel.text = @"0";
        }
    }
}
-(KKAccountBalanceModel *)model
{
    if (_model) {
        return _model;
    }
    _model = [[KKAccountBalanceModel alloc] init];
    return _model;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.hasInvited?1:2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //,@"orderVC",@"helpVC"
    if (indexPath.row != 4) {
        kkLoginMacro
    }
//    @"helpVC"
    NSArray <NSString*>* arr = @[@"freeMatches",@"gameList",@"managerRoleVC",@"SettingTableViewController"];
    if (self.hasInvited == false && indexPath.section == 0) {
        [self showEnterInviteCodeView];
    } else {
        UIViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:arr[indexPath.row]];
        [self.navigationController pushViewController:cv animated:YES];
    }
}
- (void)showEnterInviteCodeView
{
    //输入邀请码
    KKEnterInvcodeView * invCodeView = [KKEnterInvcodeView shareInvcodeView];
    [self.view.window addSubview:invCodeView];
    invCodeView.clickBtmBtnBlock = ^(NSString * inviteCode){
        [self enterInviteCode:inviteCode];
    };
    [invCodeView performSelector:@selector(showKeyboard) onThread:[NSThread mainThread] withObject:nil waitUntilDone:false];
}
- (void)enterInviteCode:(NSString *)inviteCode
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    MTKFetchModel * model = [[MTKFetchModel alloc] init];
    [model fetchWithPath:[NSString stringWithFormat:@"%@account/inviter/%@",baseUrl,inviteCode] type:MTKFetchModelTypePOST completionWithData:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error, id  _Nullable responseObjectData) {
        [KKAlert dismissWithView:self.view];
        if (isSucceeded) {
            [KKAlert showText:@"提交成功" toView:self.view];
            [self refreshUserData];//邀请成功，刷新数据
        } else {
            [KKAlert showText:msg toView:self.view];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasInvited) {
        return 4;
    }
    return section>0?4:1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuse = @"personalCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    if (self.hasInvited == false && indexPath.section == 0) {
        cell.textLabel.text = @"输入邀请码";
        cell.imageView.image = [UIImage imageNamed:@"my_0"];
    } else {
        NSArray * arr = @[@"免费比赛",@"我的比赛",@"角色管理",@"设置"];
        cell.textLabel.text = arr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"my_%ld",(long)indexPath.row + 1]];
    }
    return cell;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
