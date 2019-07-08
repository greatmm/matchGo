//
//  KKChampionshipViewController.m
//  game
//
//  Created by greatkk on 2018/11/1.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChampionshipViewController.h"
#import "KKChampionshipHintView.h"
#import "KKSubmitResultViewController.h"
#import "AppDelegate.h"
#import "KKSmallHouseViewController.h"
#import "KKHintView.h"
#import "KKBindAccountViewController.h"
#import "KKExplainViewController.h"
#import "KKChampionResultNewViewController.h"
#import "KKHouseTipsView.h"
#import "KKShareTool.h"
@interface KKChampionshipViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;//scrollview的内容试图
@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;//获胜条件
@property (weak, nonatomic) IBOutlet UILabel *fromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLabel;//入场券数量
@property (weak, nonatomic) IBOutlet UIView *btmView;
@property (strong, nonatomic) IBOutlet UIButton *btmBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (strong,nonatomic) dispatch_source_t timer;
//@property (strong,nonatomic) UIView * floatView;//浮动view
@property (strong,nonatomic) UILabel * minLabel;//分钟
@property (strong,nonatomic) UILabel * secondLabel;//秒数

@property (strong,nonatomic) UIButton * leftBtmBtn;//放弃提交按钮
@property (strong,nonatomic) UIButton * rightBtmBtn;//提交战绩按钮
@property (assign,nonatomic) BOOL isLeave;//是否是返回首页
@property (assign,nonatomic) NSInteger beginTime;//比赛开始时间
@property (assign,nonatomic) NSInteger endTime;//等待开始结束时间（5分钟倒计时结束时间）
@property (strong,nonatomic) NSNumber * gamerId;//当前游戏绑定的玩家id


@property (assign,nonatomic) NSInteger matchBeginTime;//整个锦标赛开始时间
@property (assign,nonatomic) NSInteger matchEndTime;//整个锦标赛结束时间
@property (strong,nonatomic) dispatch_source_t endTimer;//监听前三分钟和后三分钟的倒计时



@property (nonatomic,assign) CGFloat btmH;//缩小时距离底部的距离
@property (weak, nonatomic) IBOutlet UIButton *backBtn;//左上角返回按钮
@property (strong,nonatomic) KKHintView * hintView;//提示绑定账号
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;//免费送的次数
@property (assign,nonatomic) NSInteger free;//免费次数
@property (strong,nonatomic) KKHouseTipsView * houseTipsView;
@property (assign,nonatomic) BOOL isSelfInGame;//自己是否在游戏中,用于判断时间超过锦标赛结束时间是否要显示结束
@property (weak, nonatomic) IBOutlet UILabel *totalAwardLabel;//总奖金

@end

#define kBeforeSubmitResultMinite 10 //请在几分钟内开始比赛

@implementation KKChampionshipViewController
#pragma mark lifeCycle
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLeave = YES;//刚进来允许离开
    self.isOpen = YES;//默认是大房间
    self.freeLabel.text = @"";
    NSNumber * free = self.dataDic[@"times"];//取到免费次数
    if (free == nil || free.integerValue == 0) {
        self.free = 0;
    } else {
        self.free = free.integerValue;
    }
    if ([KKDataTool token]) {
        [self getTickets];//获取当前账户的入场券数量
    }
    _btmH = [self tabbarH];//给小房间距离底部距离初始值
    NSDictionary * dic = self.dataDic[@"champion"];//锦标赛数据，理论上不可能没有数据
    //如果有数据进行处理
    if (dic) {
        if (dic[@"showaward_total"]) {
            self.totalAwardLabel.text = [NSString stringWithFormat:@"%@",dic[@"showaward_total"]];
        } else {
           self.totalAwardLabel.text = @"0";
        }
        if (dic[@"choice"]) {
            //获胜条件
            self.choiceLabel.text = [NSString stringWithFormat:@"%@",dic[@"choice"]];
        }
        self.cId = dic[@"id"];
        NSString * v = dic[@"value"];//获胜条件数值
        if (v) {
            self.choiceLabel.text = [NSString stringWithFormat:@"%@%@以上",self.choiceLabel.text,v];
        }
        NSNumber * starttime = dic[@"starttime"];
        self.matchBeginTime = starttime.integerValue;//锦标赛开始时间
        self.fromTimeLabel.text = [NSString stringWithFormat:@"从%@",[KKDataTool timeStrWithTimeStamp:starttime.integerValue]];
        NSNumber * endtime = dic[@"endtime"];//锦标赛结束时间
        self.matchEndTime = endtime.integerValue;
        self.toTimeLabel.text = [NSString stringWithFormat:@"至%@",[KKDataTool timeStrWithTimeStamp:endtime.integerValue]];
        NSNumber * game = dic[@"game"];//游戏id
        self.gameId = game.integerValue;//游戏id
        NSString * imgs = dic[@"images"];//以后可能会是多张，用,分割
        self.topImgView.image = [UIImage imageNamed:@"defaultImage"];
        self.topImgView.backgroundColor = [UIColor colorWithWhite:236/255.0 alpha:1];
        if (imgs && imgs.length > 0) {
            NSArray * imgArr = [imgs componentsSeparatedByString:@","];
            [self.topImgView sd_setImageWithURL:[NSURL URLWithString:imgArr.firstObject] placeholderImage:[UIImage imageNamed:@"defaultImage"]];//给顶部图片赋值
        }
//        NSInteger now = [[KKDataTool shareTools] getDateStamp];//当前时间
//        if (now >= self.matchEndTime) {
//            //当前时间大于锦标赛结束时间，锦标赛已结束,交给计时器处理
//        } else {
            //如果已经结束但是时间未超时，则显示结束UI，销毁计时器(数据可能会出错，忽略。统一以时间戳来计算)
//            NSNumber * status = dic[@"status"];
//            if (status.integerValue == 3) {
//                //状态为3也是锦标赛已结束
//                [self showFinalResult];
//                [self destoryTimer];//销毁所有定时器
//            }
//        }
    }
    [self addSmallHouse];
    KKSmallHouseViewController * smallVc = self.childViewControllers.firstObject;
    if (dic[@"name"]) {
        smallVc.titleLabel.text = dic[@"name"];
    } else {
        smallVc.titleLabel.text = @"锦标赛";
    }
    //锦标赛没结束，有比赛才处理
    NSDictionary * match = self.dataDic[@"match"];
    if (match) {
        self.isSelfInGame = YES;//有未结束的比赛
        NSNumber * starttime = match[@"starttime"];
        NSNumber * deadline = match[@"deadline"];
        self.beginTime = starttime.integerValue;//比赛开始时间
        self.endTime = deadline.integerValue;//5分钟倒计时
        self.matchId = match[@"id"];//比赛id
        [self addStartMatchTimer];
        //有比赛，禁止离开
        self.isLeave = NO;
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"战绩" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(lookupResult) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navView).offset(-16);
        make.top.bottom.mas_equalTo(self.navView);
        make.width.mas_equalTo(40);
    }];
    //添加监听整个锦标赛开始结束倒计时
    [self addBigTimer];
//    [self show];
    [self addNoti];
}
- (void)refreshData
{
    if (self.isOpen) {
        [KKAlert showAnimateWithText:nil toView:self.view];
    }
    [KKNetTool getChampionInfoWithCid:self.cId successBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        NSMutableDictionary * dict = self.dataDic.mutableCopy;
        dict[@"champion"] = dic[@"champion"];
        self.dataDic = dict;
        [self refreshAward];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
    }];
}
- (void)refreshAward
{
    NSDictionary * dic = self.dataDic[@"champion"];
    //如果有数据进行处理
    if (dic) {
        if (dic[@"showaward_total"]) {
            self.totalAwardLabel.text = [NSString stringWithFormat:@"%@",dic[@"showaward_total"]];
        } else {
            self.totalAwardLabel.text = @"0";
        }
    }
}
- (void)dealData
{
    //锦标赛没结束，有比赛才处理
    NSDictionary * match = self.dataDic[@"match"];
    if (match) {
        self.isSelfInGame = YES;//有未结束的比赛
        NSNumber * starttime = match[@"starttime"];
        NSNumber * deadline = match[@"deadline"];
        self.beginTime = starttime.integerValue;//比赛开始时间
        self.endTime = deadline.integerValue;//5分钟倒计时
        self.matchId = match[@"id"];//比赛id
        [self addStartMatchTimer];
        //有比赛，禁止离开
        self.isLeave = NO;
    }
}
-(void)setFree:(NSInteger)free
{
    _free = free;
    if (_free < 0) {
        _free = 0;
    }
//    self.ticketNumberLabel.text = [NSString stringWithFormat:@"入场券  %ld",(long)_free];
    if (_free > 0) {
        self.freeLabel.text = [NSString stringWithFormat:@"+  %ld",_free];
        self.freeLabel.superview.hidden = NO;
    } else {
        self.freeLabel.text = @" ";
        self.freeLabel.superview.hidden = YES;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.contentView addCornersWithRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerSize:CGSizeMake(10, 10)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.isLeave) {
        [self destoryTimer];
    }
}
#pragma mark - 添加小房间，用父子控制器实现
//点击免费送的次数说明
- (IBAction)clickInfoBtn:(id)sender {
    KKChampionshipHintView * hintView = [KKChampionshipHintView shareChampionshipHintView];
    hintView.titleLabel.text = @"  ";
    hintView.subtitleLabel.text = @"官方针对该锦标赛赠送的免费入场券，将优先消耗。";
    [hintView.ensureBtn setTitle:@"知道啦"  forState:UIControlStateNormal];
    [self.view addSubview:hintView];
    hintView.frame = [UIScreen mainScreen].bounds;
    hintView.ensureBlock = ^{
    };
}
- (void)addSmallHouse
{
    KKSmallHouseViewController * smallHouse = [KKSmallHouseViewController new];
    [self addChildViewController:smallHouse];
    smallHouse.titleLabel.text = @"锦标赛";
    NSArray * arr = @[@"Chiji_Icon",@"GK_Icon",@"Qiusheng_Icon",@"LOL_Icon"];
    smallHouse.gameIcon.image = [UIImage imageNamed:arr[self.gameId - 1]];
    __weak typeof(self) weakSelf = self;
    smallHouse.clickBlock = ^{
        [weakSelf openRoom];
    };
    self.smallView = smallHouse.view;
    [self.view addSubview:self.smallView];
    [self.smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
    }];
    self.smallView.hidden = YES;
}
#pragma mark - 点击左上角返回按钮
- (IBAction)clickBackBtn:(id)sender {
    if (self.isLeave) {
        //离开
        [self dismiss];
        return;
    }
    //缩小
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    CGRect f = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
        w.frame = f;
    } completion:^(BOOL finished) {
        //反弹动画
        self.smallView.hidden = NO;
        self.bigView.hidden = YES;
        self.navView.hidden = YES;
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - [self tabbarH], ScreenWidth, kSmallHouseHeight);
        self.view.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            w.frame = f;
        } completion:^(BOOL finished) {
            self.isOpen = NO;
        }];
    }];
}
#pragma mark - 点击右侧问号
- (IBAction)clickQuestionBtn:(id)sender {
    KKExplainViewController * explainVc = [KKExplainViewController new];
    explainVc.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"championExplain.png" ofType:nil]];
    [self.navigationController pushViewController:explainVc animated:YES];
    explainVc.navigationItem.title = @"怎么玩锦标赛";
}
#pragma mark - 获取更多门票，显示分享试图
- (IBAction)clickMoreTicketBtn:(id)sender {
    [KKShareTool shareInvitecodeWithViewController:self];
}
#pragma mark - 开始时的提示
//-(UIView *)floatView
//{
//    if (_floatView != nil) {
//        return _floatView;
//    }
//    _floatView = [UIView new];
//    UIView * backView = [UIView new];
//    backView.backgroundColor = [UIColor whiteColor];
//    backView.frame = CGRectMake(ScreenWidth * 0.5 - 140, CGRectGetHeight(self.topImgView.bounds) - 180, 280, 140);
//    backView.layer.cornerRadius = 20;
//    backView.layer.masksToBounds = YES;
//    UIColor * color = kThemeColor;
//    backView.layer.borderColor = color.CGColor;
//    backView.layer.borderWidth = 3;
//    [backView addSubview:self.minLabel];
//    [backView addSubview:self.secondLabel];
//    [_floatView addSubview:backView];
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.frame.origin.y - 80, ScreenWidth, 18)];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:12];
//    NSInteger now = [[KKDataTool shareTools] getDateStamp];
//    int startTimeout = (int)(self.matchBeginTime - now);//距离比赛开始的时间
//    if (startTimeout > 0) {
//        label.text = @"距离比赛开始还有";
//    } else {
//        label.text = @"距离比赛结束还有";
//    }
//    [_floatView addSubview:label];
////    UIImageView * imgView = [UIImageView new];
////    imgView.image = [UIImage imageNamed:@"redPocketFloat"];
////    [_floatView addSubview:imgView];
////    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.left.right.bottom.mas_equalTo(self->_floatView);
////    }];
//
//    return _floatView;
//}
#pragma mark - 懒加载属性 显示三分钟倒计时分钟秒数的label
-(UILabel *)minLabel
{
    if (_minLabel) {
        return _minLabel;
    }
    _minLabel = [UILabel new];
    _minLabel.font = [UIFont systemFontOfSize:100];
    _minLabel.textAlignment = NSTextAlignmentCenter;
    _minLabel.textColor = [UIColor whiteColor];
    _minLabel.layer.cornerRadius = 15;
    _minLabel.layer.masksToBounds = YES;
    _minLabel.backgroundColor = [UIColor colorWithRed:77/155.0 green:123/255.0 blue:254/255.0 alpha:1];
    _minLabel.frame = CGRectMake(10, 10, 125, 120);
    _minLabel.text = @"02";
    return _minLabel;
}
-(UILabel *)secondLabel
{
    if (_secondLabel) {
        return _secondLabel;
    }
    _secondLabel = [UILabel new];
    _secondLabel.font = [UIFont systemFontOfSize:100];
    _secondLabel.text = @"59";
    _secondLabel.textColor = [UIColor whiteColor];
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.layer.cornerRadius = 15;
    _secondLabel.layer.masksToBounds = YES;
    _secondLabel.backgroundColor = [UIColor colorWithRed:77/155.0 green:123/255.0 blue:254/255.0 alpha:1];;
    _secondLabel.frame = CGRectMake(145, 10, 125, 120);
    return _secondLabel;
}
//-(UILabel *)hintLabel
//{
//    if (_hintLabel) {
//        return _hintLabel;
//    }
//    _hintLabel = [UILabel new];
//    _hintLabel.textColor = [UIColor blackColor];
//    _hintLabel.font = [UIFont systemFontOfSize:12];
//    _hintLabel.frame = CGRectMake(0, self.btmView.frame.origin.y - 21, ScreenWidth, 18);
//    _hintLabel.textAlignment = NSTextAlignmentCenter;
//    _hintLabel.text = @"请在限制时间内开始单排赛，否则视为无效比赛";
//    return _hintLabel;
//}
- (KKHouseTipsView *)houseTipsView
{
    if (!_houseTipsView) {
        _houseTipsView=[[KKHouseTipsView alloc] init];
        _houseTipsView.hidden=true;
        [_houseTipsView setTitle:@"请在限制时间内开始单排赛，否则视为无效比赛"];
    }
    return _houseTipsView;
}
#pragma mark - 获取当前入场券
-(void)getTickets
{
    if ([KKDataTool token] == nil) {
        return;
    }
    [KKNetTool getMyWalletSuccessBlock:^(NSDictionary *dic) {
        NSNumber * ticket = dic[@"ticket"];
        if (ticket) {
            dispatch_main_async_safe((^{
                self.ticketNumberLabel.text = [NSString stringWithFormat:@"入场券  %@",ticket];
            }))
        }
    } erreorBlock:^(NSError *error) {
    }];
}
#pragma mark - 添加通知
- (void)addNoti
{
    //绝地求生有接口，其它游戏上传图片处理
//    if (self.gameId != KKGameTypeJuediQS) {
//        //上传结果图片处理成功之后的处理
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showResult) name:@"submitSuccess" object:nil];//提交结果成功
//    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btmHeightChanged:) name:@"btmHeightChanged" object:nil];//小房间改变高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destoryTimer) name:KKLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KKViewNeedReloadNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTickets) name:KKLoginNotification object:nil];
}
- (void)refreshTickets
{
    [self getTickets];
    [KKAlert showAnimateWithText:nil toView:self.view];
    [KKNetTool getChampionInfoWithCid:self.cId successBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        self.dataDic = dic;
        NSNumber * free = self.dataDic[@"times"];//取到免费次数
        if (free == nil || free.integerValue == 0) {
            self.free = 0;
        } else {
            self.free = free.integerValue;
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
    }];
}
#pragma mark - 绑定账号成功之后
- (void)bindAccountSuccess
{
    [KKNetTool getBindAccountListWithGameid:[NSNumber numberWithInteger:self.gameId] SuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        if (arr.count) {
            NSDictionary * dict = arr.firstObject;
            self.gamerId = dict[@"id"];
            if (self.gamerId == nil) {
                [KKAlert showText:@"获取账号失败" toView:self.view];
                return;
            }
            [self beginChampion];
        }
    } erreorBlock:^(NSError *error) {
        if ([error isKindOfClass:[NSString class]]) {
            [KKAlert showText:(NSString *)error toView:self.view];
        }
    }];
}

#pragma mark - 改变小房间距离底部的距离
- (void)btmHeightChanged:(NSNotification *)noti
{
    NSNumber * h = noti.userInfo[@"btmH"];
    self.btmH = h.floatValue;
}
#pragma mark - 销毁定时器
-(void)destoryTimer
{
    [self stopTimer];
    [self stopEndTimer];
}
#pragma mark - 锦标赛结束时的UI
- (void)showFinalResult
{
    self.isLeave = YES;
//    self.matchId = nil;
    CGFloat time = 0;
    if (self.isOpen == NO) {
        [self openRoom];
        time = 0.5;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_rightBtmBtn) {
            [self->_rightBtmBtn removeFromSuperview];
            self->_rightBtmBtn = nil;
        }
        if (self->_leftBtmBtn) {
            [self->_leftBtmBtn removeFromSuperview];
            self->_leftBtmBtn = nil;
        }
        [self destoryTimer];
        [self.btmView addSubview:self.btmBtn];
        [self.btmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isIphoneX) {
                make.left.mas_equalTo(self.btmView).offset(16);
                make.width.mas_equalTo(self.btmView).offset(-32);
                make.bottom.mas_equalTo(self.btmView);
                make.height.mas_equalTo(49);
            } else {
                make.top.bottom.left.right.mas_equalTo(self.btmView);
            }
        }];
        [self.btmBtn setTitle:@"查看比赛结果" forState:UIControlStateNormal];
        [self.houseTipsView removeFromSuperview];
        self.houseTipsView = nil;
//        [self.hintLabel removeFromSuperview];
//        self.hintLabel = nil;
        UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"haveEnd"]];
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(20);
            make.right.mas_equalTo(self.fromTimeLabel.mas_left).offset(-5);
            make.width.mas_equalTo(121);
            make.height.mas_equalTo(106);
        }];
    });
}
#pragma mark - 显示锦标赛结束的UI

#pragma mark - 一次挑战结束之后的UI处理
-(void)showResult
{
//    self.matchId = nil;
    if (_rightBtmBtn) {
        [_rightBtmBtn removeFromSuperview];
        _rightBtmBtn = nil;
    }
    if (_leftBtmBtn) {
        [_leftBtmBtn removeFromSuperview];
        _leftBtmBtn = nil;
    }
    [self stopTimer];
    [self.btmView addSubview:self.btmBtn];
    [self.btmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isIphoneX) {
            make.top.bottom.mas_equalTo(self.btmView);
            make.left.mas_equalTo(self.btmView).offset(16);
            make.right.mas_equalTo(self.btmView).offset(-16);
        } else {
            make.top.bottom.left.right.mas_equalTo(self.btmView);
        }
    }];
    self.btmBtn.userInteractionEnabled = YES;
    [self.btmBtn setTitle:@"我要挑战" forState:UIControlStateNormal];
    [self.houseTipsView removeFromSuperview];
    self.houseTipsView = nil;
    self.isLeave = YES;
    self.isSelfInGame = NO;
}
#pragma mark - 是否可以退出
-(void)setIsLeave:(BOOL)isLeave
{
    _isLeave = isLeave;
    dispatch_main_async_safe(^{
        if (self->_isLeave) {
            [self.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        } else {
            [self.backBtn setImage:[UIImage imageNamed:@"arrow_down_big_white"] forState:UIControlStateNormal];
        }
    })
}
#pragma mark - 查看结果
- (void)lookupResult
{
    kkLoginMacro
    KKChampionResultNewViewController * vc = [KKChampionResultNewViewController new];
    vc.cId = self.dataDic[@"champion"][@"id"];
    vc.gameId = self.dataDic[@"champion"][@"game"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 添加监听整个锦标赛进程的定时器（添加锦标赛开始结束三分钟之内的处理）
- (void)addBigTimer
{
    NSInteger now = [[KKDataTool shareTools] getDateStamp];//当前时间
    int startTimeout = (int)(self.matchBeginTime - now);//距离比赛开始的时间
    if (startTimeout < 0) {
        //已经开始了，监控结束时间
        int endTimeout = (int)(self.matchEndTime - now);//距离比赛结束的时间
        if (endTimeout < 0 && self.isSelfInGame == NO) {
            //已经结束，并且已提交,显示结束界面
            [self showFinalResult];
            return;
        } else {
            //锦标赛进行中或者有比赛进行中
            __weak typeof(self) weakSelf = self;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.endTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_endTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(_endTimer, ^{
                NSInteger now = [[KKDataTool shareTools] getDateStamp];
                int timeout = (int)(weakSelf.matchEndTime - now);//距离比赛结束的时间
                if(timeout<=0 && self.isSelfInGame == NO){ //倒计时结束，锦标赛结束，关闭
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [weakSelf destoryTimer];//停止计时器
                        [weakSelf showFinalResult];//显示停止的界面
                    });
                }
//                else if(timeout < 180 && timeout > 0){
//                    //距离比赛结束三分钟之内
//                }
            });
        }
    } else {
        //尚未开始，监控开始时间
//        [self.btmBtn setTitle:@"我要挑战" forState:UIControlStateNormal];
//        self.btmBtn.backgroundColor = kThemeColorTranslucence;
//        self.btmBtn.userInteractionEnabled = NO;//未开始不能开始挑战
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.endTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_endTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        
        dispatch_source_set_event_handler(_endTimer, ^{
            NSInteger now = [[KKDataTool shareTools] getDateStamp];
            int timeout = (int)(weakSelf.matchBeginTime - now);//距离比赛开始的时间
            if(timeout<=0){ //锦标赛开始了
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf stopEndTimer];//结束当前的计时器
                    [weakSelf addBigTimer];//重新开启监听整个锦标赛的计时器
                });
            }
//            else if(timeout < 180){
            //距离比赛开始三分钟之内
//            }
        });
    }
    dispatch_resume(_endTimer);
}
#pragma mark - 停止开始和提交结果计时器（停止10分钟和50分钟倒计时）
- (void)stopTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
#pragma mark - 停止监听整个锦标赛的计时器
- (void)stopEndTimer
{
    if (_endTimer) {
        dispatch_source_cancel(_endTimer);
        _endTimer = nil;
    }
}
#pragma mark - 把秒数转换成分钟和秒数，1小时之内的
-(NSString*)timeStrWithTime:(int)time
{
    return [NSString stringWithFormat:@"%02d:%02d",time/60,time%60];
}
#pragma mark - 添加提交战绩倒计时
- (void)addSubmitTimer
{
    [self stopTimer];
    [self.houseTipsView setTitle:@"请在限制时间内提交战绩，否则视为挑战失败"];
    __weak typeof(self) weakSelf = self;
    KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
    [vc.rightBtn setTitle:@"提交战绩" forState:UIControlStateNormal];
    vc.timeLabel.text = @" ";
    [vc.view addSubview:vc.clockIcon];
    vc.clickRightBtnBlock = ^{
        [weakSelf uploadResult];
    };
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    GameItem * item = [KKDataTool itemWithGameId:self.gameId];//当前游戏对应的item
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger now = [[KKDataTool shareTools] getDateStamp];
//        if (now > weakSelf.matchEndTime) {
//            //如果比赛已经结束，则显示最终的UI,有大定时器处理
////            [weakSelf showFinalResult];
//            return;
//        }
        int timeout = (int)(self.beginTime + item.resultinseconds.integerValue - now);//距离提交战绩结束的时间
        if(timeout<=0){ //超时未提交
            [weakSelf showTimeOutUi];
        } else {
            NSString * timeStr = [self timeStrWithTime:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.rightBtmBtn setTitle:[NSString stringWithFormat:@"提交战绩(%@)",timeStr] forState:UIControlStateNormal];
                vc.timeLabel.text = timeStr;
            });
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - 显示超时未提交的UI
-(void)showTimeOutUi
{
    [self stopTimer];
    self.isLeave = YES;
    self.isSelfInGame = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_rightBtmBtn) {
            [self->_rightBtmBtn removeFromSuperview];
            self->_rightBtmBtn = nil;
        }
        if (self->_leftBtmBtn) {
            [self->_leftBtmBtn removeFromSuperview];
            self->_leftBtmBtn = nil;
        }
        self.houseTipsView.hidden = YES;
//        self.hintLabel.hidden = YES;
        [self.btmView addSubview:self.btmBtn];
        [self.btmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isIphoneX) {
                make.left.mas_equalTo(self.btmView).offset(16);
                make.width.mas_equalTo(self.btmView).offset(-32);
                make.bottom.mas_equalTo(self.btmView);
                make.height.mas_equalTo(49);
            } else {
                make.top.bottom.left.right.mas_equalTo(self.btmView);
            }
        }];
        [self.btmBtn setTitle:@"查看比赛结果" forState:UIControlStateNormal];
    });
}

#pragma mark - 添加开始比赛倒计时(10分钟倒计时)
-(void)addStartMatchTimer
{
    [self.houseTipsView setTitle:@"请在限制时间内开始比赛，否则视为挑战失败"];
    [self addBtmBtns];
    [self stopTimer];
    [self.view addSubview:self.houseTipsView];
    __weak typeof(self) weakSelf = self;
    KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
    [vc.rightBtn setTitle:@"开始比赛" forState:UIControlStateNormal];
    vc.timeLabel.text = @" ";
    [vc.view addSubview:vc.clockIcon];
    vc.clickRightBtnBlock = ^{
        [weakSelf uploadResult];
    };
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger now = [[KKDataTool shareTools] getDateStamp];
        int timeout = (int)(self.endTime - now);//距离5分钟的时间
        if(timeout<=0){ //倒计时结束，关闭
            //添加提交按钮
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf addSubmitTimer];
            });
        } else {
            NSString * timeStr = [self timeStrWithTime:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.rightBtmBtn setTitle:[NSString stringWithFormat:@"开始单排赛(%@)",timeStr] forState:UIControlStateNormal];
                vc.timeLabel.text = timeStr;
            });
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - 点击底部按钮，开始挑战
- (IBAction)clickBtmBtn:(id)sender {
    //现在存在的title有，[我要挑战,查看比赛结果]
    NSString * currentTitle = self.btmBtn.currentTitle;
    if ([currentTitle isEqualToString:@"我要挑战"]) {
        if ([KKDataTool token] == nil) {
            [KKDataTool showLoginVc];
            return;
        }
        NSInteger now = [[KKDataTool shareTools] getDateStamp];
        int startTimeout = (int)(self.matchBeginTime - now);//距离比赛开始的时间
        if (startTimeout > 0) {
            [KKAlert showText:@"锦标赛还未开始" toView:self.view];
            return;
        }
        [self showTiaozhanHint];
        return;
    }
    if ([currentTitle isEqualToString:@"查看比赛结果"]) {
        [self lookupResult];
    }
}
#pragma mark - 开始挑战提示
- (void)showTiaozhanHint
{
    NSDictionary * dic = self.dataDic[@"champion"];
    //先判断游戏类型
    NSNumber * type = dic[@"type"];
    if (type.integerValue != 1) {
        [KKAlert showText:@"该版本暂不支持此锦标赛" toView:self.view];
        return;
    }
    KKChampionshipHintView * hintView = [KKChampionshipHintView shareChampionshipHintView];
    hintView.titleLabel.text = @"是否确认消耗1张入场券开始挑战~";
    hintView.subtitleLabel.text = @"";
    [hintView.ensureBtn setTitle:@"确认挑战"  forState:UIControlStateNormal];
    [self.view addSubview:hintView];
    hintView.frame = [UIScreen mainScreen].bounds;
    hintView.ensureBlock = ^{
        [self beginChampion];
    };
}
//显示消耗入场券的提示
- (void)showExchangeHint
{
    KKChampionshipHintView * hintView = [KKChampionshipHintView shareChampionshipHintView];
    hintView.titleLabel.text = @"消耗1张入场券参加比赛~";
    hintView.subtitleLabel.text = @"";
//    [NSString stringWithFormat:@"请在%d分钟内开始排位赛，不然视为无效比赛哟~",kBeforeSubmitResultMinite]
    [hintView.ensureBtn setTitle:@"确认挑战"  forState:UIControlStateNormal];
    [self.view addSubview:hintView];
    hintView.frame = [UIScreen mainScreen].bounds;
    hintView.ensureBlock = ^{
        [KKAlert showText:nil toView:self.view];
        [KKNetTool championExchangeWithCid:self.cId SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:self.view];
            NSNumber * ticket = dic[@"tickets"];
            if (ticket) {
                self.ticketNumberLabel.text = [NSString stringWithFormat:@"入场券  %@",ticket];
            }
            //如果消耗了入场券，会返回剩余入场券的数量{"tickets":0}
            [self enterInChampionGame];
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:self.view];
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            }
        }];
    };
}
#pragma mark - 开始锦标赛
- (void)beginChampion
{
    //已经获取到了，游戏账号
//    if (self.gamerId) {
//        [self enterInChampionGame];
//        return;
//    }
    [self getBindGamerId];
}
#pragma mark - 获取绑定的游戏的gamerId
- (void)getBindGamerId
{
    NSNumber * game = self.dataDic[@"champion"][@"game"];
    [KKNetTool getBindAccountListWithGameid:game SuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        NSDictionary * dict = arr.firstObject;
        if (dict) {
            self.gamerId = dict[@"id"];
            if (self.gamerId == nil) {
                [KKAlert showText:@"获取账号失败" toView:self.view];
                return;
            }
            [self enterInChampionGame];
        } else {
            //提示绑定账号
            self.hintView = [KKHintView shareHintView];
            [self.hintView assignWithGameId:self.gameId];
            __weak typeof(self) weakSelf = self;
            self.hintView.ensureBlock = ^{
                KKBindAccountViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bindAccountVC"];
                vc.gameId = weakSelf.gameId;
//                vc.bindBlock = ^{
//                    [weakSelf bindAccountSuccess];
//                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
    } erreorBlock:^(NSError *error) {
        if ([error isKindOfClass:[NSString class]]) {
            [KKAlert showText:(NSString *)error toView:self.view];
        }
    }];
}
#pragma mark - 调用开始锦标赛接口
- (void)enterInChampionGame
{
    [KKAlert showAnimateWithText:@"加入比赛中" toView:self.view];
    [KKNetTool beginChampionMatchWithCid:self.dataDic[@"champion"][@"id"] gamerId:self.gamerId successBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        NSNumber * code = dic[@"c"];
        NSDictionary * dict = dic[@"d"];
        if (code.integerValue == 0) {
            //bz 标记 开始比赛
            NSNumber * free = dict[@"times"];
            if (free) {
                self.free = free.integerValue;
            } else {
                self.free = self.free - 1;
            }
            NSDictionary * match = dict[@"match"];
            self.matchId = match[@"id"];
            NSNumber * starttime = match[@"starttime"];
            self.beginTime = starttime.integerValue;
            NSNumber * endtime = match[@"deadline"];
            self.endTime = endtime.integerValue;//5分钟结束的时间
            self.isLeave = NO;
            self.isSelfInGame = YES;
            [self addStartMatchTimer];
        } else if(code.integerValue == 60005){
            //没有免费入场券需要兑换
            NSNumber * ticket = dict[@"tickets"];
            //            if (ticket) {
            //                self.ticketNumberLabel.text = [NSString stringWithFormat:@"入场券  %@",ticket];
            //            }
            //当前入场券不足，不能兑换
            if (ticket==nil || ticket.integerValue <= 0) {
                [KKAlert showText:@"您暂无入场券" toView:self.view];
                return;
            }
            [self showExchangeHint];
        } else {
            NSString * msg = dic[@"m"];
            if ([msg isEqualToString:@"未登录"]) {
                [KKDataTool showLoginVc];
                return;
            }
            if (msg && [msg isKindOfClass:[NSString class]]) {
                [KKAlert showText:msg toView:self.view];
            }
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
        if ([error isKindOfClass:[NSString class]]) {
            [KKAlert showText:(NSString *)error toView:self.view];
        }
    }];
}
- (void)showGameHint
{
    NSString * btnTitle = self.gameId == KKGameTypeWangzheRY?@"开启王者荣耀排单排赛":@"开启刺激战场单排赛";
    KKChampionshipHintView * hintView = [KKChampionshipHintView shareChampionshipHintView];
    hintView.titleLabel.text = @"夺金提示";
    hintView.subtitleLabel.text = @"参加单排赛战斗，争取超过目标分数!";
    [hintView.ensureBtn setTitle:btnTitle  forState:UIControlStateNormal];
    [self.view addSubview:hintView];
    hintView.frame = [UIScreen mainScreen].bounds;
    hintView.ensureBlock = ^{
        if (self.gameId == KKGameTypeWangzheRY || self.gameId == KKGameTypeCijiZC) {
            [self callGameApp];
        }
    };
}
#pragma mark - 添加底部提交和放弃俩按钮
- (void)addBtmBtns
{
    [self.btmBtn removeFromSuperview];
//    self.hintLabel.text = @"请在限制时间内提交战绩，否则视为挑战失败";
    [self.btmView addSubview:self.leftBtmBtn];
    [self.btmView addSubview:self.rightBtmBtn];
//    [self addSubmitTimer];
}
#pragma mark - 放弃提交按钮
-(UIButton *)leftBtmBtn
{
    if (_leftBtmBtn) {
        return _leftBtmBtn;
    }
    _leftBtmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtmBtn setTitle:@"放弃提交" forState:UIControlStateNormal];
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
#pragma mark - 点击放弃提交按钮
- (void)giveupUploadResult
{
    [self showGiveupHint];
}
#pragma mark - 二次确认是否要提交
- (void)showGiveupHint
{
    KKChampionshipHintView * hintView = [KKChampionshipHintView shareChampionshipHintView];
    hintView.titleLabel.text = @" ";
    hintView.subtitleLabel.text = @"确认放弃提交战绩吗？";
    [hintView.ensureBtn setTitle:@"确认"  forState:UIControlStateNormal];
    [self.view addSubview:hintView];
    hintView.frame = [UIScreen mainScreen].bounds;
    hintView.ensureBlock = ^{
        [KKAlert showAnimateWithText:nil toView:self.view];
        [KKNetTool giveUpChampionWithMatchid:self.matchId SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:self.view];
            [self showResult];
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:self.view];
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            }
        }];
    };
}
#pragma mark - 提交战绩按钮
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
#pragma mark - 点击提交战绩按钮
- (void)uploadResult
{
    NSString * currentTitle = self.rightBtmBtn.currentTitle;
    if ([currentTitle containsString:@"开始单排赛"]) {
        if (self.gameId == 2 || self.gameId == 3) {
            if (self.isOpen == NO) {
                [self openRoom];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showGameHint];
                });
            } else {
                [self showGameHint];
            }
        }
        return;
    }
    //提交
    if (self.gameId == KKGameTypeJuediQS) {
        //如果是绝地求生，直接调用接口
        [KKAlert showAnimateWithText:nil toView:self.view];
        [KKNetTool reportChampionResultWithMatchid:self.matchId SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:self.view];
            if (self.isOpen == NO) {
                KKSmallHouseViewController * vc = self.childViewControllers.firstObject;
                [vc.timeLabel removeFromSuperview];
                vc.timeLabel = nil;
                [vc.rightBtn removeFromSuperview];
                vc.rightBtn = nil;
                vc.clickRightBtnBlock = nil;
                [vc.clockIcon removeFromSuperview];
                vc.clockIcon = nil;
                [self openRoom];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KKAlert showText:@"提交成功" toView:self.view];
                    [self showResult];
                });
            } else {
                [KKAlert showText:@"提交成功" toView:self.view];
                [self showResult];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:self.view];
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            }
        }];
    } else {
        if (self.isOpen == NO) {
            [self openRoom];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                KKSubmitResultViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"submitResultVC"];
//                vc.matchId = self.matchId;
//                vc.gameId = self.gameId;
//                vc.isChampion = YES;
//                __weak typeof(self) weakSelf = self;
//                vc.submitSuccessBlock = ^{
//                    [weakSelf showResult];
//                };
//                [self.navigationController pushViewController:vc animated:YES];
//            });
        } else {
            KKSubmitResultViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"submitResultVC"];
            vc.matchId = self.matchId;
            vc.gameId = self.gameId;
            vc.isChampion = YES;
            __weak typeof(self) weakSelf = self;
            vc.submitSuccessBlock = ^{
                [weakSelf showResult];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 唤起游戏app
- (void)callGameApp
{
    dispatch_main_async_safe(^{
        NSString * gUrl = self.gameId==KKGameTypeWangzheRY?kWZRYUrl:kCJZCUrl;
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gUrl] options:@{} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gUrl]];
        }
    })
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 创建之后显示
- (void)show
{
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    w.hidden = YES;
    if (self.isSmall) {
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - [self tabbarH], ScreenWidth, kSmallHouseHeight);
        self.smallView.hidden = NO;
        self.bigView.hidden = YES;
        w.frame = f;
        self.isOpen = NO;
        self.view.backgroundColor = [UIColor clearColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            w.hidden = NO;
            self.isSmall = NO;
        });
        return;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
        self.smallView.hidden = YES;
        self.bigView.hidden = NO;
        self.navView.hidden = NO;
        CGRect f = [UIScreen mainScreen].bounds;
        w.frame = f;
        w.hidden = NO;
    } completion:^(BOOL finished) {
        self.isOpen = YES;
    }];
}
#pragma mark - 消失的动画，包括销毁
- (void)dismiss
{
    if (self.isOpen == NO) {
        [self destoryTimer];
        if (self.secondWindow) {
            [[KKDataTool shareTools] destroyShowWindow];
        } else {
            [[KKDataTool shareTools] destroyWindow];
        }
        return;
    }
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
//    CGFloat h = ScreenHeight - [KKDataTool statusBarH] - (isIphoneX?34:0);
//    CGRect f = CGRectMake(ScreenWidth, [KKDataTool statusBarH], ScreenWidth, h);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
        self.smallView.hidden = YES;
        self.bigView.hidden = NO;
        self.navView.hidden = NO;
        w.mj_x = ScreenWidth;
    } completion:^(BOOL finished) {
        [self destoryTimer];
        if (self.secondWindow) {
            [[KKDataTool shareTools] destroyShowWindow];
        } else {
            [[KKDataTool shareTools] destroyWindow];
        }
    }];
}
#pragma mark - 设置小房间距离底部的距离
- (void)setBtmH:(CGFloat)btmH
{
    _btmH = btmH;
    if (self.isOpen) {
        return;
    }
    dispatch_main_async_safe(^{
        UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - self.btmH, ScreenWidth, kSmallHouseHeight);
        [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
            w.frame = f;
        } completion:^(BOOL finished) {
            self.isOpen = NO;
        }];
    })
}
#pragma 放大
- (void)openRoom {
    dispatch_main_async_safe(^{
        UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
        w.mj_h = ScreenHeight;
        self.view.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
            self.bigView.hidden = NO;
            self.navView.hidden = NO;
            self.smallView.hidden = YES;
            w.mj_y = 0;
        } completion:^(BOOL finished) {
            self.isOpen = YES;
            [self refreshData];
        }];
    });
}
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
@end
