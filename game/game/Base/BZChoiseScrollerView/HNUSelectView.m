//
//  HNUSelectView.m
//  HeiNiu
//
//  Created by Wcy on 16/8/19.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import "HNUSelectView.h"
//#import "UIFont+FontStyle.h"
#import "KKButton.h"
#import "Masonry.h"
#define HNUSelectViewDefaultTop 8
@interface HNUSelectView()
@property (nonatomic, strong) NSMutableArray *arrayButtons;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *selectBgColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) NSArray *titleArr;
@end
@implementation HNUSelectView
- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor=selectColor;
    _lineView.backgroundColor=selectColor;
    for (UIButton *button in _arrayButtons) {
        [button setTitleColor:selectColor forState:UIControlStateSelected];
    }
}
- (void)addLineWithColor:(UIColor *)color
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, self.height, kScreenWidth, 0.5)];
    [self addSubview:view];
    view.backgroundColor=color;
}

- (void)resetWithTitle:(NSArray *)titleArr
{
    if (!_arrayButtons) {
        _arrayButtons=[@[] mutableCopy];
    }
    _titleArr = titleArr;
    NSInteger all=(_arrayButtons.count>titleArr.count)?_arrayButtons.count:titleArr.count;
    for ( int i =0; i<all; i++) {
        UIButton *button;
        if (i>=_arrayButtons.count) {
             button = [self createCustomItemButtonWithTitle:_titleArr[i]];
            [_arrayButtons addObject:button];
            button.tag=i;
        }
        else if(i>=_titleArr.count)
        {
            button=_arrayButtons[i];
            button.hidden=true;
        }
        
         [button setTitle:_titleArr[i] forState:UIControlStateNormal];
    }
    self.lineView;
    self.viewBG;
    [self addConstrain];
    [self selectIndex:0];

}
- (instancetype)initWithTitles:(NSArray *)titleArr titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor selectColor:(UIColor *)selcetColor
{
    if (self=[super init]) {
        _titleColor=titleColor;
        _selectColor=selcetColor;
        _bgColor=bgColor;
        
        [self resetWithTitle:titleArr];
        }
        return self;
}
- (instancetype)initWithTitles:(NSArray *)titleArr titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor selectColor:(UIColor *)selectColor selectBgColor:(UIColor *)selectBgColor
{
    if (self=[super init]) {
        _titleColor=titleColor;
        _selectColor=selectColor;
        _bgColor=bgColor;
        _selectBgColor = selectBgColor;
        [self resetWithTitle:titleArr];
    }
    return self;
}
- (instancetype)initWithTitles:(NSArray *)titleArr
{
    self = [super init];
    if (self=[self initWithTitles:titleArr titleColor:MTK16RGBCOLOR(0x101d37) bgColor:[UIColor whiteColor] selectColor:MTK16RGBCOLOR(0x29C29E)]) {
        [self resetWithTitle:titleArr];
    }
    return self;
}

- (void)addConstrain
{
    if (!_titleArr) {
        return;
    }
//    CGFloat width=W(104);//kScreenWidth/_titleArr.count;
//    CGFloat left=(kScreenWidth-W(104)*_titleArr.count)/2;
    CGFloat left=0;
    CGFloat width=kScreenWidth/_titleArr.count;
    for (int i=0;i<_titleArr.count;i++) {
        UIButton *button=_arrayButtons[i];
        button.frame=CGRectMake(width*i+left, 0, width, W(44));
    }
    
}

#pragma mark --- button Action
- (void)handleItemButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        return;
    }
    for (UIButton *button in _arrayButtons) {
        button.selected=false;
    }
    _index=btn.tag;
    btn.selected = YES;
    _lineView.left=btn.left+(btn.width-_lineView.width)/2;
    if (_delegate && [_delegate respondsToSelector:@selector(hnuSelectViewDidselectIndex:)]) {
        [_delegate hnuSelectViewDidselectIndex:btn.tag];
    }
}

- (void)selectIndex:(NSInteger)index
{
    _index=index;
    UIButton *btn;
    for (int i=0;i<_arrayButtons.count;i++) {
        UIButton *button=_arrayButtons[i];
        if (i==index) {
            btn=button;
        }
        button.selected=false;
    }
    btn.selected = YES;
    _lineView.left=btn.left+(btn.width-_lineView.width)/2;
}
- (void)chooseButtonSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        return;
    }
    [self handleItemButton:btn];
}

#pragma mark --- UI ---

- (UIButton *)createCustomItemButtonWithTitle:(NSString *)title {
    KKButton * targetButton = [[KKButton alloc] init];
   
    [targetButton setTitle:title forState:UIControlStateNormal];
    targetButton.titleLabel.font = [UIFont systemFontOfSize:W(15.f)];

    if (_selectColor) {
         [targetButton setTitleColor:_selectColor forState:UIControlStateSelected];
//        targetButton.backgroundColor = _bgColor;
        [targetButton setTitleColor:_titleColor forState:UIControlStateNormal];
//        [targetButton setTitleColor:_selectColor forState:UIControlStateSelected];
        
    }
    else
    {
//        targetButton.backgroundColor = MTKRGBCOLOR(38, 39, 50);
        [targetButton setTitleColor:MTKRGBCOLOR(118,120,121) forState:UIControlStateNormal];
        [targetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    if (_bgColor) {
        [targetButton setBackgroundImage:[UIImage imageWithColor:_bgColor] forState:UIControlStateNormal];
    }
    if (_selectBgColor) {
        [targetButton setBackgroundImage:[UIImage imageWithColor:_selectBgColor] forState:UIControlStateSelected];
    }
    targetButton.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [targetButton addTarget:self action:@selector(handleItemButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:targetButton];
    return targetButton;
}
- (void) setPoinr:(float)point
{
    _viewBG.top=-(2*HNUSelectViewDefaultTop+(kNavStatusBarHeight-HNUSelectViewDefaultTop)*point);
    _viewBG.height=W(44)-_viewBG.top+HNUSelectViewDefaultTop;
    _viewBG.layer.cornerRadius=10*(1-point);
}
- (UIView *)viewBG
{
    if (!_viewBG) {
        _viewBG=[[UIView alloc] initWithFrame:CGRectMake(0, -HNUSelectViewDefaultTop, kScreenWidth, W(44))];
        _viewBG.layer.cornerRadius=10;
        _viewBG.clipsToBounds=true;
        _viewBG.backgroundColor=[UIColor whiteColor];
        [self insertSubview:_viewBG atIndex:0];
        
    }
    return _viewBG;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, W(44)-3, 56, 3)];
        if (_selectColor) {
            _lineView.backgroundColor = _selectColor;
        }
        else  _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (void)kSetSelectBarBgColor:(UIColor *)color {
    for (UIButton *button in _arrayButtons) {
        [button setBackgroundColor:color];
    }
}



@end
