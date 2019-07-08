//
//  KKHintView.m
//  game
//
//  Created by GKK on 2018/8/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKHintView.h"
@interface KKHintView()
@property (weak, nonatomic) IBOutlet UIImageView *topBackImgView;

@end
@implementation KKHintView
- (IBAction)close:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
    [[KKDataTool shareTools] destroyAlertWindow];
    
}
- (IBAction)clickBottomBtn:(id)sender {
    if (self.ensureBlock) {
        self.ensureBlock();
    }
    [self removeFromSuperview];
    [[KKDataTool shareTools] destroyAlertWindow];
}
+(instancetype)shareHintView
{
    KKHintView * hintView = [[NSBundle mainBundle] loadNibNamed:@"KKHintView" owner:nil options:nil].firstObject;
    hintView.frame = [UIScreen mainScreen].bounds;
    [KKDataTool shareTools].alertWindow.backgroundColor = [UIColor clearColor];
    [[KKDataTool shareTools].alertWindow addSubview:hintView];
    [[KKDataTool shareTools].alertWindow makeKeyAndVisible];
    return hintView;
}
-(void)assignWithGameId:(NSInteger)gameId
{
    NSArray * arr = @[@"PUBGSquBG",@"GKSquBG",@"ZCSquBG",@"LOLSquBG"];
    NSArray * titleArr = @[@"绝地求生",@"王者荣耀",@"刺激战场",@"英雄联盟"];
    self.topBackImgView.image = [UIImage imageNamed:arr[gameId - 1]];
    self.desLabel.text = [NSString stringWithFormat:@"您尚未绑定%@账号",titleArr[gameId - 1]];
}
@end
