//
//  HNUResultHeadView.m
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "HNUResultHeadView.h"
@interface HNUResultHeadView()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelAmount;
@end
@implementation HNUResultHeadView
- (id)init
{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, kScreenWidth, H(56+16));
        [self nbBZLazyInitialization];
        [self addLineWithTop:0];
        [self addLineWithTop:H(56+8)];
    }
    return self;
}
#pragma mark set/get
- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle=[[UILabel alloc] initWithText:@"累计得分" color:MTK16RGBCOLOR(0x101D37) fontSize:H(16) forFrame:CGRectMake(16, H(8), 100, H(56))];
    }
    return _labelTitle;
}
- (UILabel *)labelAmount
{
    if (!_labelAmount) {
        _labelAmount=[[UILabel alloc] initWithText:@"" color:MTK16RGBCOLOR(0x101D37) fontSize:H(16) forFrame:CGRectMake(kScreenWidth-16-100, H(8), 100, H(56))];
        _labelAmount.textAlignment=NSTextAlignmentRight;
    }
    return _labelAmount;
}
- (void)setType:(KKChampionshipsType)type value:(NSString *)value
{
    _labelAmount.text=value;
    switch (type) {
        case KKChampionshipsTypeRating:
        {
            _labelTitle.text=@"胜利次数";
        }
            break;
        default:
        {
             _labelTitle.text=@"累计得分";
        }
            break;
    }
}
@end
