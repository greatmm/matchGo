//
//  KKPublishAgainstViewController.m
//  game
//
//  Created by GKK on 2018/10/11.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKPublishAgainstViewController.h"
#import "KKPAgainstViewController.h"
#import "KKAgainstTopControl.h"
#import "KKAaginstMidControl.h"
#import "KKSelAgainstTableViewCell.h"
#import "ChoiceItem.h"
#import "KKShareView.h"
#import "KKExplainViewController.h"
@interface KKPublishAgainstViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *hintLine;//下边的线
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;//顶部四个按钮
@property (nonatomic,strong) UIButton * currentBtn;//当前选中的按钮
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;//加载四个控制器view的scrollView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewToTop;

@end

@implementation KKPublishAgainstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布对战";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarbutton)];
    [self addChildVC];
    self.houseBtm = isIphoneX?(34 + 59):(59);
}
#pragma mark - 点击了右侧的？
- (void)clickRightBarbutton
{
    KKExplainViewController * explainVc = [KKExplainViewController new];
    explainVc.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"matchExplain.png" ofType:nil]];
    [self.navigationController pushViewController:explainVc animated:YES];
    explainVc.navigationItem.title = @"怎么玩对战赛";
}
#pragma mark - 添加子控制器
- (void)addChildVC
{
    NSArray * games = [KKDataTool games];
    if (games == nil) {
        
        return;
    }
    NSInteger count = games.count;
    if (count == 0) {
        return;
    }
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * count, 0);
    for (int i = 0; i < count; i ++) {
        KKPAgainstViewController * vc = [[UIStoryboard storyboardWithName:@"KKParted" bundle:nil] instantiateViewControllerWithIdentifier:@"paViewController"];
        GameItem * item = games[i];
        vc.gameId = item.gameId.integerValue;
        [self addChildViewController:vc];
        UIButton * btn = self.btns[i];
        [btn setTitle:item.gameName forState:UIControlStateNormal];
    }
    for (NSInteger i = count; i < 4; i ++) {
        UIButton * btn = self.btns[i];
        btn.hidden = YES;
    }
    self.currentBtn = self.btns.firstObject;//默认选中第一个
    [self addChildVcViewIntoScrollView:0];
    if (count == 1) {
        self.currentBtn.hidden = YES;
        self.scrollViewToTop.constant = -44;
        [self.view layoutIfNeeded];
    }
}
#pragma mark - 添加子试图
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    // 设置子控制器view的frame
    childVcView.frame = self.scrollView.bounds;
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
    childVcView.mj_x = index * ScreenWidth;
}
#pragma mark - 点击顶部四个按钮，切换游戏
- (IBAction)clickTopBtn:(UIButton *)sender {
    if (sender == self.currentBtn) {
        return;
    }
    self.currentBtn.selected = NO;
    self.currentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.currentBtn = sender;
    NSUInteger index = [self.btns indexOfObject:self.currentBtn];
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = self.hintLine.center;
        center.x = sender.center.x;
        self.hintLine.center = center;
        CGFloat offsetX = ScreenWidth * index;
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        [self addChildVcViewIntoScrollView:index];
    }];
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        if (!childVc.isViewLoaded) continue;
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        scrollView.scrollsToTop = (i == index);
    }
}
#pragma mark - 点击底部按钮，创建房间
- (IBAction)publishRoom:(id)sender {
    kkLoginMacro
    KKPAgainstViewController * vc = self.childViewControllers[self.currentBtn.tag];
    [vc createRoom];
}

@end
