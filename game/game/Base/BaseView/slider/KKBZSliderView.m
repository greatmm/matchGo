//
//  KKSilderView.m
//  game
//
//  Created by linsheng on 2018/12/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBZSliderView.h"
#import "KKBZDoubleSliderView.h"
#import "KKBZSingelSilderView.h"
@interface KKBZSliderView()
//滑动控件
@property (nonatomic, strong) KKBZSingelSilderView *sliderMain;
//滑动控件
@property (nonatomic, strong) KKBZDoubleSliderView *doubleSliderMain;
//滑动数据
@property (nonatomic, strong) NSArray <KKBZGoldModel >*data;


@end
@implementation KKBZSliderView

- (id)init
{
    if (self=[super init]) {
        [self addSubview:self.sliderMain];
        [self setConstraints];
    }
    return self;
}

- (void)awakeFromNib
{
    if (_boolDoubleTwoWay) {
         [self addSubview:self.doubleSliderMain];
    }
    else
    {
        [self addSubview:self.sliderMain];
        [self setConstraints];
    }
    
    [super awakeFromNib];
}
#pragma mark set/get
- (UISlider *)sliderMain
{
    if (!_sliderMain) {
        _sliderMain=[[KKBZSingelSilderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _sliderMain.minimumTrackTintColor = kThemeColor;
        _sliderMain.minimumValue=0;
//        [_sliderMain addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        hnuSetWeakSelf;
        _sliderMain.valueChangeBlock = ^(NSInteger value)
        {
            [weakSelf sliderValueChanged:weakSelf.sliderMain];
        };
//
    }
    return _sliderMain;
}
- (KKBZDoubleSliderView *)doubleSliderMain
{
    if (!_doubleSliderMain) {
        _doubleSliderMain=[[KKBZDoubleSliderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        hnuSetWeakSelf;
        _doubleSliderMain.maximumValue=200;
        _doubleSliderMain.minimumValue=0;
        _doubleSliderMain.minValueChangeBlock=^NSInteger(NSInteger minValue)
        {
            [weakSelf setMinValue:minValue];
            return weakSelf.currentMin;
        };
        _doubleSliderMain.maxValueChangeBlock =^NSInteger(NSInteger maxValue)
        {
            [weakSelf setMaxValue:maxValue];
            return weakSelf.currentMax;
        };
    }
    return _doubleSliderMain;
}
#pragma mark Method
- (void)setMaxValue:(NSInteger)value
{
    NSInteger tmpGold =[self getGoldWithValue:value];
    if (tmpGold>=0&&self.silderValueChange) {
        self.currentMax=tmpGold;
        self.silderValueChange(tmpGold);
    }
}
- (void)setMinValue:(NSInteger)value
{
    NSInteger tmpGold =[self getGoldWithValue:value];
    if (tmpGold>=0&&self.silderValueChange) {
        self.currentMin=tmpGold;
        self.silderValueChange(tmpGold);
    }
}
- (void)setConstraints
{
     hnuSetWeakSelf;
    [self.sliderMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.equalTo(weakSelf);
        make.width.equalTo(weakSelf).offset(-20);
        
        
    }];
}
//更新slider
- (void)sliderValueChanged:(UISlider *)slider
{
    [self setMinValue:slider.value];
    self.currentMax=self.currentMin;
}
- (NSInteger)getGoldWithValue:(float)value
{
    NSUInteger tmpValue = (NSInteger)roundf(value);
    for (int i=0;i<_data.count;i++) {
        KKBZGoldModel *model=_data[i];
        if (tmpValue>=model.minPoints&&tmpValue<=model.maxPoints) {
            NSInteger tmpGold=model.min+model.value*(tmpValue-model.minPoints);
            
            
            return tmpGold;
        }
    }
    return -1;
}
- (void)resetWithData:(NSArray <KKBZGoldModel>*)data
{
    if (!data||data.count<1) {
        return;
    }
    NSInteger points=0;
    //判断2次是不是一样
    if (_data&&_data.count) {
        KKBZGoldModel *oldModel=_data.lastObject;
        KKBZGoldModel *newModel=data.lastObject;
        if (oldModel.max==newModel.max) {
            return;
        }
    }
    
    //排序
    _data=[data sortedArrayUsingComparator:^NSComparisonResult(KKBZGoldModel *obj1, KKBZGoldModel *obj2)
     {
         if (obj2.max<obj1.max) {
             return NSOrderedDescending;
         }
         return NSOrderedAscending;
     }];
   //计算总点数
    for (int i=0;i<_data.count;i++) {
        KKBZGoldModel *model=_data[i];
        model.minPoints=points;
        points+=(model.max-model.min)/model.value;
        model.maxPoints=points;
    }
    if (_boolDoubleTwoWay) {
        _doubleSliderMain.maximumValue=points;
        _doubleSliderMain.minimumValue=1;
        _doubleSliderMain.currentMax=(int)(points/2);
        _doubleSliderMain.currentMin=1;
        [self setMinValue:1];
        [self setMaxValue:points];
    }
    else
    {
        _sliderMain.maximumValue=points;
        _sliderMain.minimumValue=1;
        _sliderMain.value=(int)(points/2);
        [self sliderValueChanged:_sliderMain];
    }
    
}
@end
