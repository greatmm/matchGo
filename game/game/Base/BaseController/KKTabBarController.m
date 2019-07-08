//
//  KKTabBarController.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "KKTabBarController.h"
#import "KKTabBar.h"
#import "UIImage+KKCategory.h"
@interface KKTabBarController ()

@end

@implementation KKTabBarController

+ (void)load
{
    // 获取哪个类中UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    // 设置字体尺寸:只有设置正常状态下,才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont boldSystemFontOfSize:10];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: kThemeColor} forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -5);
//    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void)viewDidLoad
{
    [self setupAllChildViewControllerWithArr:@[
      @{@"storyboardName":@"KKHomepage",@"title":@"大厅",@"imageName":@"homepage",@"selImageName":@"homepage_sel"},
      @{@"storyboardName":@"KKParted",@"title":@"对战",@"imageName":@"fight",@"selImageName":@"fight_sel"},
     @{@"storyboardName":@"KKPersonal",@"title":@"我的",@"imageName":@"mine",@"selImageName":@"mine_sel"}]];
    //@{@"storyboardName":@"KKMall",@"title":@"商城",@"imageName":@"mall",@"selImageName":@"mall_sel"}
    //关闭半透明效果
    self.tabBar.translucent = NO;
    //去除黑线
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    //添加阴影
//    [self.tabBar addShadowWithFrame:self.tabBar.bounds shadowOpacity:0.05 shadowColor:nil shadowOffset:CGSizeMake(0, -3)];
}
//- (void)setupTabBar
//{
//    KKTabBar *tabBar = [[KKTabBar alloc] init];
//    [self setValue:tabBar forKey:@"tabBar"];
//}
//添加子控制器
- (void)setupAllChildViewControllerWithArr:(NSArray *)vcArr
{
    for (NSDictionary * dict in vcArr) {
        UINavigationController * nv = [[UIStoryboard storyboardWithName:dict[@"storyboardName"] bundle:nil] instantiateInitialViewController];
        nv.tabBarItem.title = dict[@"title"];
        nv.tabBarItem.image = [UIImage imageNamed:dict[@"imageName"]];
        nv.tabBarItem.selectedImage = [UIImage imageNamed:dict[@"selImageName"]];
        [self addChildViewController:nv];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
////    NSInteger index = [tabBar.items indexOfObject:item];
////    NSString * imageName = [NSString stringWithFormat:@"tabbar_back_%ld",index];
////    [tabBar setBackgroundImage:[UIImage imageNamed:imageName]];
//}
@end
