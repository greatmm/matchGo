//
//  KKNavigationController.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "KKNavigationController.h"
@interface KKNavigationController ()

@end

@implementation KKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.shadowImage = [UIImage new];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];//不加这行，ios11以下还有黑线
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHidden object:nil];
}
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    UIViewController * popVC = [super popViewControllerAnimated:animated];
//    if (self.childViewControllers.count == 1) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShow object:nil];
//    }
//    return popVC;
//}
//- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
//{
//    NSArray<UIViewController *> * arr = [super popToRootViewControllerAnimated:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShow object:nil];
//    return arr;
//}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)addShadow{
    [self.navigationBar addShadowWithFrame:self.navigationBar.bounds shadowOpacity:0.05 shadowColor:nil shadowOffset:CGSizeMake(0, 3)];
}
-(void)removeShadow{
    self.navigationBar.layer.shadowPath = nil;
    self.navigationBar.layer.shadowOpacity = 0;
    self.navigationBar.layer.shadowOffset = CGSizeZero;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
