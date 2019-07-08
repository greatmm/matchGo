//
//  KKBigHouseViewController.m
//  game
//
//  Created by greatkk on 2018/11/22.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBigHouseViewController.h"
#import "KKStepView.h"//显示第几步
#import "KKBigHouseListTableViewCell.h"//消失用户的cell
#import "AppDelegate.h"//代理用来获取当前控制器，判断tabbar是否隐藏
#import "KKSmallHouseViewController.h"//小房间
#import "KKRoomUser.h"//比赛中的用户的模型
#import "KKSubmitResultViewController.h"//提交结果图片控制器
#import "KKHintView.h"
#import "KKAlertViewStyleTwoBtmBtn.h"
#import "KKBindAccountViewController.h"
#import "KKChongzhiViewController.h"
#import "KKAppealViewController.h"
#import "LGPhotoPickerBrowserViewController.h"
#import "KKExplainViewController.h"
#import "KKHouseTipsView.h"
//#import "KKShareView.h"
#import "KKShareTool.h"

#define kTableHeader 192
@interface KKBigHouseViewController ()<UITableViewDelegate,UITableViewDataSource,LGPhotoPickerBrowserViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;//显示主要信息
@property (weak, nonatomic) IBOutlet UIView *bigHouseView;//大房间，所有的视图都在此视图上
@property (strong,nonatomic) UIView * smallHouseView;//小房间

@property (weak, nonatomic) IBOutlet UIButton *btmBtn;//底部开始按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;//左上角返回或缩小按钮
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//房间标题
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navToTop;//导航栏距离顶部的距离

@property (strong,nonatomic) KKStepView * stepView;//第几步
@property (strong,nonatomic) UIView * sectionHeaderView;//分区头
@property (weak,nonatomic) IBOutlet UIImageView * gameIcon;//游戏图标
@property (weak,nonatomic) IBOutlet UILabel * choiceLabel;//比赛内容
@property (weak,nonatomic) IBOutlet UILabel * peopleCountLabel;//人数
@property (weak,nonatomic) IBOutlet UILabel * feeLabel;//多少入场费
@property (weak,nonatomic) IBOutlet UILabel * totalGlodLabel;//最多可赢
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;//背景大图
@property (nonatomic,strong) NSDictionary * gamerInfo;//用户绑定信息
@property (nonatomic,strong) dispatch_source_t timer;//计时器
@property (nonatomic,strong) NSMutableArray * peopleArr;//当前坐下的人房间,所有的user
@property (nonatomic,assign) NSInteger peopleCount;//几人间
@property (assign,nonatomic) NSInteger currentPeopleCount;//当前房间内人数
@property (weak, nonatomic) IBOutlet UIView *navView;//导航栏
@property (weak, nonatomic) IBOutlet UIImageView *lockImgView;//是否是私密房间

@property (nonatomic,assign) BOOL shouldLeave;//是否可以离开房间
@property (nonatomic,assign) NSInteger beginTime;//开始时间
@property (assign,nonatomic) NSInteger deadTime;//提交比赛结果的最后时间
@property (nonatomic,assign) BOOL isFull;//是否坐满了
@property (nonatomic,assign) BOOL isSitdown;//自己是否坐下了
@property (nonatomic,assign) NSInteger bind;//是否绑定了账号
@property (assign,nonatomic) NSInteger gameId;//游戏id
@property (strong,nonatomic) UIButton *quitBtn;//退出按钮
@property (nonatomic,strong) UIButton * leftBtmBtn;//放弃比赛按钮
@property (nonatomic,strong) UIButton * rightBtmBtn;//提交战绩按钮
//@property (assign,nonatomic) BOOL isShowHeader;//显示header
@property (assign,nonatomic) CGFloat lastContentOffset;//判断scrollviwe的滑动方向
@property (assign,nonatomic) CGFloat whiteHeight;//距离满屏的高度
@property (assign,nonatomic) BOOL isWhite;//内容是否满了
@property (nonatomic,strong) KKHintView * hintView;//提示绑定账号
@property (nonatomic,assign) CGFloat btmH;//缩小时距离底部的距离
@property (assign,nonatomic) NSInteger fee;//入场费
@property (strong,nonatomic) KKRoomUser * me;//自己
@property (assign,nonatomic) NSInteger result;//比赛结果
@property (strong,nonatomic) NSArray * showImgArr;//比赛结果图片
//房间提示
@property (nonatomic, strong) KKHouseTipsView *houseTipsView;
@property (assign,nonatomic) NSInteger step;//第几步，0未开始，1在10分钟倒计时，2提交战绩（50分钟倒计时之前）； 3已过50分钟倒计时等待或出结果
@end

@implementation KKBigHouseViewController
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    //更改约束使navView留出状态栏高度
    self.navToTop.constant = [KKDataTool statusBarH];
    self.navigationController.navigationBar.hidden = YES;
//    self.isShowHeader = YES;
    self.isOpen = YES;//默认是大房间
    self.bind = -1;//默认不知道账号是否绑定
    //是tableview顶到顶部
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.bounces = NO;
    self.peopleArr = [NSMutableArray new];//当前用户数组
    //给流程图，设置title和步数
    self.stepView.titleArr = @[@"开始比赛",@"提交战绩",@"等待结果",@"已完成"];
    [self.view addSubview:self.houseTipsView];
    if (self.showResult) {
        //已提交战绩的比赛
        [self dealResultData];
    } else {
        _btmH = [self tabbarH];
        [self addSmallHouse];//添加小房间
        //如果有数据，赋值，匹配，自己创建的房间或者首页请求的比赛中的房间，或者自己参加的比赛从我的比赛列表中来
        if (self.roomDic) {
            [self dealRoomData];
            [self assignUi];
        } else {
            //没数据一定是自建房，从对战页进来的
            self.gameType = 1;
            [self joinRoom];//进入房间调用进入房间接口，获取房间信息
        }
        //展示出现动画
        [self show];
        [self addNotification];//添加通知
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isCreate && self.isOpen) {
        [self showShareView];
        self.isCreate = NO;
    }
}
#pragma mark - 显示分享试图
- (void)showShareView
{
//    KKShareView * shareView = [KKShareView shareView];
//    shareView.frame = [UIScreen mainScreen].bounds;
//    shareView.titleLabel.text = @"创建成功！快点邀请好友加入吧！";
    NSString * p = [NSString stringWithFormat:@"%@",self.pwd];
    while (p.length < 5) {
        p = [NSString stringWithFormat:@"0%@",p];
    }
    [KKShareTool shareRoomcode:p viewController:self];
//    NSString * fp = [NSString stringWithFormat:@"%@-%@",[p substringWithRange:NSMakeRange(0, 2)],[p substringWithRange:NSMakeRange(2, 3)]];
//    shareView.pwdLabel.text = [NSString stringWithFormat:@"房间号:%@",fp];
//    shareView.pwdLabel.textColor = kOrangeColor;
//    [self.view addSubview:shareView];
//    shareView.shareBlock = ^(NSInteger shareType) {
//        [KKShareTool shareWebPageToPlatformType:shareType viewController:self];
//    };
}
//点击右上角说明
- (IBAction)clickInfoBtn:(id)sender {
    NSString * img,*navTitle;
    if (self.gameType == 1) {
        img = @"matchExplain.png";
        navTitle = @"怎么玩对战赛";
    } else {
        img = @"pipeiExplain.png";
        navTitle = @"怎么玩1V1挑战赛";
    }
    KKExplainViewController * explainVc = [KKExplainViewController new];
    explainVc.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:img ofType:nil]];
    [self.navigationController pushViewController:explainVc animated:YES];
    explainVc.navigationItem.title = navTitle;
}

#pragma mark - 处理结果页数据
//用rankinmatch进行排序
- (void)userSortWithRankinmatch
{
    [self.peopleArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        KKRoomUser * u1 = obj1;
        KKRoomUser * u2 = obj2;
        return u1.rankinmatch.integerValue - u2.rankinmatch.integerValue;
    }];
}
//用uid排序
- (void)userSortWithUid
{
    [self.peopleArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        KKRoomUser * u1 = obj1;
        KKRoomUser * u2 = obj2;
        return u1.uid.integerValue - u2.uid.integerValue;
    }];
}
#pragma mark - 处理结果
- (void)dealResultData
{
    [self destroyTimer];
    if (self.isOpen == NO) {
        [self openRoom];
    }
    [self.houseTipsView setTitle:@""];
    self.houseTipsView.hidden = YES;
    if (_leftBtmBtn) {
        [self.leftBtmBtn removeFromSuperview];
    }
    if (_rightBtmBtn) {
        [self.rightBtmBtn removeFromSuperview];
    }
    KKSmallHouseViewController * smallVC = self.childViewControllers.firstObject;
    if (smallVC) {
        smallVC.timeLabel.hidden = YES;
        smallVC.rightBtn.hidden = YES;
        smallVC.clockIcon.hidden = YES;
    }
    self.quitBtn.hidden = NO;
    self.step = 3;
    [self.quitBtn setTitle:@"申诉" forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    NSDictionary * match = self.roomDic[@"match"];
    NSDictionary * users = self.roomDic[@"users"];
    self.peopleArr = [KKRoomUser mj_objectArrayWithKeyValuesArray:users];
    
    [self userSortWithRankinmatch];
    for (KKRoomUser * user in self.peopleArr) {
        KKUser * u = [KKDataTool user];
        if (user.uid.integerValue == u.userId.integerValue) {
            self.me = user;
            break;
        }
    }
    self.result = self.me.result.integerValue;
    NSNumber * slots = match[@"slots"];//几人赛
    self.peopleCount = slots.integerValue;
    NSNumber * game = match[@"game"];
    self.gameId = game.integerValue;//给gameId赋值
    NSNumber * gameType = match[@"matchtype"];
    self.gameType = gameType.integerValue;//给游戏类型赋值
    [self.tableView reloadData];
    self.peopleCountLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.peopleArr.count,slots];
    //给UI数赋值
    NSString * choice = match[@"choice"];
    NSString * navTitle;
    if (self.peopleCount == 2 && self.gameType == 2) {
        navTitle = [NSString stringWithFormat:@"%@1V1单挑",choice];
    } else {
        navTitle = [NSString stringWithFormat:@"%@%@人赛",choice,slots];
    }
    self.titleLabel.text = navTitle;
    self.choiceLabel.text = choice;
    NSNumber * awardmax = match[@"awardmax"];
    NSInteger a = awardmax.integerValue;
    NSString * award = @"0";
    if (a > 1000) {
        award = [NSString stringWithFormat:@"%.1fK",a/1000.0];
    } else {
        award = [NSString stringWithFormat:@"%@",awardmax];
    }
    self.totalGlodLabel.text = [NSString stringWithFormat:@"%@",award];
    NSNumber * gold = match[@"gold"];
    NSInteger g = gold.integerValue;
    NSString * goldStr = @"0";
    if (g > 1000) {
        goldStr = [NSString stringWithFormat:@"%.1fK",g/1000.0];
    } else {
        goldStr = [NSString stringWithFormat:@"%@",gold];
    }
    self.feeLabel.text = goldStr;
    [self.houseTipsView setTitle:@""];
    if (self.me.result.integerValue < 5 && self.me.result.integerValue > 0) {
        self.stepView.currentStep = 3;//最后一步
//        self.hintLabel.text = @" ";
        self.houseTipsView.hidden = YES;
    } else {
        self.stepView.currentStep = 2;
        [self.houseTipsView setTitle:@"请耐心等待比赛结果~"];
    }
    self.btmBtn.userInteractionEnabled = YES;
    self.btmBtn.hidden = NO;
    [self.btmBtn setTitle:@"返回大厅" forState:UIControlStateNormal];
}
#pragma mark - 设置当前房间内人数
-(void)setCurrentPeopleCount:(NSInteger)currentPeopleCount
{
    _currentPeopleCount = currentPeopleCount;
    KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
    vc.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentPeopleCount,(long)self.peopleCount];
    self.peopleCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentPeopleCount,(long)self.peopleCount];
}
#pragma mark - 设置是否能够退出
- (void)setShouldLeave:(BOOL)shouldLeave
{
    _shouldLeave = shouldLeave;
    if (self.gameType == 1) {
        self.quitBtn.hidden = !_shouldLeave;
    }
    if (self.stepView.currentStep > 1) {
        self.quitBtn.hidden = YES;
    }
}
#pragma mark -
- (KKHouseTipsView *)houseTipsView
{
    if (!_houseTipsView) {
        _houseTipsView=[[KKHouseTipsView alloc] init];
        _houseTipsView.hidden=true;
    }
    return _houseTipsView;
}
#pragma mark - 退出按钮
-(UIButton *)quitBtn
{
    if (_quitBtn) {
        return _quitBtn;
    }
    _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString * btnTitle = @"退出";
    if (self.showResult) {
        btnTitle = @"申诉";
    }
    [_quitBtn setTitle:btnTitle forState:UIControlStateNormal];
    _quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView addSubview:_quitBtn];
    [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.navView);
        make.right.mas_equalTo(self.navView).offset(-16);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_quitBtn addTarget:self action:@selector(clickQuitBtn) forControlEvents:UIControlEventTouchUpInside];
    _quitBtn.hidden = !self.shouldLeave;
    return _quitBtn;
}
#pragma mark - 添加通知
- (void)addNotification
{
    //这些是进入房间，离开房间，绑定账号，通知开始比赛的通知，匹配赛不在这里监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomNote:) name:kJoinRoom object:nil];//有人加入房间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveRoomNote:) name:kLeaveRoom object:nil];//有人离开房间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waitToBegin:) name:kEnterGame object:nil];//等待开始
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyTimer) name:@"logout" object:nil];//退出登录
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btmHeightChanged:) name:@"btmHeightChanged" object:nil];//小房间改变高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyTimer) name:KKLogoutNotification object:nil];//退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btmHeightChanged:) name:@"btmHeightChanged" object:nil];//小房间改变高度
}
#pragma mark - 改变小房间距离底部的距离
- (void)btmHeightChanged:(NSNotification *)noti
{
    NSNumber * h = noti.userInfo[@"btmH"];
    self.btmH = h.floatValue;
}
#pragma mark - 绑定账号成功之后
- (void)bindAccountSuccess
{
    [self.hintView removeFromSuperview];
    [KKNetTool getBindAccountListWithGameid:[NSNumber numberWithInteger:self.gameId] SuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        if (arr.count) {
            self.bind = 1;
            self.gamerInfo = arr.firstObject;
            [self clickBtmBtn:self.btmBtn];
        } else {
            self.bind = 0;
        }
    } erreorBlock:^(NSError *error) {
        self.bind = -1;
    }];
}
#pragma mark - 获取用户绑定的账号
- (void)getAccountBindWithGameId:(NSNumber *)gameId
{
    [KKNetTool getBindAccountListWithGameid:gameId SuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        if (arr.count) {
            self.bind = 1;
            self.gamerInfo = arr.firstObject;
        } else {
            self.bind = 0;
        }
    } erreorBlock:^(NSError *error) {
        self.bind = -1;
    }];
}
#pragma mark - 提示比赛费用，点击坐下
#pragma mark -显示提示充值
- (void)showZuanHintView
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    [KKNetTool getMyWalletSuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        NSNumber * diamond = dic[@"diamond"];
        NSNumber * gold = dic[@"gold"];
        NSInteger max = self.fee;
        KKAlertViewStyleTwoBtmBtn * roomHintView = [KKAlertViewStyleTwoBtmBtn shareAlertViewStyleTwoBtmBtn];
        roomHintView.frame = self.view.bounds;
        [self.view addSubview:roomHintView];
        if (gold.integerValue >= max) {
            roomHintView.titleLabel.text = @"";
            roomHintView.subtitleLabel.text = [NSString stringWithFormat:@"确认消耗%ld金币参加比赛吗?",(long)self.fee];
            [roomHintView.rightBtn setTitle:@"确认参赛" forState:UIControlStateNormal];
            roomHintView.clickRightBtnBlock = ^{
                [KKAlert showAnimateWithText:@"参赛中" toView:self.view];
                [KKNetTool readyGameWithMatchId:self.matchId para:@{@"gamerid":self.gamerInfo[@"id"]} successBlock:^(NSDictionary *dic) {
                    [KKAlert dismissWithView:self.view];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHouseInfo) name:KKViewNeedReloadNotification object:nil];
                    self.roomDic = dic;
                    self.shouldLeave = YES;
                    self.peopleArr = [KKRoomUser mj_objectArrayWithKeyValuesArray:self.roomDic[@"users"]];//把当前屋里的人加入数组
                    [self userSortWithUid];
                    [self.tableView reloadData];
//                    self.btmBtn.userInteractionEnabled = NO;
                    [self.btmBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
                    self.currentPeopleCount = self.peopleArr.count;
                    NSNumber * timeOut = dic[@"timeout"];
                    if (timeOut) {
                        if (self.isSitdown) {
                            [self addFullTimerWithTimeout:timeOut.integerValue];
                        }
                    }
                } erreorBlock:^(NSError *error) {
                    [KKAlert dismissWithView:self.view];
                    if ([error isKindOfClass:[NSString class]]) {
                        [self gooutWithError:(NSString *)error];
                    }
                }];
            };
            return;
//            roomHintView.label1.text = [NSString stringWithFormat:@"确认消耗%ld金币参加比赛吗?",(long)self.fee];
//            roomHintView.label2.text = @"";
//            roomHintView.accountLabel.text = [NSString stringWithFormat:@"账户余额:%@",gold];
//            roomHintView.zuanIcon.image = [UIImage imageNamed:@"coin_big"];
//            [roomHintView.btmBtn setTitle:@"确认参赛" forState:UIControlStateNormal];
        }
        
        //钻石兑换之后足够
        NSInteger goldLack = gold.integerValue + diamond.integerValue * 10 - max;
        if (goldLack > 0) {
            roomHintView.titleLabel.text = @"";
            roomHintView.subtitleLabel.text = @"金币不足，需要将钻石换为金币,继续参加比赛";
            [roomHintView.rightBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
            roomHintView.clickRightBtnBlock = ^{
                [self gotoChongzhiWithType:NO goldLack:max - gold.integerValue];
            };
//            roomHintView.label1.text = @"金币不足，需要将钻石换为金币";
//            roomHintView.label2.text = @"继续参加比赛";
//            roomHintView.accountLabel.text = [NSString stringWithFormat:@"账户余额:%@",diamond];
//            [roomHintView.btmBtn setTitle:@"兑换金币" forState:UIControlStateNormal];
//            roomHintView.ensureBlock = ^{
//                [self gotoChongzhiWithType:NO goldLack:max - gold.integerValue];
//            };
        } else {
            roomHintView.titleLabel.text = @"";
            roomHintView.subtitleLabel.text = @"金币不足，将无法参赛,请先充值";
            [roomHintView.rightBtn setTitle:@"立即充值" forState:UIControlStateNormal];
//            roomHintView.accountLabel.text = [NSString stringWithFormat:@"账户余额:%@",gold];
//            roomHintView.zuanIcon.image = [UIImage imageNamed:@"coin_big"];
            roomHintView.clickRightBtnBlock = ^{
                [self gotoChongzhiWithType:YES goldLack:0];
            };
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
        [KKAlert showText:@"获取账户余额出错" toView:self.view];
    }];
}
#pragma mark - 跳至充值页
- (void)gotoChongzhiWithType:(BOOL)chongzhi goldLack:(NSInteger)goldLack
{
    KKChongzhiViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"chongzhiVC"];
    __weak typeof(self) weakSelf = self;
    vc.chongzhiBlock = ^{
        [weakSelf sitDown];
    };
    vc.isChongzhi = chongzhi;
    vc.lackGold = goldLack;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 加入座位，坐下，调用坐下接口
- (void)sitDown
{
    if (self.bind == -1) {
        [self getAccountBindWithGameId:[NSNumber numberWithInteger:self.gameId]];
        return;
    }
    if (self.bind == 1) {
        [self showZuanHintView];
    } else {
        self.hintView = [KKHintView shareHintView];
        [self.hintView assignWithGameId:self.gameId];
        __weak typeof(self) weakSelf = self;
        _hintView.ensureBlock = ^{
            KKBindAccountViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bindAccountVC"];
            vc.gameId = weakSelf.gameId;
            vc.bindBlock = ^{
                [weakSelf bindAccountSuccess];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
}
#pragma mark - 收到等待开始通知
- (void)waitToBegin:(NSNotification *)noti
{
    if (self.isSitdown == NO) {
        //如果是闲人，就退出房间
        [KKAlert showText:@"房间满座比赛开始，您将离开" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
        return;
    }
    self.shouldLeave = NO;
    NSDictionary * beignDic = noti.userInfo;
    NSNumber * awardmax = beignDic[@"awardmax"];
    NSInteger a = awardmax.integerValue;
    NSString * award = @"0";
    if (a > 1000) {
        award = [NSString stringWithFormat:@"%.1fK",a/1000.0];
    } else {
        award = [NSString stringWithFormat:@"%@",awardmax];
    }
    self.totalGlodLabel.text = [NSString stringWithFormat:@"%@",award];
    NSNumber * gold = beignDic[@"gold"];
    NSInteger g = gold.integerValue;
    self.fee = gold.integerValue;
    NSString * goldStr = @"0";
    if (g > 1000) {
        goldStr = [NSString stringWithFormat:@"%.1fK",g/1000.0];
    } else {
        goldStr = [NSString stringWithFormat:@"%@",gold];
    }
    self.feeLabel.text = goldStr;
    /*
     awardmax = 380;
     choice = "\U8bc4\U5206";
     choicecode = 2;
     choicetype = 2;
     deadline = 1545204100;
     game = 2;
     gold = 200;
     matchtype = 1;
     roomid = 10061;
     starttime = 1545203800;
     */
    NSNumber * begin = beignDic[@"starttime"];//房间的比赛开始时间，也是服务器时间（可以计算系统时间与服务器时间差）
    self.beginTime = begin.integerValue;
    self.matchId = beignDic[@"roomid"];
    [self addWaitTimerWithDic:beignDic];
}
#pragma mark - 提示用户打开游戏
- (void)showOpenGameAlert
{
    CGFloat after = 0;
    if (self.isOpen == NO) {
        after = 0.5;
        [self openRoom];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * titleStr;
        NSString * gameUrl;
        if (self.gameId == KKGameTypeWangzheRY) {
            titleStr = @"进入王者荣耀开始比赛?";
            gameUrl = kWZRYUrl;
        } else if (self.gameId == KKGameTypeCijiZC){
            titleStr = @"进入刺激战场开始比赛?";
            gameUrl = kCJZCUrl;
        }
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:titleStr message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self callGameApp];
        }];
        [alert addAction:ensureAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{}];
    });
}
#pragma mark - 设置小房间距离底部的高度
- (void)setBtmH:(CGFloat)btmH
{
    _btmH = btmH;
    if (self.isOpen) {
        return;
    }
    dispatch_main_async_safe(^{
        UIWindow * w = self.secondWindow == NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - [self tabbarH], ScreenWidth, kSmallHouseHeight);
        [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
            w.frame = f;
        } completion:^(BOOL finished) {
            self.isOpen = NO;
            self.view.backgroundColor = [UIColor clearColor];
        }];
    })
}
#pragma mark - 添加等待倒计时(5分钟)
- (void)addWaitTimerWithDic:(NSDictionary *)dic {
    [self.btmBtn setTitle:@"开始单排赛" forState:UIControlStateNormal];
    self.btmBtn.userInteractionEnabled = YES;
    //小房间清除关闭界面UI
    [self destroyTimer];//如果有其它定时任务先销毁
    self.step = 1;
    self.stepView.currentStep = 0;
    self.btmBtn.userInteractionEnabled = YES;
    self.btmBtn.backgroundColor = kThemeColor;
    self.houseTipsView.hidden = false;
    [self.houseTipsView setTitle:@"限定时间内开始单排赛，否则被判输哟~"];
    __weak typeof(self) weakSelf = self;
    KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
    NSDictionary * match = self.roomDic[@"match"];
    if (match == nil) {
        match = self.roomDic[@"room"];
    }
    NSString * choice = match[@"choice"];
    NSNumber * slots = match[@"slots"];//几人赛
    NSString * navTitle;
    if (self.gameType == 2) {
        navTitle = [NSString stringWithFormat:@"%@1V1单挑",choice];
    } else {
        navTitle = [NSString stringWithFormat:@"%@%@人赛",choice,slots];
    }
    //去掉房间号
    self.titleLabel.text = navTitle;
    [vc.rightBtn setTitle:@"开始比赛" forState:UIControlStateNormal];
    self.btmBtn.userInteractionEnabled = (self.gameId == 2 || self.gameId == 3);//手游唤起游戏
    vc.rightBtn.userInteractionEnabled = (self.gameId == 2 || self.gameId == 3);//其它的不可点
    vc.timeLabel.text = @"00:00";
    [vc.view addSubview:vc.clockIcon];
    vc.clickRightBtnBlock = ^{
        [weakSelf uploadResult];
    };
    [vc removeCloseUI];//清除关闭按钮，人数按钮，取消按钮，确认退出按钮
    //倒计时时间，如果没有就默认5分钟
    NSNumber * deadTime;
    if (dic && dic[@"deadline"]) {
        deadTime = dic[@"deadline"];
    }
    if (deadTime) {
        self.deadTime = deadTime.integerValue;
    }
    NSInteger deadLine = self.deadTime;
    [self addBtmBtns];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger now = [[KKDataTool shareTools] getDateStamp];
        NSInteger timeout =  deadLine - now;//5分钟倒计时结束时间 - 当前时间
        if(timeout<=0){ //倒计时结束，关闭
            [self destroyTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf addBtmBtns];
                [self addSubmitTimer];
            });
        }else{
            NSString * timeStr = [self timeStrWithTime:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.rightBtmBtn setTitle:[NSString stringWithFormat:@"开始单排赛(%@)",timeStr] forState:UIControlStateNormal];
                vc.timeLabel.text = timeStr;
            });
        }
    });
    dispatch_resume(_timer);
    [self.tableView reloadData];
}
#pragma mark - 收到了有人离开房间的通知
- (void)leaveRoomNote:(NSNotification *)note
{
    NSDictionary * dic = note.userInfo;
    NSNumber * uid = dic[@"uid"];
    NSInteger userId = uid.integerValue;
    for (KKRoomUser * user in self.peopleArr) {
        if (user.uid.integerValue == userId) {
            [self.peopleArr removeObject:user];
            break;
        }
    }
    self.btmBtn.userInteractionEnabled = !self.isSitdown;
    [self.tableView reloadData];
    self.currentPeopleCount = self.peopleArr.count;
    //有人离开，去掉倒计时
    if (_timer) {
        [self destroyTimer];
        [self.btmBtn setTitle:@"开始单排赛" forState:UIControlStateNormal];
    }
}
#pragma mark - 有人加入了房间
- (void)joinRoomNote:(NSNotification *)note
{
    NSDictionary * dic = note.userInfo;
    KKRoomUser * user = [KKRoomUser mj_objectWithKeyValues:dic[@"user"]];
    [self.peopleArr addObject:user];
    [self userSortWithUid];
    [self.tableView reloadData];
    self.currentPeopleCount = self.peopleArr.count;
    NSNumber * timeOut = dic[@"timeout"];
    if (timeOut) {
        if (self.isSitdown) {
            self.shouldLeave = YES;
//            [self addFullTimerWithTimeout:timeOut.integerValue];
        }
//        self.btmBtn.userInteractionEnabled = NO;
        [self addFullTimerWithTimeout:timeOut.integerValue];
//        else {
//            self.btmBtn.userInteractionEnabled = NO;
//        }
    }
}
#pragma mark - 增加准备比赛15s倒计时
- (void)addFullTimerWithTimeout:(NSInteger)timeOut
{
    self.btmBtn.userInteractionEnabled = NO;
    NSInteger endT = [[KKDataTool shareTools] getDateStamp] + timeOut;//倒计时结束时间戳
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger t = [[KKDataTool shareTools] getDateStamp];//当前时间戳
        NSInteger leftTime = endT - t;//距离比赛开始还有多久
        if (leftTime <= 0) {
            if (weakSelf.timer) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf destroyTimer];
                    [weakSelf.btmBtn setTitle:@"开始单排赛" forState:UIControlStateNormal];
                    if ([self isSitdown] == NO) {
                        [self performSelector:@selector(shouldGoout) withObject:nil afterDelay:2];
                    }
                });
            }
            return;
        }
        NSString *strTime = [NSString stringWithFormat:@"%ldS",(long)leftTime];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.btmBtn setTitle:strTime forState:UIControlStateNormal];
        });
    });
    dispatch_resume(_timer);
}
#pragma mark - 20s倒计时结束之后，没有坐下是否踢出
- (void)shouldGoout
{
    [self refreshHouseInfo];
}
#pragma mark - 自己是否已经坐下
-(BOOL)isSitdown
{
    NSInteger uid = [KKDataTool user].userId.integerValue;
    for (KKRoomUser * user in self.peopleArr) {
        if (user.uid.integerValue == uid) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - 进入房间
- (void)joinRoom {
    [KKNetTool joinRoomWithMatchId:self.matchId successBlock:^(NSDictionary *dic) {
        self.roomDic = dic;
        [self dealRoomData];
        [self assignUi];
    } erreorBlock:^(NSError *error) {
        if ([error isKindOfClass:[NSString class]]) {
            [self gooutWithError:(NSString *)error];
        }
    }];
}
#pragma mark - 加入房间错误踢出
- (void)gooutWithError:(NSString *)err
{
    if ([err isEqualToString:@"比赛房间不存在"]) {
        [KKAlert showText:@"当前房间关闭，您即将离开" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRoomListChanged object:nil];
        });
        return;
    }
    if ([err containsString:@"比赛已经开始"]) {
        [KKAlert showText:@"房间满座比赛开始，您即将离开" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRoomListChanged object:nil];
        });
    }
     [KKAlert showText:err toView:self.view];
}
#pragma mark - 设置gameId时更新游戏图标
-(void)setGameId:(NSInteger)gameId
{
    if (_gameId == gameId) {
        return;
    }
    _gameId = gameId;
//    //如果不是绝地求生添加上传结果图片的通知
//    if (_gameId != KKGameTypeJuediQS) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSubmitResultUI) name:@"submitSuccess" object:nil];
//    }
    NSArray * bigImgs = @[@"PUBGBack",@"GKBack",@"ZCBack",@"LOLBack"];
    self.backgroundImgView.image = [UIImage imageNamed:bigImgs[self.gameId - 1]];
    self.gameIcon.image = [KKDataTool gameIconWithGameId:_gameId];
    if (self.childViewControllers.count) {
        KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
        vc.gameIcon.image = self.gameIcon.image;
    }
}
-  (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark - 计算内容距离底部的空白距离
- (CGFloat)whiteHeight
{
    CGFloat t = 0;
    if (isIphoneX) {
        t = 34;
    }
    CGFloat h = 74 + t + [KKDataTool navBarH] + 62 * self.peopleArr.count;//内容的高度
    CGFloat whiteH = ScreenHeight - h;
    self.isWhite = whiteH > 0;
    _whiteHeight = whiteH;
    return _whiteHeight;
}
#pragma mark - 点击底部按钮
- (IBAction)clickBtmBtn:(id)sender {
    if (self.showResult) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    //没有坐下，点击的一定是参赛，参赛之后没开始是分享，开始了底部按钮就隐藏了，直到结束时返回大厅
    if (self.isSitdown == NO) {
        [self sitDown];
        return;
    }
    NSString * str = self.btmBtn.currentTitle;
    if ([str isEqualToString:@"邀请好友"]) {
        [self showShareView];
        return;
    }
    if ([str containsString:@"开始单排赛"]) {
        [self showOpenGameAlert];
    } else {
        //返回大厅
        [self dismiss];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController * vc = [app currentVc];
        [vc.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 如果有数据，就对数据处理
- (void)assignUi
{
    //房间号或者私密房密码
    if (self.pwd == nil) {
        self.pwd = self.roomDic[@"ID"];
    }
    //已经开始的比赛是match，未开始的是room
    NSDictionary * match = self.roomDic[@"match"];
    if (match == nil) {
        match = self.roomDic[@"room"];
    }
    NSNumber * isprivate = match[@"isprivate"];
    //私密房显示锁
    self.lockImgView.hidden = (isprivate.integerValue == 0);
    NSNumber * gameType = match[@"matchtype"];
    self.gameType = gameType.integerValue;//给游戏类型赋
    if (self.gameType == 1) {
        //匹配不能退出，自建房没开始比赛可以退出
        [self.titleLabel.superview addSubview:self.quitBtn];
    }
    NSString * choice = match[@"choice"];
    NSString * navTitle;
    if (self.gameType == 2) {
        navTitle = [NSString stringWithFormat:@"%@1V1单挑",choice];
    } else {
        navTitle = [NSString stringWithFormat:@"%@%ld人赛",choice,self.peopleCount];
    }
    if (self.pwd && self.gameType == 1) {
        NSString * p = [NSString stringWithFormat:@"%@",self.pwd];
        while (p.length < 5) {
            p = [NSString stringWithFormat:@"0%@",p];
        }
        NSString * fp = [NSString stringWithFormat:@"%@-%@",[p substringWithRange:NSMakeRange(0, 2)],[p substringWithRange:NSMakeRange(2, 3)]];
        NSString * s = [NSString stringWithFormat:@"%@\n房间号:%@",navTitle,fp];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:s];
        NSRange range = [s rangeOfString:navTitle];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(range.length, s.length - range.length)];
        self.titleLabel.attributedText = str;
    } else {
        self.titleLabel.text = navTitle;
    }
    self.choiceLabel.text = choice;
    KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
    vc.titleLabel.text = navTitle;
    NSNumber * awardmax = match[@"awardmax"];
    NSInteger a = awardmax.integerValue;
    NSString * award = @"0";
    if (a > 1000) {
        award = [NSString stringWithFormat:@"%.1fK",a/1000.0];
    } else {
        award = [NSString stringWithFormat:@"%@",awardmax];
    }
    self.totalGlodLabel.text = [NSString stringWithFormat:@"%@",award];
    NSNumber * gold = match[@"gold"];
    NSInteger g = gold.integerValue;
    self.fee = gold.integerValue;
    NSString * goldStr = @"0";
    if (g > 1000) {
        goldStr = [NSString stringWithFormat:@"%.1fK",g/1000.0];
    } else {
        goldStr = [NSString stringWithFormat:@"%@",gold];
    }
    self.feeLabel.text = goldStr;
    if (self.isSitdown) {
        //添加通知，处理漏掉通知的问题
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHouseInfo) name:KKViewNeedReloadNotification object:nil];
    }
}
-(void)dealRoomData
{
    //已经开始的比赛是match，未开始的是room
    NSDictionary * match = self.roomDic[@"match"];
    if (match == nil) {
        match = self.roomDic[@"room"];
    }
    NSNumber * game = match[@"game"];
    self.gameId = game.integerValue;//给gameId赋值
    NSNumber * slots = match[@"slots"];//几人赛
    self.peopleCount = slots.integerValue;
    self.matchId = match[@"id"];//给比赛id赋值
    //当前房间内的人
    self.peopleArr = [KKRoomUser mj_objectArrayWithKeyValuesArray:self.roomDic[@"users"]];//把当前屋里的人加入数组
    [self userSortWithUid];
    self.currentPeopleCount = self.peopleArr.count;
    NSNumber * gameType = match[@"matchtype"];
    self.gameType = gameType.integerValue;
    [self.tableView reloadData];
    NSNumber * starttime = match[@"starttime"];//比赛开始时间
    self.beginTime = starttime.integerValue;
    NSNumber * deadLine = match[@"deadline"];//倒计时5分钟结束的时间
    self.deadTime = deadLine.integerValue;
    KKUser * u = [KKDataTool user];
    KKRoomUser * mine;//自己
    NSInteger count = self.peopleArr.count;
    for (int i = 0; i < count; i ++) {
        KKRoomUser * user = self.peopleArr[i];
        if (user.uid.integerValue == u.userId.integerValue) {
            mine = user;
            break;
        }
    }
    if (mine == nil) {
        if (self.roomDic[@"match"]) {
            //踢人
            [self gooutWithError:@"比赛房间不存在"];
            return;
        }
        self.shouldLeave = NO;
        [self.btmBtn setTitle:@"我要参赛" forState:UIControlStateNormal];
        //获取是否绑定的账号
        [self getAccountBindWithGameId:[NSNumber numberWithInteger:self.gameId]];
        return;
    }
    //已经坐下了，暂时不能点
    //如果未开始，则显示分享
    if (self.step == 0) {
        [self.btmBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
    }
//    self.btmBtn.userInteractionEnabled = NO;
    if (self.peopleArr.count != self.peopleCount) {
        //没坐满，等待其他人加入
        self.shouldLeave = YES;
        return;
    }
    //已经出结果了
    NSNumber * result = mine.result;
    if (result.integerValue > 0 && result.integerValue < 5) {
        [self dealResultData];
        return;
    }
    NSNumber * state = mine.state;
    NSInteger sta = state.integerValue + 4;
    switch (sta) {
        case 4:{
            //比赛尚未开始，等待通知
            self.shouldLeave = YES;
            self.step = 0;
        }
            break;
        case 5:
        {
            //比赛尚未开始，等待通知
           self.shouldLeave = YES;
           self.step = 0;
        }
            break;
        case 6:
            {
                //5分钟倒计时已过，未提交战绩
                self.shouldLeave = NO;
                [self.btmBtn setTitle:@"开始单排赛" forState:UIControlStateNormal];
//                [self addBtmBtns];//提交战绩
                [self addWaitTimerWithDic:nil];
            }
            break;
        case 14:
        {
            //5分钟倒计时
            self.shouldLeave = NO;
            [self addWaitTimerWithDic:nil];//添加等待开始倒计时
        }
            break;
        default:
        {
            //已结束,已经提交（放弃）或出结果或者超时未提交
            [self showSubmitResultUI];
        }
            break;
    }
}
#pragma mark - 刷新房间内的数据
- (void)refreshHouseInfo
{
    if ([self.matchId isKindOfClass:[NSString class]]) {
        [KKNetTool getRoomInfoWithRoomId:(NSString *)self.matchId SuccessBlock:^(NSDictionary *dic) {
            //当前存在的房间控制器，如果已存在小房间，则直接打开
            DLOG(@"房间信息--%@--",dic);
            self.roomDic = dic;
            [self dealRoomData];
        } erreorBlock:^(NSError *error) {
            DLOG(@"%@",error);
            if ([error isKindOfClass:[NSString class]]) {
                [self gooutWithError:(NSString *)error];
            }
        }];
    } else if ([self.matchId isKindOfClass:[NSNumber class]]){
        [KKNetTool getMatchInfoWithMatchId:self.matchId SuccessBlock:^(NSDictionary *dic) {
            //当前存在的房间控制器，如果已存在小房间，则直接打开
            self.roomDic = dic;
            [self dealRoomData];
        } erreorBlock:^(NSError *error) {
            if ([error isKindOfClass:[NSString class]]) {
                [self gooutWithError:(NSString *)error];
            }
        }];
    }
}
#pragma mark - 添加提交战绩倒计时,第一步5分钟已过，等待提交
- (void)addSubmitTimer
{
    [self destroyTimer];
    self.step = 2;
    [self.tableView reloadData];
    __weak typeof(self) weakSelf = self;
    KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
    vc.rightBtn.userInteractionEnabled = YES;
    [vc.rightBtn setTitle:@"提交战绩" forState:UIControlStateNormal];
    vc.timeLabel.text = @"00:00";
    [vc.view addSubview:vc.clockIcon];
    [vc removeCloseUI];
    vc.clickRightBtnBlock = ^{
        [weakSelf uploadResult];
    };
    self.stepView.currentStep = 1;
//    self.hintLabel.text = @"限定时间内提交战绩，否则被判输";
    [self.houseTipsView setTitle:@"限定时间内提交战绩，否则被判输哟~"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    GameItem * item = [KKDataTool itemWithGameId:self.gameId];
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger now = [[KKDataTool shareTools] getDateStamp];
        int timeout = (int)(self.beginTime + item.resultinseconds.integerValue - now);
        if(timeout<=0){ //倒计时结束，关闭
            //超时
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showSubmitResultUI];
            });
        }else{
            NSString * timeStr = [self timeStrWithTime:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.rightBtmBtn setTitle:[NSString stringWithFormat:@"提交战绩(%@)",timeStr] forState:UIControlStateNormal];
                vc.timeLabel.text = timeStr;
            });
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - 显示提交战绩只有的UI，等待结果状态
- (void)showSubmitResultUI
{
    [self destroyTimer];
    self.step = 3;
    self.stepView.currentStep = 2;
    if (self.isOpen == NO) {
        [self openRoom];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.hintLabel.text = @"";
            [self.houseTipsView setTitle:@"请耐心等待比赛结果~"];
            [self.leftBtmBtn removeFromSuperview];
            [self.rightBtmBtn removeFromSuperview];
            self.btmBtn.hidden = NO;
            self.btmBtn.userInteractionEnabled = YES;
            [self.btmBtn setTitle:@"返回大厅" forState:UIControlStateNormal];
            KKSmallHouseViewController * smallVC = self.childViewControllers.firstObject;
            smallVC.timeLabel.hidden = YES;
            smallVC.rightBtn.hidden = YES;
            smallVC.clockIcon.hidden = YES;
            [self.tableView reloadData];
        });
    } else {
        [self.houseTipsView setTitle:@"请耐心等待比赛结果~"];
        [self.leftBtmBtn removeFromSuperview];
        [self.rightBtmBtn removeFromSuperview];
        self.btmBtn.hidden = NO;
        self.btmBtn.userInteractionEnabled = YES;
        [self.btmBtn setTitle:@"返回大厅" forState:UIControlStateNormal];
        KKSmallHouseViewController * smallVC = self.childViewControllers.firstObject;
        smallVC.timeLabel.hidden = YES;
        smallVC.rightBtn.hidden = YES;
        smallVC.clockIcon.hidden = YES;
        [self.tableView reloadData];
    }
    self.shouldLeave = YES;
}
#pragma mark - 添加底部放弃比赛按钮和提交战绩按钮及点击操作
- (void)addBtmBtns
{
//    self.hintLabel.text = @"请在限制时间内提交战绩，否则视为挑战失败";
//    [self.houseTipsView setTitle:@"请在限制时间内提交战绩，否则视为挑战失败"];
    [self.btmBtn.superview addSubview:self.leftBtmBtn];
    [self.btmBtn.superview addSubview:self.rightBtmBtn];
    self.btmBtn.hidden = YES;
}

-(UIButton *)leftBtmBtn
{
    if (_leftBtmBtn) {
        return _leftBtmBtn;
    }
    _leftBtmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtmBtn setTitle:@"放弃比赛" forState:UIControlStateNormal];
    [_leftBtmBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    _leftBtmBtn.backgroundColor = [UIColor whiteColor];
    if (isIphoneX) {
        [_leftBtmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtmBtn.frame = CGRectMake(16, 0, 100, 49);
        [_leftBtmBtn setBackgroundColor:[UIColor colorWithRed:1 green:88/255.0 blue:88/255.0 alpha:1]];
        _leftBtmBtn.layer.cornerRadius = 10;
        _leftBtmBtn.layer.masksToBounds = YES;
    } else {
        _leftBtmBtn.frame = CGRectMake(0, 0, ScreenWidth * 0.5, 49);
    }
    _leftBtmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_leftBtmBtn addTarget:self action:@selector(giveupUploadResult) forControlEvents:UIControlEventTouchUpInside];
    return _leftBtmBtn;
}

#pragma mark - 点击认输按钮
- (void)giveupUploadResult
{
    [self showRenshuAlert];
}

#pragma mark - 提示是否确认认输
- (void)showRenshuAlert
{
    KKAlertViewStyleTwoBtmBtn * alertView = [KKAlertViewStyleTwoBtmBtn shareAlertViewStyleTwoBtmBtn];
    alertView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:alertView];
    alertView.titleLabel.text = @"";
    NSString * tips = @"确定放弃本场比赛吗?";
    if (self.peopleCount == 2) {
        tips = @"确定放弃本场比赛么，对方将直接获胜哟~";
    }
    alertView.subtitleLabel.text = tips;
    [alertView.leftBtn setTitle:@"我再想想" forState:UIControlStateNormal];
    [alertView.rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    alertView.clickRightBtnBlock = ^{
        [self commitRenshuResult];
    };
//    NSString * alertTitle = @"确定放弃本场比赛吗?";
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
//    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self commitRenshuResult];
//    }];
//    [alert addAction:ensureAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:^{}];
}
#pragma mark - 提交认输，调用认输接口
- (void)commitRenshuResult
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    [KKNetTool giveUpWithMatchid:self.matchId SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        [self refreshHouseInfo];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
        if ([error isKindOfClass:[NSString class]]) {
            [KKAlert showText:(NSString *)error toView:self.view];
        }
//        NSLog(@"%@",error);
    }];
}

-(UIButton *)rightBtmBtn
{
    if (_rightBtmBtn) {
        return _rightBtmBtn;
    }
    _rightBtmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtmBtn setTitle:@"提交战绩" forState:UIControlStateNormal];
    [_rightBtmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtmBtn.backgroundColor = kThemeColor;
    _rightBtmBtn.frame = CGRectMake(ScreenWidth * 0.5, 0, ScreenWidth * 0.5, 49);
    if (isIphoneX) {
        _rightBtmBtn.frame = CGRectMake(132, 0, ScreenWidth - 132 - 16, 49);
        _rightBtmBtn.layer.cornerRadius = 10;
        _rightBtmBtn.layer.masksToBounds = YES;
        [_rightBtmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtmBtn.backgroundColor = kThemeColor;
    }
    _rightBtmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightBtmBtn addTarget:self action:@selector(uploadResult) forControlEvents:UIControlEventTouchUpInside];
    return _rightBtmBtn;
}
#pragma mark - 点击提交战绩
- (void)uploadResult
{
    NSString * currentTitle = self.rightBtmBtn.currentTitle;
    if ([currentTitle containsString:@"开始单排赛"]) {
        [self showOpenGameAlert];
        return;
    }
    if (self.gameId == 1) {
        [KKNetTool reportResultWithMatchid:self.matchId SuccessBlock:^(NSDictionary *dic) {
            dispatch_main_async_safe(^{
                [self showSubmitResultUI];
            })
        } erreorBlock:^(NSError *error) {
//            NSLog(@"%@",error);
        }];
    } else {
        if (self.isOpen) {
            [self showSubmitImage];
        } else {
            [self openRoom];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self showSubmitImage];
//            });
        }
    }
}
#pragma mark - 显示上传图片提交结果控制器
- (void)showSubmitImage
{
    KKSubmitResultViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"submitResultVC"];
    vc.matchId = self.matchId;
    vc.gameId = self.gameId;
    __weak typeof(self) weakSelf = self;
    vc.submitSuccessBlock = ^{
        [weakSelf refreshHouseInfo];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)callGameApp
{
    NSString * gUrl = self.gameId==2?kWZRYUrl:kCJZCUrl;
    dispatch_main_async_safe(^{
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gUrl] options:@{} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gUrl]];
        }
    })
}
#pragma mark - 清除定时器
-(void)destroyTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
#pragma mark - 把秒数转换成分钟和秒数
-(NSString*)timeStrWithTime:(NSInteger)time
{
    return [NSString stringWithFormat:@"%02ld:%02ld",time/60,time%60];
}
#pragma mark - 创建时显示自己
- (void)show
{
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    w.hidden = YES;
    if (self.isSmall) {
        self.smallHouseView.hidden = NO;
        self.bigHouseView.hidden = YES;
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - [self tabbarH], ScreenWidth, kSmallHouseHeight);
        w.frame = f;
        self.isOpen = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.backgroundColor = [UIColor clearColor];
            w.hidden = NO;
            self.isSmall = NO;
        });
        return;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
        self.smallHouseView.hidden = YES;
        self.bigHouseView.hidden = NO;
        w.frame = [UIScreen mainScreen].bounds;
        w.hidden = NO;
    } completion:^(BOOL finished) {
        self.isOpen = YES;
    }];
}
#pragma mark - 消失
- (void)dismissAnimated:(BOOL)animated
{
    if (animated) {
        [self dismiss];
    } else {
        UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
        w.hidden = YES;
        [self destroyTimer];
        if (self.secondWindow) {
            [[KKDataTool shareTools] destroyShowWindow];
        } else {
            [[KKDataTool shareTools] destroyWindow];
        }
    }
}
- (void)dismiss
{
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
        w.mj_x = ScreenWidth;
    } completion:^(BOOL finished) {
        [self destroyTimer];
        if (self.secondWindow) {
            [[KKDataTool shareTools] destroyShowWindow];
        } else {
            [[KKDataTool shareTools] destroyWindow];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myGameChanged" object:nil];;
    }];
}
#pragma mark 点击左上角的返回按钮,返回或者缩小
- (IBAction)clickCloseBtn:(id)sender {
    //显示的结果，直接返回
    if (self.showResult) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //自建房，并且没有加入比赛，直接退出
    if (self.gameType == 1 && self.isSitdown == NO) {
        [self clickQuitBtn];
        return;
    }
    //已经提交过了，直接返回
    if (self.stepView.currentStep >= 2) {
        [self dismiss];
        return;
    }
    //变成小房间
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    CGRect f = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
        w.frame = f;
    } completion:^(BOOL finished) {
        //反弹动画
        self.smallHouseView.hidden = NO;
        self.bigHouseView.hidden = YES;
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - [self tabbarH], ScreenWidth, kSmallHouseHeight);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            w.frame = f;
        } completion:^(BOOL finished) {
            self.isOpen = NO;
            self.view.backgroundColor = [UIColor clearColor];
        }];
    }];
}
#pragma mark - 离开房间
- (void)clickQuitBtn {
    NSString * currentTitle = [self.quitBtn currentTitle];
    if ([currentTitle isEqualToString:@"申诉"]) {
        KKAppealViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"appealVC"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //小房间或者未坐下，直接退出
    if (self.isOpen == NO || self.isSitdown == NO) {
        [self outRoom];
        return;
    }
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"确定要离开房间吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self outRoom];
    }];
    [alertVc addAction:cancelAction];
    [alertVc addAction:ensureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}
//离开房间
- (void)outRoom
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    [KKNetTool leaveRoomWithMatchId:self.matchId successBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
         [self dismiss];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
        if ([self isSitdown]) {
            [KKAlert showText:([HNUBZUtil checkStrEnable:error]?error:error.domain) toView:self.view];
        } else {
           [self dismiss];
        }
    }];
   
}
#pragma mark - 获取底层是否隐藏tabbar
-(CGFloat)tabbarH
{
    UIViewController * vc = [(AppDelegate *)[UIApplication sharedApplication].delegate currentVc];
    CGFloat h = 10;
    if (vc != vc.navigationController.viewControllers.firstObject) {
        if (isIphoneX) {
            h = 34;
        }
    } else {
        h = [KKDataTool tabBarH] + 10;
    }
    return h;
}
#pragma mark - 添加小房间，用父子控制器实现
- (void)addSmallHouse
{
    KKSmallHouseViewController * smallHouse = [KKSmallHouseViewController new];
    self.smallHouseView = smallHouse.view;
    smallHouse.closeBtn.hidden = NO;
    smallHouse.countLabel.text = @"0/0";
    [self.view addSubview:self.smallHouseView];
    [self.smallHouseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(kSmallHouseHeight);
    }];
    [self addChildViewController:smallHouse];
    self.smallHouseView.hidden = YES;
    [self.smallHouseView addSubview:smallHouse.closeBtn];
    __weak typeof(self) weakSelf = self;
    smallHouse.clickBlock = ^{
        [weakSelf openRoom];
    };
    //确认退出
    smallHouse.clickEnsureQuitBlock = ^{
        [weakSelf clickQuitBtn];
    };
}

#pragma 点击小房间放大,显示大房间
- (void)openRoom {
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    w.mj_h = ScreenHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
        self.smallHouseView.hidden = YES;
        self.bigHouseView.hidden = NO;
        w.mj_y = 0;
    } completion:^(BOOL finished) {
        self.isOpen = YES;
    }];
}

#pragma mark - 懒加载
-(KKStepView *)stepView
{
    if (_stepView) {
        return _stepView;
    }
    _stepView = [KKStepView new];
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 74);
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:206/255.0 green:209/255.0 blue:214/255.0 alpha:0.6];
    line.frame = CGRectMake(ScreenWidth * 0.5 - 18, 6, 36, 4);
    line.layer.cornerRadius = 2;
    line.layer.masksToBounds = YES;
    [headerView addSubview:line];
    [headerView addCornersWithRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerSize:CGSizeMake(10, 10)];
    [headerView addSubview:_stepView];
    self.sectionHeaderView = headerView;
    [_stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView).offset(10);
        make.left.right.bottom.mas_equalTo(headerView);
        make.height.mas_equalTo(54);
    }];
    return _stepView;
}
#pragma mark - tableviewdelegate,datasource
#pragma mark - 给tableViewheader以反弹效果
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (self.isShowHeader) {
//        // 现在是显示
//        if (offsetY > 50) {
//            [self.tableView setContentOffset:CGPointMake(0,kTableHeader) animated:YES];
//            self.isShowHeader = NO;
//        } else {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
//            });
//        }
//    } else {
//        // 现在是隐藏
//        if (offsetY < 94) {
//            self.isShowHeader = YES;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
//            });
//        }
//    }
//}
#pragma mark - 设置tableView是否可以反弹,解决上滑显示出黑色背景bug
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"===%f",offsetY);
//    self.tableView.bounces = offsetY <= kTableHeader;
    CGPoint point = [scrollView.panGestureRecognizer translationInView:self.view];
    self.tableView.bounces = point.y > 0;
//    if (point.y > 0 && self.isShowHeader == NO) {
//        // 向下滚动
//        self.tableView.bounces = YES;
//    } else {
//        // 向上滚动
//        self.tableView.bounces = NO;
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat whiteH = [self whiteHeight];
    if (whiteH <= 0) { 
        return self.peopleArr.count;
    } else {
        return self.peopleArr.count + 1;
    }
//    return self.peopleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 74;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isWhite && indexPath.row == self.peopleArr.count) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"white"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"white"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
    static NSString * reuse = @"bigHouseList";
    KKBigHouseListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    [cell assignWithUser:self.peopleArr[indexPath.row] gameid:self.gameId];
    [cell updateStatusGifImage:self.peopleArr[indexPath.row] step:self.step];
    if (self.result > 0 && self.result < 5) {
        cell.rank = indexPath.row + 1;
        if (self.gameId == 1) {
            //绝地求生显示数据
            [cell assignWithDic:self.roomDic[@"match"]];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isWhite && indexPath.row == self.peopleArr.count) {
        return self.whiteHeight;
    }
    return 62;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stepView.currentStep < 2) {
        return;
    }
//    if (self.showResult == NO) {
//        return;
//    }
    if (self.isWhite && indexPath.row == self.peopleArr.count) {
        return;
    }
    KKRoomUser * user = self.peopleArr[indexPath.row];
    NSString * img;
    if (user.images && user.images.length > 0) {
        img = user.images;
    } else if (user.image && user.image.length > 0){
        img = user.image;
    }
    if (img == nil) {
//        [KKAlert showText:@"暂无结果图片" toView:self.view];
        return;
    }
    self.showImgArr = [img componentsSeparatedByString:@","];
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
}
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = style;
    [self presentViewController:BroswerVC animated:YES completion:nil];
}
/**
 *  每个组多少个图片
 */
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section
{
    return self.showImgArr.count;
}
///**
// *  每个对应的IndexPath展示什么内容
// */
- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
    photo.photoURL = [NSURL URLWithString:self.showImgArr[indexPath.row]];
    return photo;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.showResult) {
        self.navigationController.navigationBar.hidden = NO;
    }
}
- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(shouldGoout) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
