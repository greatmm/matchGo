//
//  KKRewardHeadView.m
//  game
//
//  Created by linsheng on 2019/1/14.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKRewardHeadView.h"
@interface KKRewardHeadView()
//title
@property (nonatomic, strong) UILabel *labelTitle;
//amount
@property (nonatomic, strong) UILabel *labelAmount;

//名次
@property (nonatomic, strong) UILabel *labelMingc;
//奖励
@property (nonatomic, strong) UILabel *labelJiangl;
@property (nonatomic, strong) UIImageView *imagevG;
@end
@implementation KKRewardHeadView
- (id)init{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, kScreenWidth, H(164));
        [self nbBZLazyInitialization];
        [self addLineWithTop:0];
        [self addLineWithTop:H(114)];
        [self setAmount:@"10000"];
        //line 8
    }
    return self;
}
#pragma mark set/get

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle=[[UILabel alloc] initWithText:@"当前奖励" color:MTK16RGBCOLOR(0x101D37) fontSize:H(12) forFrame:CGRectMake(H(53), H(8)+(H(106)-H(17))/2, 100, H(17))];
    }
    return _labelTitle;
}
- (UILabel *)labelAmount
{
    if (!_labelAmount) {
        _labelAmount=[[UILabel alloc] initWithText:@"10000" color:MTK16RGBCOLOR(0x101D37) fontSize:H(40) forFrame:CGRectMake(H(132), H(8)+(H(106)-H(40))/2, 200, H(40))];
    }
    return _labelAmount;
}
- (UIImageView *)imagevG
{
    if (!_imagevG) {
        _imagevG=[[UIImageView alloc] initWithFrame:CGRectMake(0, H(8)+(H(106)-H(24))/2, 24, 24)];
        _imagevG.image=MTKImageNamed(@"coin_big");
    }
    return _imagevG;
}
- (UILabel *)labelMingc
{
    if (!_labelMingc) {
        _labelMingc=[[UILabel alloc] initWithText:@"名次" color:MTK16RGBCOLOR(0x101D37) fontSize:H(14) forFrame:CGRectMake(H(32), H(122), 100, H(42))];
    }
    return _labelMingc;
}
- (UILabel *)labelJiangl
{
    if (!_labelJiangl) {
        _labelJiangl=[[UILabel alloc] initWithText:@"奖励(金币)" color:MTK16RGBCOLOR(0x101D37) fontSize:H(14) forFrame:CGRectMake(kScreenWidth-H(30)-100, H(122), 100, H(42))];
        _labelJiangl.textAlignment=NSTextAlignmentRight;
    }
    return _labelJiangl;
}
- (void)setAmount:(NSString *)amount
{
    _labelAmount.text=amount;
    [_labelAmount bzAutoSizeFit];
    _imagevG.left=_labelAmount.right;
}
@end
