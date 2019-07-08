//
//  KKEnsurePayView.m
//  game
//
//  Created by GKK on 2018/9/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKEnsurePayView.h"

@implementation KKEnsurePayView

+(instancetype)sharePayView
{
    KKEnsurePayView * payView = [[NSBundle mainBundle] loadNibNamed:@"KKEnsurePayView" owner:nil options:nil].firstObject;
    payView.frame = [UIScreen mainScreen].bounds;
    return payView;
}

- (IBAction)clickCloseBtn:(id)sender {
    [self removeFromSuperview];

}
- (IBAction)clickPayBtn:(id)sender {
    [self removeFromSuperview];
}


@end
