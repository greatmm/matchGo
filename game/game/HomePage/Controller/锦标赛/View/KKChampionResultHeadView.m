//
//  KKChampionResultHeadView.m
//  game
//
//  Created by linsheng on 2018/12/18.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKChampionResultHeadView.h"

@implementation KKChampionResultHeadView

- (id)initWithDelegate:(id<HNUBZChoiceViewDelegate>)delegate
{
    if (self=[self initWithDeault:@[@"我的战绩",@"获奖排行"] frame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*4/5+W(44)) delegate:delegate]) {
         [self insertSubview:self.imageVMain atIndex:0];
        [self addSubview:self.explainBtn];
        [self.arrayTouchControl addObject:_explainBtn];
    }
    return self;
}
- (void)setMoreView:(UIView *)moreView
{
    _moreView=moreView;
    moreView.top=kScreenWidth*4/5+W(44);
    [self addSubview:_moreView];
}
- (void)clickBackbtn
{
    if ([self.delegate respondsToSelector:@selector(bzChoiceTouchView:title:)]) {
        [self.delegate bzChoiceTouchView:self title:@"back"];
    }
}
- (void)clickExpainBtn
{
    if ([self.delegate respondsToSelector:@selector(bzChoiceTouchView:title:)]) {
        [self.delegate bzChoiceTouchView:self title:@"expain"];
    }
}
- (void)resetAllInfo
{
    [super resetAllInfo];
    
}
//- (float)fSelectHeight
//{
//
//    if (self.selectView.index==1) {
//        _moreView.hidden=false;
//        self.height=kScreenWidth+46+_moreView.height;
//        return kNavigationAllHeight+_moreView.height;
//    }
//    _moreView.hidden=true;
//    self.height=kScreenWidth+46;
//    return kNavigationAllHeight;
//}
- (void)uploadInfo
{
    if (self.selectView.index==1) {
        _moreView.hidden=false;
        self.height=kScreenWidth*4/5+W(44)+_moreView.height;
        self.fSelectHeight= kNavigationAllHeight+_moreView.height;
    }
    else
    {
        _moreView.hidden=true;
        self.height=kScreenWidth*4/5+W(44);
        self.fSelectHeight= kNavigationAllHeight;
    }
   
}
- (void)setPercentage
{
    [super setPercentage];
    _explainBtn.top=self.height-44-(_moreView.hidden?0:_moreView.height)-65+65*self.fPercentageY;
}
- (UIButton *)explainBtn
{
    if (_explainBtn) {
        return _explainBtn;
    }
    _explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _explainBtn.frame=CGRectMake(kScreenWidth-172/2, self.height-44-65, 172/2, 44);
    [_explainBtn setImage:[UIImage imageNamed:@"gameRule"] forState:UIControlStateNormal];
    [_explainBtn addTarget:self action:@selector(clickExpainBtn) forControlEvents:UIControlEventTouchUpInside];
    return _explainBtn;
}
- (UIImageView *)imageVMain
{
    if (!_imageVMain) {
        _imageVMain=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*4/5)];
        _imageVMain.backgroundColor = [UIColor colorWithWhite:236/255.0 alpha:1];
        _imageVMain.image=[UIImage imageNamed:@"defaultImage"];
    }
    return _imageVMain;
}
@end
