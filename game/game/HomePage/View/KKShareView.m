//
//  KKShareView.m
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKShareView.h"

@implementation KKShareView

+(instancetype)shareView
{
    KKShareView * shareView = [[NSBundle mainBundle] loadNibNamed:@"KKShareView" owner:nil options:nil].firstObject;
    return shareView;
}
- (IBAction)clickCloseBtn:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)clickShareBtn:(UIButton *)sender {
//    NSLog(@"%ld",sender.tag);
    //1 微信 2朋友圈 4qq 5qq空间 0新浪微博 6复制链接
    [self removeFromSuperview];
    if (self.shareBlock) {
        self.shareBlock(sender.tag);
    }
}

@end
