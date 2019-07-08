//
//  KKChoiceCollectionViewCell.m
//  game
//
//  Created by greatkk on 2018/10/30.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChoiceCollectionViewCell.h"

@implementation KKChoiceCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.choiceBtn];
        [self.choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(5);
            make.top.mas_equalTo(self).offset(5);
        }];
    }
    return self;
}
-(KKSelectButton *)choiceBtn
{
    if (_choiceBtn) {
        return _choiceBtn;
    }
    _choiceBtn = [KKSelectButton buttonWithType:UIButtonTypeCustom];
    [_choiceBtn configurateTitleUi];
    [_choiceBtn setSelected:NO];
    _choiceBtn.userInteractionEnabled = NO;
    return _choiceBtn;
}
@end
