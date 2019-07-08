//
//  KKMessageViewController.m
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//
#warning todo  活动和通知接口测试，是否需要下拉刷新，有数据需测试，还有分页

#import "KKMessageViewController.h"
#import "KKNotiMessageListViewController.h"
#import "KKActionMessageListTableViewController.h"
@interface KKMessageViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic,strong) UIButton * currentBtn;//当前选中的btn
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArr;
@end

@implementation KKMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.contentScrollView.scrollsToTop = NO;
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    [self.btnArr[0] setSelected:YES];
    self.currentBtn = self.btnArr[0];
    [self addChildVC];
    [self addChildVcViewIntoScrollView:0];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    KKNavigationController * nav = (KKNavigationController *)self.navigationController;
//    [nav removeShadow];
//}
- (void)addChildVC
{
    KKActionMessageListTableViewController * vc = [KKActionMessageListTableViewController new];
    KKNotiMessageListViewController * vc1 = [KKNotiMessageListViewController new];
    [self addChildViewController:vc];
    [self addChildViewController:vc1];
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

- (IBAction)clickTopBtn:(UIButton *)sender {
    if (sender == self.currentBtn) {
        return;
    }
    self.currentBtn.selected = NO;
    self.currentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.currentBtn = sender;
    NSUInteger index = sender.tag;
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = self.line.center;
        center.x = sender.center.x;
        self.line.center = center;
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
