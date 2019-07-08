//
//  KKChampionshipHintView.m
//  game
//
//  Created by greatkk on 2018/11/1.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChampionshipHintView.h"

@implementation KKChampionshipHintView
- (IBAction)clickCloseBtn:(id)sender {
    [self removeFromSuperview];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (IBAction)clickEnsureBtn:(id)sender {
    [self removeFromSuperview];
    if (self.ensureBlock) {
        self.ensureBlock();
    }
}
+(instancetype)shareChampionshipHintView
{
    KKChampionshipHintView * hintView = [[NSBundle mainBundle] loadNibNamed:@"KKChampionshipHintView" owner:nil options:nil].firstObject;
    return hintView;
}
+ (void)shareWithTitle:(NSString *)title buttonTitle:(NSString *)btitle tips:(nonnull NSString *)tips view:(nonnull UIView *)view block:(nonnull void (^)(void))ensureBlock
{
    KKChampionshipHintView * hintView = [KKChampionshipHintView shareChampionshipHintView];
    hintView.titleLabel.text = @"确认参赛";
    hintView.subtitleLabel.text = title;
    hintView.tipLabel.text=tips;
    [hintView.ensureBtn setTitle:btitle  forState:UIControlStateNormal];
    [view addSubview:hintView];
    hintView.frame = [UIScreen mainScreen].bounds;
    hintView.ensureBlock = ensureBlock;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
@end
