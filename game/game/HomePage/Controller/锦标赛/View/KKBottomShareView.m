//
//  KKBottomShareView.m
//  game
//
//  Created by greatkk on 2018/11/7.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBottomShareView.h"
#import "KKShareTool.h"
@interface KKBottomShareView ()
@property (weak, nonatomic) IBOutlet UIView *btmView;

@end
@implementation KKBottomShareView

- (IBAction)clickShareBtn:(UIButton *)sender {
    [self removeFromSuperview];
    [KKShareTool shareWebPageToPlatformType:sender.tag viewController:[self viewController]];
}
+(instancetype)shareBottomShareView
{
    KKBottomShareView * shareView = [[NSBundle mainBundle] loadNibNamed:@"KKBottomShareView" owner:nil options:nil].firstObject;
    shareView.frame = [UIScreen mainScreen].bounds;
    __weak typeof(shareView) weakSelf = shareView;
    shareView.removeBlock = ^{
        [weakSelf removeFromSuperview];
    };
    return shareView;
}

@end
