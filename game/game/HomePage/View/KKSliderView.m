//
//  KKSliderView.m
//  game
//
//  Created by GKK on 2018/8/14.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSliderView.h"
#import "UIView+Dimension.h"
static const CGFloat sliderOffY = 20.0f;
@implementation KKSliderView
{
    UIView *_minSliderLine;
    UIView *_maxSliderLine;
    UIView *_mainSliderLine;
    CGFloat _constOffY;
    CGFloat _total;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.currentMax = 200;
    self.currentMin = 20;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self createViews];
}
- (void)createViews{
    if (self.layout) {
        return;
    }
    self.layout = YES;
    self.minNum = 20;
    self.maxNum = 200;
    //主进度条
    _mainSliderLine = [[UIView alloc]initWithFrame:CGRectMake(26,sliderOffY + 20 - 3, self.width - 52, 6)];
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
    UIButton *minSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(kLeftMargin,sliderOffY + 10, 20, 20)];
    minSliderButton.backgroundColor = [UIColor whiteColor];
    minSliderButton.showsTouchWhenHighlighted = YES;
    minSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    minSliderButton.layer.masksToBounds = YES;
    minSliderButton.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
    minSliderButton.layer.borderWidth = 1;
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [self addSubview:minSliderButton];
    _minSlider = minSliderButton;
    //显示当前值
    _minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_minBtn setBackgroundImage:[UIImage imageNamed:@"showValue"] forState:UIControlStateNormal];
    _minBtn.frame = CGRectMake(0, 0, 36, 29);
    _minBtn.centerX = _minSlider.centerX;
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
        UIButton *maxSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 20 - kLeftMargin, sliderOffY + 10, 20, 20)];
        maxSliderButton.backgroundColor = [UIColor whiteColor];
        maxSliderButton.showsTouchWhenHighlighted = YES;
        maxSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
        maxSliderButton.layer.masksToBounds = YES;
        maxSliderButton.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
        maxSliderButton.layer.borderWidth = 1;
        UIPanGestureRecognizer *maxSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxSliderButton:)];
        [maxSliderButton addGestureRecognizer:maxSliderButtonPanGestureRecognizer];
        [self addSubview:maxSliderButton];
        _maxSlider = maxSliderButton;
    //显示大滑块的数值
        _maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maxBtn setBackgroundImage:[UIImage imageNamed:@"showValue"] forState:UIControlStateNormal];
        _maxBtn.frame = CGRectMake(0, 0, 36, 29);
        _maxBtn.centerX = _maxSlider.centerX;
        _maxBtn.bottom = _maxSlider.top - 5;
        [self addSubview:_maxBtn];
        _maxBtn.hidden = YES;
    _constOffY = _minSlider.centerY;
    [self createShowLabel];
}
- (void)createShowLabel{
    CGFloat x = CGRectGetMinX(_mainSliderLine.frame);
    CGFloat w = _mainSliderLine.width/9;
    CGFloat y = CGRectGetMaxY(_minSlider.frame);
    for (int i = 0; i < 10; i ++) {
        UILabel * label = [self createOneLabel];
        label.frame = CGRectMake((i - 0.5)*w + x, y, w, 18);
        label.text = [NSString stringWithFormat:@"%d",20 * i + 20];
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
        _minSlider.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
        _minBtn.hidden = YES;
        NSInteger a = _minBtn.currentTitle.integerValue;
        a = a/20 - 1;
        _minSlider.centerX = _mainSliderLine.left + _mainSliderLine.width/9 * a;
        _minBtn.centerX = _minSlider.centerX;
        _minSliderLine.width = _minSlider.centerX - _minSliderLine.left;
        return;
    }
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    if (_minSlider.centerX <= 26) {
        _minSlider.centerX = 26;
    } else if (_minSlider.right >= _maxSlider.left){
        _minSlider.right = _maxSlider.left;
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
        NSInteger a = _maxBtn.currentTitle.integerValue;
        a = a/20 - 1;
        _maxSlider.centerX = _mainSliderLine.left + _mainSliderLine.width/9 * a;
        _maxBtn.centerX = _maxSlider.centerX;
        _maxSliderLine.left = _maxSlider.centerX;
        _maxSliderLine.width = _mainSliderLine.right - _maxSlider.centerX;
        return;
    }
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    if (pgr.view.centerX > _mainSliderLine.right) {
        pgr.view.centerX = _mainSliderLine.right;
    } else if (pgr.view.left <= _minSlider.right) {
        _maxSlider.left = _minSlider.right;
    }
    _maxSliderLine.left = _maxSlider.centerX;
    _maxSliderLine.width = _mainSliderLine.right - _maxSlider.centerX;
    [self valueMaxChange:pgr.view.centerX];
}

- (void)valueMinChange:(CGFloat)num
{
    _minBtn.centerX = _minSlider.centerX;
    NSInteger min = round((num - _mainSliderLine.left) * 9/_mainSliderLine.width);
    
    [_minBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(20 * min + 20)] forState:UIControlStateNormal];
    if (self.minValueChangeBlock) {
        self.minValueChangeBlock(20 * min + 20);
    }
    self.currentMin = 20 * min + 20;
}

- (void)valueMaxChange:(CGFloat)num
{
    _maxBtn.centerX = _maxSlider.centerX;
    NSInteger max = round((num - _mainSliderLine.left) * 9/_mainSliderLine.width);//该定位到第几段
    [_maxBtn setTitle:[NSString stringWithFormat:@"%ld",(long)(20 * max + 20)] forState:UIControlStateNormal];
    if (self.maxValueChangeBlock) {
        self.maxValueChangeBlock(20 * max + 20);
    }
    self.currentMax = 20 * max + 20;
}


-(void)setMinNum:(CGFloat)minNum
{
    _minNum = minNum;
}

-(void)setMaxNum:(CGFloat)maxNum
{
    _maxNum = maxNum;
}
@end
