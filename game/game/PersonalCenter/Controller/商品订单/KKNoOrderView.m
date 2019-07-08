//
//  KKNoOrderView.m
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKNoOrderView.h"
@implementation KKNoOrderView
+(instancetype)shareView
{
    return [[NSBundle mainBundle] loadNibNamed:@"KKNoOrderView" owner:nil options:nil].firstObject;
}
//去逛逛
- (IBAction)clickGoMallBtn:(id)sender {
    UIViewController * vc = [self viewController];
    vc.tabBarController.selectedIndex = 2;
    [vc.navigationController popToRootViewControllerAnimated:NO];
}


@end
