//
//  KKBZDoubleSliderView.m
//  game
//
//  Created by linsheng on 2018/12/25.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBZDoubleSliderView.h"
@interface KKBZDoubleSliderView ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIView *minSliderLine;
@property(nonatomic,strong) UIView *maxSliderLine;
@property(nonatomic,strong)  UIView *mainSliderLine;
@property(nonatomic,assign) CGFloat constOffY;

@property(nonatomic,assign) CGFloat total;
/**
 显示 min 滑块
 */
@property (nonatomic,strong)UIButton *minSlider;

/**
 显示 max 滑块
 */
@property (nonatomic,strong) UIButton * maxSlider;
/**
 显示较小的数btn
 */
@property (nonatomic,strong)UIButton *minBtn;
/**
 显示较大的数btn
 */
@property (nonatomic,strong)UIButton *maxBtn;
@end
#define btnW 28
@implementation KKBZDoubleSliderView
- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createViews];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self createViews];
}

- (void)createViews{
    //主进度条
    _mainSliderLine = [[UIView alloc]initWithFrame:CGRectMake(kLeftMargin + btnW * 0.5, 20 - 3, self.width - (kLeftMargin * 2 + btnW), 6)];
    _mainSliderLine.backgroundColor = kThemeColor;
    _mainSliderLine.layer.cornerRadius = 3;
    _mainSliderLine.layer.masksToBounds = YES;
    [self addSubview:_mainSliderLine];
    //最小值滑过的距离
    _minSliderLine = [[UIView alloc]initWithFrame:CGRectMake(_mainSliderLine.left, _mainSliderLine.top, 0, _mainSliderLine.height)];
    _minSliderLine.backgroundColor = [UIColor colorWithWhite:163/255.0 alpha:1];
    _minSliderLine.layer.cornerRadius = 3;
    _minSliderLine.layer.masksToBounds = YES;
    [self addSubview:_minSliderLine];
    //最小值滑块
    UIButton *minSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(kLeftMargin, 0, btnW, btnW)];
    minSliderButton.backgroundColor = [UIColor whiteColor];
    minSliderButton.showsTouchWhenHighlighted = YES;
    minSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    minSliderButton.layer.masksToBounds = YES;
    minSliderButton.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
    minSliderButton.layer.borderWidth = 1;
    minSliderButton.centerY = _mainSliderLine.centerY;
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [self addSubview:minSliderButton];
    _minSlider = minSliderButton;
    //显示当前值
    _minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_minBtn setBackgroundImage:[UIImage imageNamed:@"showValue"] forState:UIControlStateNormal];
    _minBtn.frame = CGRectMake(0, 0, 36, 29);
    _minBtn.centerX = _minSlider.centerX;
    _minBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    _minBtn.bottom = _minSlider.top - 5;
    _minBtn.hidden = YES;
    [self addSubview:_minBtn];
    //大滑块滑过的距离
    _maxSliderLine = [[UIView alloc]initWithFrame:CGRectMake(_mainSliderLine.right, _mainSliderLine.top, 0, _mainSliderLine.height)];
    _maxSliderLine.backgroundColor = [UIColor colorWithWhite:163/255.0 alpha:1];
    _maxSliderLine.layer.cornerRadius = 3;
    _maxSliderLine.layer.masksToBounds = YES;
    [self addSubview:_maxSliderLine];
    //大滑块
    UIButton *maxSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width - btnW - kLeftMargin,0, btnW, btnW)];
    maxSliderButton.backgroundColor = [UIColor whiteColor];
    maxSliderButton.showsTouchWhenHighlighted = YES;
    maxSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    maxSliderButton.layer.masksToBounds = YES;
    maxSliderButton.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
    maxSliderButton.layer.borderWidth = 1;
    maxSliderButton.centerY = _mainSliderLine.centerY;
    UIPanGestureRecognizer *maxSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxSliderButton:)];
    [maxSliderButton addGestureRecognizer:maxSliderButtonPanGestureRecognizer];
    [self addSubview:maxSliderButton];
    _maxSlider = maxSliderButton;
    //显示大滑块的数值
    _maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_maxBtn setBackgroundImage:[UIImage imageNamed:@"showValue"] forState:UIControlStateNormal];
    _maxBtn.frame = CGRectMake(0, 0, 36, 29);
    _maxBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    _maxBtn.centerX = _maxSlider.centerX;
    _maxBtn.bottom = _maxSlider.top - 5;
    [self addSubview:_maxBtn];
    _maxBtn.hidden = YES;
    _constOffY = _minSlider.centerY;
}
- (void)createShowLabel{
    CGFloat x = CGRectGetMinX(_mainSliderLine.frame);
    CGFloat w = _mainSliderLine.width/10;
    CGFloat y = CGRectGetMaxY(_minSlider.frame);
     CGFloat left = _mainSliderLine.width-x-w*2;
    
    for (int i = 0; i < 2; i ++) {
        UILabel * label = [self createOneLabel];
        label.frame = CGRectMake(i*left + x, y, w, 18);
        label.text = [NSString stringWithFormat:@"%d", i ];
        [self addSubview:label];
    }
}
- (UILabel *)createOneLabel{
    UILabel * label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)panMinSliderButton:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self];
    static CGPoint center;
    if (pgr.state == UIGestureRecognizerStateBegan) {
        center = pgr.view.center;
        _minBtn.hidden = NO;
        _minSlider.layer.borderColor = kThemeColor.CGColor;
    } else if (pgr.state == UIGestureRecognizerStateEnded){
        //滑动结束定位
        _minSlider.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
        _minBtn.hidden = YES;
        NSInteger a = _currentMin;
        _minSlider.centerX = _mainSliderLine.left + _mainSliderLine.width/[self getDistance] * a;
        _minBtn.centerX = _minSlider.centerX;
        _minSliderLine.width = _minSlider.centerX - _minSliderLine.left;
        return;
    }
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    //边界
    if (_minSlider.centerX < _minSliderLine.left) {
        _minSlider.centerX = _minSliderLine.left;
    } else if (_minSlider.centerX > _maxSlider.centerX){
        _minSlider.centerX = _maxSlider.centerX;
        [self bringSubviewToFront:_minSlider];
    }
    _minSliderLine.frame = CGRectMake(_minSliderLine.left, _minSliderLine.top,  pgr.view.centerX -_minSliderLine.left, _minSliderLine.height);
    [self valueMinChange:pgr.view.centerX];
}

- (void)panMaxSliderButton:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self];
    static CGPoint center;
    if (pgr.state == UIGestureRecognizerStateBegan) {
        center = pgr.view.center;
        _maxBtn.hidden = NO;
        _maxSlider.layer.borderColor = kThemeColor.CGColor;
    } else if(pgr.state == UIGestureRecognizerStateEnded){
        _maxBtn.hidden = YES;
        _maxSlider.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
        NSInteger a = _currentMax;
        _maxSlider.centerX = _mainSliderLine.left + _mainSliderLine.width/[self getDistance] * a;
        _maxBtn.centerX = _maxSlider.centerX;
        _maxSliderLine.left = _maxSlider.centerX;
        _maxSliderLine.width = _mainSliderLine.right - _maxSlider.centerX;
        return;
    }
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    if (pgr.view.centerX > _mainSliderLine.right) {
        pgr.view.centerX = _mainSliderLine.right;
    } else if (pgr.view.centerX < _minSlider.centerX) {
        _maxSlider.centerX = _minSlider.centerX;
        [self bringSubviewToFront:_maxSlider];
    }
    _maxSliderLine.left = _maxSlider.centerX;
    _maxSliderLine.width = _mainSliderLine.right - _maxSlider.centerX;
    [self valueMaxChange:pgr.view.centerX];
}

- (void)valueMinChange:(CGFloat)num
{
    _minBtn.centerX = _minSlider.centerX;
    NSInteger min = round((num - _mainSliderLine.left) * [self getDistance]/_mainSliderLine.width)+_minimumValue;
    
    NSInteger showValue=min;
    if (self.minValueChangeBlock) {
        showValue=self.minValueChangeBlock(min);
        
    }
    [self setValue:showValue button:_minBtn];
    self.currentMin = min;
}

- (void)valueMaxChange:(CGFloat)num
{
    _maxBtn.centerX = _maxSlider.centerX;
    NSInteger max = round((num - _mainSliderLine.left) * [self getDistance]/_mainSliderLine.width)+_minimumValue;//该定位到第几段
    NSInteger showValue=max;
    if (self.maxValueChangeBlock) {
        showValue=self.maxValueChangeBlock(max);
    }
    [self setValue:showValue button:_maxBtn];
    
    self.currentMax = max;
}
- (void)setValue:(NSInteger )value button:(UIButton *)button
{
    if (value>=1000) {
        button.titleLabel.font=[UIFont systemFontOfSize:12];
    }
    if (value>=100000) {
        button.titleLabel.font=[UIFont systemFontOfSize:9];
    }
     [button setTitle:[NSString stringWithFormat:@"%ld",(long)value] forState:UIControlStateNormal];
}
- (NSInteger)getDistance
{
    return _maximumValue-_minimumValue;
}

//-(void)setMinNum:(CGFloat)minNum
//{
//    _minNum = minNum;
//}
//
//-(void)setMaxNum:(CGFloat)maxNum
//{
//    _maxNum = maxNum;
//}
@end
