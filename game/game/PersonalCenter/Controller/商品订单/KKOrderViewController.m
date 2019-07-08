//
//  KKOrderViewController.m
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKOrderViewController.h"
#import "KKAllOrderViewController.h"
#import "KKYiwanchengViewController.h"
#import "KKDaishouhuoViewController.h"
#import "Masonry.h"
@interface KKOrderViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic,strong) UIButton * currentBtn;//当前选中的btn
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArr;

#warning todo 缺：数据

@end

@implementation KKOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品订单";
    self.contentScrollView.scrollsToTop = NO;
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    [self.btnArr[0] setSelected:YES];
    self.currentBtn = self.btnArr[0];
    self.currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addChildVC];
    [self addChildVcViewIntoScrollView:0];
}
//添加子控制器
- (void)addChildVC
{
    KKAllOrderViewController * vc = [KKAllOrderViewController new];
    KKDaishouhuoViewController * vc1 = [KKDaishouhuoViewController new];
    KKYiwanchengViewController * vc2 = [KKYiwanchengViewController new];

    [self addChildViewController:vc];
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
}
//添加子控制器的view到scrollview中
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
//松手的时候定位
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x/ScreenWidth;
    UIButton * btn = self.btnArr[index];
    [self clickTopBtn:btn];
}
//点击button切换view
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
    //确保只有一个scrollview的scrollsToTop为YES可以点击顶部回到最上边
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        if (!childVc.isViewLoaded) continue;
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        scrollView.scrollsToTop = (i == index);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
