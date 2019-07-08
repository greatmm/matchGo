//
//  KKSingleSlider.m
//  game
//
//  Created by GKK on 2018/10/17.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKSingleSlider.h"
#import "UIView+Dimension.h"

@interface KKSingleSlider ()
/**
 设置最小值
 */
@property (nonatomic,assign)CGFloat minNum;

/**
 显示较小的数btn
 */
@property (nonatomic,strong)UIButton *minBtn;

/**
 显示 min 滑块
 */
@property (nonatomic,strong)UIButton *minSlider;

@property (nonatomic,assign) BOOL layout;
@property (nonatomic,assign) NSInteger maxNum;
@end
static const CGFloat sliderOffY = 0.0f;
@implementation KKSingleSlider
{
    UIView *_minSliderLine;
    UIView *_mainSliderLine;
    CGFloat _constOffY;
    CGFloat _total;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.minNum = 20;
    self.maxNum = 200;
    self.currentMin = 200;
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
    //整个条
    _mainSliderLine = [[UIView alloc]initWithFrame:CGRectMake(10,sliderOffY + 20 - 3, ScreenWidth - 40, 6)];
    _mainSliderLine.backgroundColor = [UIColor colorWithWhite:163/255.0 alpha:1];
    _mainSliderLine.layer.cornerRadius = 3;
    _mainSliderLine.layer.masksToBounds = YES;
    [self addSubview:_mainSliderLine];
    //显示滑过的条
    _minSliderLine = [[UIView alloc]initWithFrame:CGRectMake(10, _mainSliderLine.top, 0, _mainSliderLine.height)];
    _minSliderLine.backgroundColor = kThemeColor;
    _minSliderLine.layer.cornerRadius = 3;
    _minSliderLine.layer.masksToBounds = YES;
    [self addSubview:_minSliderLine];
    //滑动按钮
    UIButton *minSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(0,sliderOffY + 10, 20, 20)];
    minSliderButton.backgroundColor = [UIColor whiteColor];
    minSliderButton.showsTouchWhenHighlighted = YES;
    minSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    minSliderButton.layer.masksToBounds = YES;
    minSliderButton.layer.borderColor = [UIColor colorWithWhite:163/255.0 alpha:1].CGColor;
    minSliderButton.layer.borderWidth = 1;
    minSliderButton.centerX = _mainSliderLine.width;
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [self addSubview:minSliderButton];
    _minSlider = minSliderButton;
    _minSliderLine.frame = CGRectMake(_minSliderLine.left, _minSliderLine.top,  _minSlider.centerX-_minSliderLine.left, _minSliderLine.height);
    //显示当前值
    _minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_minBtn setBackgroundImage:[UIImage imageNamed:@"showValue"] forState:UIControlStateNormal];
    _minBtn.frame = CGRectMake(0, 0, 36, 29);
    _minBtn.centerX = _minSlider.centerX;
    _minBtn.bottom = _minSlider.top - 5;
    _minBtn.hidden = YES;
    [self addSubview:_minBtn];
    [self createShowLabel];
}
//显示下边的标度，根据数据来计算
- (void)createShowLabel{
    CGFloat x = CGRectGetMinX(_mainSliderLine.frame);
    CGFloat w = _mainSliderLine.width/9;
    CGFloat y = CGRectGetMaxY(_minSlider.frame);
    for (int i = 0; i < 10; i ++) {
        UILabel * label = [self createOneLabel];
        label.frame = CGRectMake((i - 0.5)*w + x, y, w, 18);
        label.text = [NSString stringWithFormat:@"%d",20 * (i + 1)];
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
    pgr.view.centerY = _mainSliderLine.centerY;
    if (pgr.view.centerX < 10) {
        pgr.view.centerX = 10;
    }
    if (pgr.view.centerX > self.width-10) {
        pgr.view.centerX = self.width-10;
    }
    _minSliderLine.frame = CGRectMake(_minSliderLine.left, _minSliderLine.top,  pgr.view.centerX-_minSliderLine.left, _minSliderLine.height);
    [self valueMinChange:pgr.view.centerX];
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

@end
