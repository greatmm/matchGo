//
//  KKPartedHomeCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/10/11.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKPartedHomeCollectionViewCell.h"
#import "KKPartedHomeControl.h"
#import "GameItem.h"
#import "UIColor+KKCategory.h"
#import "KKPartedViewController.h"

@interface KKPartedHomeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *gameBtn;
@property (strong, nonatomic) IBOutletCollection(KKPartedHomeControl) NSArray *controlArr;
@property (strong,nonatomic) NSDictionary * dataDic;
@property (assign,nonatomic) NSInteger gameId;
@end
@implementation KKPartedHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)assignWithDic:(NSDictionary *)dic
{
    self.dataDic = dic;
    NSDictionary * mainDic = dic[@"main"];
    NSNumber * game = mainDic[@"game"];
    self.gameId = game.integerValue;
    NSArray * arr = @[@"PUBGAgaBack",@"GKAgaBack",@"ZCAgaBack",@"LOLAgaBack"];
    [self.gameBtn setBackgroundImage:[UIImage imageNamed:arr[self.gameId -1]] forState:UIControlStateNormal];
    NSArray * items = dic[@"items"];
    if (items) {
        NSInteger count = items.count;
        for (int i = 0; i < 4; i ++) {
            KKPartedHomeControl * control = self.controlArr[i];
            if (i < count) {
                NSDictionary * item = items[i];
                control.hidden = NO;
                [control.imgView sd_setImageWithURL:[NSURL URLWithString:item[@"image"]] placeholderImage:[UIImage imageNamed:@"choiceDefaultIcon"]];
                control.titleLabel.text = item[@"title"];
                NSString * tag = item[@"tag"];
                if (tag) {
                    control.hintLabel.text = [NSString stringWithFormat:@"  %@  ",tag];
                    control.hintLabel.backgroundColor = [UIColor colorWithHexString:item[@"tag_color"]];
                } else {
                    [control.hintLabel removeFromSuperview];
                    control.hintLabel = nil;
                }
            } else {
                control.hidden = YES;
            }
        }
    }
}
//选择游戏
- (IBAction)clickGameBtn:(id)sender {
    [self setGameItem];
    UIViewController * vc = [self viewController];
    KKPartedViewController * partedVC = [[UIStoryboard storyboardWithName:@"KKParted" bundle:nil] instantiateViewControllerWithIdentifier:@"partedVC"];
    partedVC.paraDic = @{@"game":[NSNumber numberWithInteger:self.gameId]};
    [vc.navigationController pushViewController:partedVC animated:YES];
}

- (IBAction)clickChiceControl:(UIControl *)sender {
    [self setGameItem];
    UIViewController * vc = [self viewController];
    KKPartedViewController * partedVC = [[UIStoryboard storyboardWithName:@"KKParted" bundle:nil] instantiateViewControllerWithIdentifier:@"partedVC"];
    partedVC.paraDic = self.dataDic[@"items"][sender.tag][@"params"];
//    for (NSString * key in partedVC.paraDic) {
//        NSLog(@"参数：%@ == %@",key,partedVC.paraDic[key]);
//    }
    [vc.navigationController pushViewController:partedVC animated:YES];
}
-(void)setGameItem
{
    NSArray * games = [KKDataTool games];
    if (games == nil || self.gameId == 0) {
        return;
    }
    GameItem * item = [KKDataTool itemWithGameId:self.gameId];
    [KKDataTool shareTools].gameItem = item;
}
@end
