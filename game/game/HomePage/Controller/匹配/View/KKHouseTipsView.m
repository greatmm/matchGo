//
//  KKHouseTipsView.m
//  game
//
//  Created by linsheng on 2018/12/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKHouseTipsView.h"
#import <SDWebImage/UIImage+GIF.h>
#import "LEffectLabel.h"
@interface KKHouseTipsView()
@property (nonatomic, strong) UIImageView *imageGifView;
@property (nonatomic, strong) LEffectLabel *labelTitle;
@end
@implementation KKHouseTipsView

- (id)init
{
    if (self=[super init]) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.layer.shadowColor=[UIColor blackColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(0, 4);
        self.layer.shadowOpacity = 0.1;//阴影透明度,默认为0则看不到阴影
        self.layer.shadowRadius = 3;
//        self.clipsToBounds=true;
        [self addViews];
        [self setConstraints];
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    if ([HNUBZUtil checkStrEnable:title]) {
        self.hidden=false;
        self.labelTitle.text=title;
        UIView * supView = self.superview;
        if (supView) {
            CGFloat h = CGRectGetHeight(self.bounds);
            if (h < W(44)) {
                [self mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(supView);
                    make.width.mas_equalTo(W(343));
                    make.height.mas_equalTo(W(44));
                    make.bottom.mas_equalTo(supView).offset(-59 - (isIphoneX?34:0));
                }];
            }
        }
//        [_labelTitle startAnimation];
        return;
    }
    self.hidden=true;
    self.labelTitle.text=@"";
}
#pragma mark set/get
- (UIImageView *)imageGifView
{
    if (!_imageGifView) {
        _imageGifView=[[UIImageView alloc] init];
        _imageGifView.image=[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:kkBundlePath(@"notice",@"gif")]];
    }
    return _imageGifView;
}
- (LEffectLabel *)labelTitle
{
    if (!_labelTitle) {
//        _labelTitle=[[UILabel alloc] initWithText:@"限定时间内开始比赛" color:MTK16RGBCOLOR(0x707070) fontSize:14 forFrame:CGRectZero];
        _labelTitle=[[LEffectLabel alloc] initWithFrame:CGRectMake(W(50), W(15), W(343 - 50), W(30))];
        _labelTitle.font=[UIFont boldSystemFontOfSize:W(13)];
        _labelTitle.text=@"限定时间内开始比赛";
        _labelTitle.textColor=MTK16RGBCOLOR(0x101D37);
        _labelTitle.effectColor=[UIColor whiteColor];
        [_labelTitle startAnimation];
    }
    return _labelTitle;
}
#pragma mark Method
- (void)addViews
{
    [self addSubview:self.labelTitle];
    [self addSubview:self.imageGifView];
}
- (void)setConstraints
{
    hnuSetWeakSelf;
    [_imageGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(W(10));
        make.top.mas_equalTo(W(7));
        make.width.height.mas_equalTo(W(30));
    }];
//    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.imageGifView);
//        make.left.equalTo(weakSelf.imageGifView.mas_right).mas_offset(W(10));
//        make.height.mas_equalTo(W(30));
//    }];
}
@end
