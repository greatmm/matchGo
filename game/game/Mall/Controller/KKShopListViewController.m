//
//  KKShopListViewController.m
//  game
//
//  Created by GKK on 2018/9/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKShopListViewController.h"
#import "KKRectShopViewController.h"
#import "KKHotShopViewController.h"
@interface KKShopListViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property(nonatomic,assign)BOOL arrowOpen;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (nonatomic,strong) UIButton * currentBtn;//当前选中的btn
@end

@implementation KKShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarbutton)];
    self.contentView.scrollsToTop = NO;
    self.contentView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    [self.btns[0] setSelected:YES];
    self.currentBtn = self.btns[0];
    [self addChildVC];
    [self addChildVcViewIntoScrollView:0];
}
- (void)addChildVC
{
    KKRectShopViewController * vc = [KKRectShopViewController new];
    KKHotShopViewController * vc1 = [KKHotShopViewController new];
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
    childVcView.frame = CGRectMake(index * ScreenWidth, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
    // 添加子控制器的view到scrollView中
    [self.contentView addSubview:childVcView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x/ScreenWidth;
    UIButton * btn = self.btns[index];
    [self clickTopBtn:btn];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)clickTopBtn:(UIButton *)sender {
    if (sender == self.currentBtn) {
        return;
    }
    self.currentBtn.selected = NO;
    sender.selected = YES;
    self.currentBtn = sender;
    NSUInteger index = sender.tag;
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = self.line.center;
        center.x = sender.center.x;
        self.line.center = center;
        CGFloat offsetX = ScreenWidth * index;
        self.contentView.contentOffset = CGPointMake(offsetX, self.contentView.contentOffset.y);
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
- (IBAction)clickPriceBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat ang = M_PI;
        if (self.arrowOpen) {
            ang = 0;
        }
        self.arrowOpen = !self.arrowOpen;
        self.arrowImageView.transform = CGAffineTransformMakeRotation(ang);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
