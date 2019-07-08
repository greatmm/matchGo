//
//  KKMoneyRecordViewController.m
//  game
//
//  Created by GKK on 2018/10/24.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKMoneyRecordViewController.h"
#import "KKWalletListViewController.h"

@interface KKMoneyRecordViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic,strong) UIButton * currentBtn;//当前选中的btn
@property (strong, nonatomic) NSArray<UIButton*>*btnArr;
@end

@implementation KKMoneyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavview];
    self.contentScrollView.scrollsToTop = NO;
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    [self addChildVC];
    if (self.contentScrollView.delegate && [self.contentScrollView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.contentScrollView.delegate scrollViewDidEndDecelerating:self.contentScrollView];
    }
}
- (void)setNavview
{
    self.navigationItem.rightBarButtonItem = nil;
    UIView * topView = [UIView new];
    topView.frame = CGRectMake(ScreenWidth * 0.5 - 105, 0, 210, 44);
    self.navigationItem.titleView = topView;
    NSArray * arr = @[@"提现记录",@"收入记录"];
    NSMutableArray * btns = [NSMutableArray new];
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:kTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:kThemeColor forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btns addObject:btn];
        btn.frame = CGRectMake(105 * i, 2, 105, 40);
        [topView addSubview:btn];
    }
    self.btnArr = btns;
}
- (void)addChildVC
{
    for (int i = 0; i < 2; i ++) {
        KKWalletListViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"walletList"];
        vc.type = i + 3;
        vc.numberStr = self.moneyStr;
        [self addChildViewController:vc];
    }
}

- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    childVcView.frame = CGRectMake(index * ScreenWidth, 0, CGRectGetWidth(self.contentScrollView.bounds), CGRectGetHeight(self.contentScrollView.bounds));
    // 添加子控制器的view到scrollView中
    [self.contentScrollView addSubview:childVcView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x/ScreenWidth;
    UIButton * btn = self.btnArr[index];
    [self clickTopBtn:btn];
}
- (void)clickTopBtn:(UIButton *)sender {
    if (sender == self.currentBtn) {
        return;
    }
    self.currentBtn.selected = NO;
    sender.selected = YES;
    self.currentBtn = sender;
    NSUInteger index = sender.tag;
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat offsetX = ScreenWidth * index;
        self.contentScrollView.contentOffset = CGPointMake(offsetX, self.contentScrollView.contentOffset.y);
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

@end
