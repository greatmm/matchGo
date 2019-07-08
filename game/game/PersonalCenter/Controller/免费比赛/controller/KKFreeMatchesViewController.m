//
//  KKFreeMatchesViewController.m
//  game
//
//  Created by greatkk on 2019/1/14.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKFreeMatchesViewController.h"
#import "KKMyInviteViewController.h"
#import "KKRewardRulesViewController.h"
#import "KKInviteTopListViewController.h"
#import "HNUBZScrollManager.h"
#import "KKFreeMatchChoiceView.h"
//#import "KKNewShareView.h"
#import "KKShareTool.h"
@interface KKFreeMatchesViewController ()<HNUBZChoiceViewDelegate>
@property (strong,nonatomic) HNUBZScrollManager * scrollManagerMain;
@property (strong,nonatomic) UIView * contentView;
@end

@implementation KKFreeMatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"免费比赛";
    [self addChildVc];
    [self.view addSubview:self.contentView];
    [self scrollManagerMain];
    [self addShareBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTickets:) name:kFreeMatchTickets object:nil];
}
- (void)refreshTickets:(NSNotification *)noti
{
    NSDictionary * dic = noti.userInfo;
    if ([HNUBZUtil checkDictEnable:dic]) {
        KKFreeMatchChoiceView * headView =(KKFreeMatchChoiceView *) self.scrollManagerMain.viewHeader;
        headView.ticketLabel.text = [NSString stringWithFormat:@"%@",dic[@"sum_tickets"]];
        headView.inviteCountLabel.text = [NSString stringWithFormat:@"%@",dic[@"total"]];
    }
//    @{@"total":self.total,@"sum_tickets":self.sum_tickets}
}
-(UIView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    CGRect f = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 59 - (isIphoneX?34 + 88:64));
    _contentView = [[UIView alloc] initWithFrame:f];
    return _contentView;
}
- (void)addShareBtn
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithHexString:@"#F45C33"];
    [btn setTitle:@"邀请好友" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            CGFloat margin = isIphoneX?16:0;
            make.left.mas_equalTo(self.view).offset(margin);
            make.centerX.mas_equalTo(self.view);
        } else {
            make.right.left.bottom.mas_equalTo(self.view);
        }
        make.height.mas_equalTo(49);
    }];
    if (isIphoneX) {
        btn.layer.cornerRadius = 14;
        btn.layer.masksToBounds = true;
    }
    [btn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickShareBtn
{
    [KKShareTool shareInvitecodeWithViewController:self];
}
- (void)addChildVc
{
    CGRect f = self.contentView.bounds;
    KKMyInviteViewController * inviteVC = [[KKMyInviteViewController alloc] init];
    inviteVC.view.frame = f;
    [self addChildViewController:inviteVC];
    KKRewardRulesViewController * rewardVC = [[KKRewardRulesViewController alloc] init];
    rewardVC.view.frame = f;
    [self addChildViewController:rewardVC];
    KKInviteTopListViewController * topList = [[KKInviteTopListViewController alloc] init];
    topList.view.frame = f;
    [self addChildViewController:topList];
}
- (HNUBZScrollManager *)scrollManagerMain
{
    if (!_scrollManagerMain) {
        CGRect f = self.view.bounds;
        KKFreeMatchChoiceView * headView = [[KKFreeMatchChoiceView alloc] initWithDelegate:self];
        KKMyInviteViewController * inviteVC = self.childViewControllers.firstObject;
        KKRewardRulesViewController * rewardVC = self.childViewControllers[1];
        KKInviteTopListViewController * topList = self.childViewControllers[2];
        _scrollManagerMain=[[HNUBZScrollManager alloc] initWithViewController:@[[[HNUBZBasicView alloc] initWithFrame:f scroll:inviteVC.tableViewMain],[[HNUBZBasicView alloc] initWithFrame:f scroll:(UIScrollView *)rewardVC.view],[[HNUBZBasicView alloc] initWithFrame:f scroll:topList.tableViewMain]] headView:headView mainView:self.contentView];
    }
    return _scrollManagerMain;
}
-(void)hnuSelectViewDidselectIndex:(NSUInteger)index
{
   KKFreeMatchChoiceView * header = (KKFreeMatchChoiceView *) self.scrollManagerMain.viewHeader;
    [header uploadInfo];
    if (index == 2) {
        HNUBZBasicView * basicView = self.scrollManagerMain.arrayVCs[index];
        UIScrollView * scrollView = basicView.scrollViewBZ;
        if (scrollView.contentInset.top!= header.height) {
            float a = header.height-scrollView.contentInset.top;
            scrollView.contentInset=UIEdgeInsetsMake(header.height, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            if (a>0 && scrollView.contentSize.height >= CGRectGetHeight(scrollView.bounds)) {
                scrollView.contentOffset=CGPointMake(0, scrollView.contentOffset.y-a);
            }
        }
    }
    [_scrollManagerMain touchAtIndex:index];
}
- (void)bzChoiceTouchView:(HNUBZChoiceView *)choiceView title:(NSString *)title
{
    DLOG(@"%@",title);
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
