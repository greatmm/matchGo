//
//  KKStepView.m
//  game
//
//  Created by greatkk on 2018/11/22.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKStepView.h"


@interface KKStepView ()
@property (assign,nonatomic) NSInteger steps;//总共有几步
@property (strong,nonatomic) NSMutableArray * imgArr;//img数组
@property (strong,nonatomic) NSMutableArray * labelArr;//上边的标题label数组
@property (strong,nonatomic) UIProgressView * progressView;//进度条
@end
@implementation KKStepView

-(void)setTitleArr:(NSArray *)titleArr
{
    if (_titleArr == titleArr) {
        return;
    }
    _titleArr = titleArr;
    self.steps = _titleArr.count;
    [self createSubviews];
}
-(void)setCurrentStep:(NSInteger)currentStep
{
//    if (_currentStep == currentStep) {
//        return;
//    }
    _currentStep = currentStep;
    UILabel * l = self.labelArr[_currentStep];
    l.textColor = kThemeColor;
    l.font = [UIFont boldSystemFontOfSize:12];
    UIImageView * imgView = self.imgArr[_currentStep];
    imgView.image = [UIImage imageNamed:@"state1"];
    for (int i = 0; i < _currentStep; i ++) {
        UILabel * label = self.labelArr[i];
        label.textColor = kTitleColor;
        label.font = [UIFont systemFontOfSize:11];
        UIImageView * imgView = self.imgArr[i];
        imgView.image = [UIImage imageNamed:@"state2"];
    }
    for (NSInteger i = _currentStep + 1; i < self.steps; i ++) {
        UILabel * label = self.labelArr[i];
        label.textColor = kTitleColor;
        label.font = [UIFont systemFontOfSize:11];
        UIImageView * imgView = self.imgArr[i];
        imgView.image = [UIImage imageNamed:@"state0"];
    }
    self.progressView.progress = 1.0/(self.steps - 1) * _currentStep;
    if (_currentStep == self.steps - 1) {
        UIImageView * imgView = self.imgArr.lastObject;
        imgView.image = [UIImage imageNamed:@"state2"];
    }
}
-(void)createSubviews
{
    NSInteger count = self.titleArr.count;
    if (count < 2) {
        return;
    }
    self.progressView = [UIProgressView new];
    self.progressView.progress = 0;
    self.progressView.progressTintColor = kThemeColor;
    self.progressView.trackTintColor = [UIColor colorWithRed:206/255.0 green:209/255.0 blue:214/255.0 alpha:1];
    [self addSubview:self.progressView];
    self.imgArr = [NSMutableArray new];
    self.labelArr = [NSMutableArray new];
    for (NSInteger i = 0; i < count; i ++) {
        UILabel * l = [UILabel new];
        l.font = [UIFont systemFontOfSize:11];
        l.textColor = [UIColor colorWithWhite:119/255.0 alpha:1];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = self.titleArr[i];
        [self addSubview:l];
        [self.labelArr addObject:l];
        UIImageView * imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:@"state0"];
        [self.imgArr addObject:imgView];
        [self addSubview:imgView];
        if (i - 1 >= 0) {
            if (i == count - 1) {
                UILabel * label = self.labelArr[count - 2];
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(label);
                    make.width.mas_equalTo(label);
                    make.right.mas_equalTo(self);
                    make.left.mas_equalTo(label.mas_right);
                    make.height.mas_equalTo(17);
                }];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(l);
                    make.centerY.mas_equalTo(self.progressView);
                }];
            } else {
               UILabel * label = self.labelArr[i - 1];
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(label.mas_right);
                    make.top.mas_equalTo(label.mas_top);
                    make.width.mas_equalTo(label);
                    make.height.mas_equalTo(17);
                }];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(l);
                    make.centerY.mas_equalTo(self.progressView);
//                    make.size.mas_equalTo(CGSizeMake(15, 15));
                }];
            }
        } else {
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(10);
                make.left.mas_equalTo(self);
                make.height.mas_equalTo(17);
            }];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(l);
                make.centerY.mas_equalTo(self.progressView);
//                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
    }
    UIImageView * firstImg = self.imgArr.firstObject;
//    firstImg.image = [UIImage imageNamed:@"state1"];
    UIImageView * lastImg = self.imgArr.lastObject;
    UILabel * l = self.labelArr.firstObject;
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstImg.mas_centerX);
        make.right.mas_equalTo(lastImg.mas_centerX);
        make.top.mas_equalTo(l.mas_bottom).offset(10);
        make.height.mas_equalTo(3);
    }];
}
@end
