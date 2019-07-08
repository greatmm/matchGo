//
//  KKWalletViewController.m
//  game
//
//  Created by GKK on 2018/10/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKWalletViewController.h"
#import "KKWalletListViewController.h"
#import "UIColor+KKCategory.h"
@interface KKWalletViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) UIView *line;
@property (nonatomic,strong) UIButton * currentBtn;//当前选中的btn
@property (strong, nonatomic) NSArray<UIButton*>*btnArr;
@end

@implementation KKWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavview];
    self.contentScrollView.scrollsToTop = NO;
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    [self addChildVC];
    [self.contentScrollView setContentOffset:CGPointMake(ScreenWidth * _type, 0) animated:YES];
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
    self.line = [UIView new];
    self.line.frame = CGRectMake(10, 42, 50, 2);
    self.line.backgroundColor = kThemeColor;
    [topView addSubview:self.line];
    NSArray * arr = @[@{@"t":@"钻石",@"c":@"#6A56F3"},@{@"t":@"金币",@"c":@"#E1964A"},@{@"t":@"入场券",@"c":@"#397CFC"}];
    NSMutableArray * btns = [NSMutableArray new];
    for (int i = 0; i < 3; i ++) {
        NSDictionary * dic = arr[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:dic[@"t"] forState:UIControlStateNormal];
        [btn setTitleColor:kTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:dic[@"c"]] forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btns addObject:btn];
        btn.frame = CGRectMake(70 * i, 2, 70, 40);
        [topView addSubview:btn];
    }
    self.btnArr = btns;
}
- (void)addChildVC
{
    for (int i = 0; i < 3; i ++) {
        KKWalletListViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"walletList"];
        vc.type = i;
        switch (i) {
            case 0:
            {
               vc.numberStr = [KKDataTool decimalNumber:self.model.diamond fractionDigits:0];
            }
                break;
            case 1:
            {
              vc.numberStr = [KKDataTool decimalNumber:self.model.gold fractionDigits:0];
            }
                break;
            case 2:
            {
               vc.numberStr = [KKDataTool decimalNumber:self.model.ticket fractionDigits:0];
            }
                break;
            default:
                break;
        }
//        NSArray * keys = @[@"diamond",@"gold",@"ticket"];
//        NSNumber * num = self.moneyDic[keys[i]];
//        if (num) {
//            vc.numberStr = [KKDataTool decimalNumber:num fractionDigits:0];
//        }
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


-(void)clickRightBarbutton{
    
}
- (void)clickTopBtn:(UIButton *)sender {
    if (sender == self.currentBtn) {
        return;
    }
    self.currentBtn.selected = NO;
    sender.selected = YES;
    self.currentBtn = sender;
    self.line.backgroundColor = [self.currentBtn titleColorForState:UIControlStateSelected];
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
