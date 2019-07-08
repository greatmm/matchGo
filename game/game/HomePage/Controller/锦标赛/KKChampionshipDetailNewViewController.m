//
//  KKChampionshipDetailNewViewController.m
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionshipDetailNewViewController.h"
#import "KKChampionshipNewViewController.h"
#import "KKChampionResultNewViewController.h"
#import "KKExplainViewController.h"
#import "KKChampionResultViewController.h"
#import "KKChampionRankinglistViewController.h"
#import "KKChampionRewardViewController.h"
#import "KKWebViewController.h"
#import "KKShareTool.h"
@interface KKChampionshipDetailNewViewController ()<KKChampionshipNewViewControllerDelegate>
@property (nonatomic, strong) KKChampionshipNewViewController *championshipVC;
@property (nonatomic, strong) KKChampionResultViewController *championshipResultVC;
@property (nonatomic, strong) KKChampionRankinglistViewController *championRankinglistVC;
@property (nonatomic, strong) KKChampionRewardViewController *championRewardVC;
@property (nonatomic, strong) UIButton *buttonBack;
@property (nonatomic, assign) BOOL boolWindowStatus;
@end

@implementation KKChampionshipDetailNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //判断是不是push进去的 可能有bug
    _boolWindowStatus=(self.navigationController.viewControllers.count<=1)?true:false;
    if (!_dataDic&&_cId) {
        [KKAlert showAnimateWithText:@"" toView:self.view];
        _modelChampionships=[[KKChampionshipsModel alloc] init];
        _modelChampionships.cid=_cId;
        hnuSetWeakSelf;
        [_modelChampionships getChampionWithData:^(BOOL isSucceeded, NSString *msg, NSError * _Nullable error,id _Nullable responseObjectData){
            [KKAlert dismissWithView:weakSelf.view];
            if (isSucceeded) {
                weakSelf.dataDic=responseObjectData;
                [weakSelf initAllInfo];
            }
         }];
    }
    else
    {
        _modelChampionships=[[KKChampionshipsModel alloc] init];
       [_modelChampionships injectJSONData:[_modelChampionships dealWithData:_dataDic]];
        [self initAllInfo];
    }
    
    // Do any additional setup after loading the view.
}
- (void)initAllInfo
{
    [self addShareNavigationItem];
    //测试代码 判断push 进来的 还是 window上面加的
    if (_boolWindowStatus) {
        [self addSmallHouse];
        [self addBackNavigationItem];
        
    }
    
    [self addAllViewControllers];
    if (self.boolSelectResult) {
        self.index=self.arrayVCs.count-1;
    }
}
- (void)addAllViewControllers
{
    self.title=_modelChampionships.exChampionName;
    //规则回头用URL
//    KKExplainViewController *explainVc=[KKExplainViewController new];
//     explainVc.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"championExplain.png" ofType:nil]];
    KKWebViewController *webView=[[KKWebViewController alloc] init];
    
    if (_modelChampionships.type==KKChampionshipsTypeRating) {
        
        [webView loadUrl:@"https://www.matchgo.co/h5/normal_champion.html"];
        [super initWithTitles:@[@"赛况",@"规则",@"战绩",@"排行"] vcs:@[self.championshipVC,webView,self.championshipResultVC,self.championRankinglistVC]];
    }
    else
    {
        [webView loadUrl:@"https://www.matchgo.co/h5/award_champion.html"];
        [super initWithTitles:@[@"赛况",@"奖励",@"规则",@"战绩",@"排行"] vcs:@[self.championshipVC,self.championRewardVC,webView,self.championshipResultVC,self.championRankinglistVC]];
    }
    
    self.selectViewMain.selectColor=_modelChampionships.exChampionColor;
}

#pragma mark Method
//返回按钮
- (void)addBackNavigationItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    //back
    [backButton setImage:MTKImageNamed(@"back") forState:UIControlStateNormal];
    _buttonBack=backButton;
    [backButton setTintColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItem;
}
//分享
- (void)addShareNavigationItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
     backButton.frame = CGRectMake(0, 0, 90, 44);
    UIImageView *imageTips=[[UIImageView alloc] initWithFrame:CGRectMake(0, (backButton.height-18)/2, 58, 18)];
    imageTips.image=MTKImageNamed(@"freeTips");
    UIImageView *imageShare=[[UIImageView alloc] initWithFrame:CGRectMake(backButton.width-16, (backButton.height-16)/2, 16, 16)];
    imageShare.image=MTKImageNamed(@"shareIconCom");
    [backButton addSubview:imageTips];
    [backButton addSubview:imageShare];
    [backButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem=backItem;
}
- (void)addSmallHouse
{
    _smallHouse = [KKSmallHouseViewController new];
//    [self.navigationController addChildViewController:smallHouse];
    _smallHouse.titleLabel.text = @"锦标赛";
    NSArray * arr = @[@"Chiji_Icon",@"GK_Icon",@"Qiusheng_Icon",@"LOL_Icon"];
    _smallHouse.gameIcon.image = [UIImage imageNamed:arr[self.gameId.integerValue - 1]];
    __weak typeof(self) weakSelf = self;
    _smallHouse.clickBlock = ^{
        [weakSelf openRoom];
    };
//    self.smallView = smallHouse.view;
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    [w addSubview:_smallHouse.view];
    [_smallHouse.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(kScreenWidth-32);
    }];
    [_smallHouse.rightBtn  setBackgroundColor:_modelChampionships.exChampionColor];
    _smallHouse.view.hidden = YES;
    self.championshipVC.smallHouse=_smallHouse;
}
#pragma mark - 创建之后显示
#pragma mark KKChampionshipNewViewControllerDelegate
- (void)show
{
    if (!_boolWindowStatus) {
        return;
    }
    UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
    w.hidden = YES;
    if (self.isSmall) {
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - kTabStatusBarHeight-49, ScreenWidth, kSmallHouseHeight);
        _smallHouse.view.hidden = NO;
        self.navigationController.view.hidden = YES;
        w.frame = f;
        self.championshipVC.isOpen = NO;
        self.view.backgroundColor = [UIColor clearColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            w.hidden = NO;
            self.isSmall = NO;
        });
        return;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
        self.smallHouse.view.hidden = YES;
        self.navigationController.view.hidden = NO;
        CGRect f = [UIScreen mainScreen].bounds;
        w.frame = f;
        w.hidden = NO;
    } completion:^(BOOL finished) {
        self.championshipVC.isOpen = YES;
    }];
}
//放大，在外边要调用
- (void)openRoom
{
    if (!_boolWindowStatus) {
        return;
    }
    self.index=0;
    dispatch_main_async_safe(^{
        UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
        w.mj_h = ScreenHeight;
        self.view.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
             self.navigationController.view.hidden = NO;
            self.smallHouse.view.hidden = YES;
            w.mj_y = 0;
        } completion:^(BOOL finished) {
            self.championshipVC.isOpen = YES;
            [self.championshipVC refreshData];
        }];
    });
}
//消失
- (void)dismiss
{
    if (!_boolWindowStatus) {
        return;
    }
    if (self.championshipVC.isOpen == NO) {
        [self.championshipVC destoryTimer];
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
        self.smallHouse.view.hidden = YES;
        self.navigationController.view.hidden = NO;
        w.mj_x = ScreenWidth;
    } completion:^(BOOL finished) {
        [self.championshipVC destoryTimer];
        if (self.secondWindow) {
            [[KKDataTool shareTools] destroyShowWindow];
        } else {
            [[KKDataTool shareTools] destroyWindow];
        }
    }];
}
- (void)rightButton:(UIButton *)button
{
    if (_championshipVC.isLeave) {
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
        self.smallHouse.view.hidden = NO;
        self.navigationController.view.hidden = YES;
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - kTabStatusBarHeight-49, ScreenWidth, kSmallHouseHeight);
        self.view.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            w.frame = f;
        } completion:^(BOOL finished) {
            self.championshipVC.isOpen = NO;
        }];
    }];
}
  //更新数据
- (void)dealData
{
    [self.championshipVC dealData];
}
- (void)setIsLeave:(BOOL)isLeave
{
    if (_buttonBack) {
        
        if (isLeave) {
            [_buttonBack setImage:MTKImageNamed(@"back") forState:UIControlStateNormal];
        }
        else [_buttonBack setImage:MTKImageNamed(@"arrow_down_big") forState:UIControlStateNormal];
        
    }
}
- (void)setBtmH:(CGFloat)btmH
{
    if (!_boolWindowStatus) {
        return;
    }
    dispatch_main_async_safe(^{
        UIWindow * w = self.secondWindow==NO?[KKDataTool shareTools].window:[KKDataTool shareTools].showWindow;
        CGRect f = CGRectMake(0, ScreenHeight - kSmallHouseHeight - btmH, ScreenWidth, kSmallHouseHeight);
        [UIView animateWithDuration:0.50 delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
            w.frame = f;
        } completion:^(BOOL finished) {
            self.championshipVC.isOpen = NO;
        }];
    })
}
- (void)lookupResult
{
    self.index=self.arrayVCs.count-1;
}
//分享
- (void)shareButton:(UIButton *)button
{
    [KKShareTool shareInvitecodeWithViewController:self];
}
#pragma mark set/get
- (KKChampionshipNewViewController *)championshipVC
{
    if (!_championshipVC) {
         _championshipVC = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"championshipNew"];
        _championshipVC.delegate=self;
        _championshipVC.cId=_cId;
        _championshipVC.modelChampionships=_modelChampionships;
        _championshipVC.dataDic=_dataDic;
        _championshipVC.matchId=_matchId;
        _championshipVC.gameId=_gameId.integerValue;
        _championshipVC.isSmall=false;
//        vc.secondWindow;
       
    }
    return _championshipVC;
}
- (KKChampionResultViewController *)championshipResultVC
{
    if (!_championshipResultVC) {
        _championshipResultVC = [[KKChampionResultViewController alloc] initWithCid:_cId gameId:_gameId type:_modelChampionships.type];
    }
    return _championshipResultVC;
}
- (KKChampionRankinglistViewController *)championRankinglistVC
{
    if (!_championRankinglistVC) {
        _championRankinglistVC = [[KKChampionRankinglistViewController alloc] initWithType:_modelChampionships.type cid:_cId gameid:_gameId];
    }
    return _championRankinglistVC;
}
- (KKChampionRewardViewController *)championRewardVC
{
    if (!_championRewardVC) {
        _championRewardVC = [KKChampionRewardViewController new];
        _championRewardVC.modelChampionships=_modelChampionships;
    }
    return _championRewardVC;
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic=dataDic;
    NSNumber * game = dataDic[@"champion"][@"game"];//游戏id
    if (game) {
        self.gameId = game;
    }
}

@end
