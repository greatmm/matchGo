//
//  KKChampionLadderPriceView.m
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionLadderPriceView.h"
@interface KKChampionLadderPriceView()
@property (nonatomic, strong) UIImageView *imageVIcon;
@property (nonatomic, strong) UILabel *labelTitle;
//@property (nonatomic, strong) NSMutableArray *arrayTimes;
@property (nonatomic, strong) NSMutableArray *arrayImages;
@end
@implementation KKChampionLadderPriceView

- (id)init
{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 240, kScreenWidth, H(48));
        _arrayImages=[@[] mutableCopy];
        [self nbBZLazyInitialization];
    }
    return self;
}
- (void)setTicketModel:(KKChampionshipsMyTicketsModel *)model
{
    [self setWithFirst:model.first Rebuy:model.rebuy Used:model.used Buy:model.buy];
}
- (void)setWithFirst:(NSInteger)first Rebuy:(NSInteger)rebuy Used:(NSInteger)used Buy:(NSInteger)buy
{
    float a=kScreenWidth-(18+5)*(first+rebuy)-rebuy*5-13;
    NSInteger all=(_arrayImages.count>(first+rebuy))?_arrayImages.count:(first+rebuy);
    for (NSInteger i=0; i<all; i++) {
        KKChampionLadderPriceType type;
        if (i<used) {
            type=KKChampionLadderPriceTypeUsed;
        }
        else if(i<buy)
        {
            type=KKChampionLadderPriceTypeUnlock;
            
        }
        else
        {
            //加条分割线
            type=KKChampionLadderPriceTypeLocked;
        }
        if (i>=first) {
            a+=5;
        }
        UIImageView *imagev=nil;
        if (i>=_arrayImages.count) {
            imagev=[self getImageVWithType:type left:a];
            [self addSubview:imagev];
            [_arrayImages addObject:imagev];
            if (i>=first) {
                [self addLineWithView:imagev];
            }
            a+=18+5;
            continue;
        }
        else if(i>=(first+rebuy))
        {
            imagev=_arrayImages[i];
            imagev.hidden=true;
            continue;
        }
        imagev=_arrayImages[i];
        imagev.image=[self getImageWithType:type];
        imagev.hidden=false;
        imagev.left=a;
        a+=18+5;
        
    }
    _labelTitle.text=[NSString stringWithFormat:@"挑战机会  %ld",buy-used];
}
#pragma mark set/get
- (void)addLineWithView:(UIView *)view
{
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(-5, (view.height-14)/2, 0.5, 14)];
    line.backgroundColor=MTK16RGBCOLOR(0xDEDEDE);
    [view addSubview:line];
}
- (UIImageView *)imageVIcon
{
    if (!_imageVIcon) {
        _imageVIcon=[self getImageVWithType:KKChampionLadderPriceTypeUsed left:16];
    }
    return _imageVIcon;
}
- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle=[[UILabel alloc] initWithText:@"挑战机会  3" color:MTK16RGBCOLOR(0x101D37) fontSize:H(15) forFrame:CGRectMake(40, 0, 100, H(48))];
    }
    return _labelTitle;
}
- (UIImageView *)getImageVWithType:(KKChampionLadderPriceType)type left:(CGFloat)left
{
    UIImageView *imageVIcon=[[UIImageView alloc] initWithFrame:CGRectMake(left, (H(48)-18)/2, 18,18)];
    imageVIcon.image=[self getImageWithType:type];
    return imageVIcon;
    
}
- (UIImage *)getImageWithType:(KKChampionLadderPriceType)type
{
    NSString *name=[NSString stringWithFormat:@"ticket%ld",type];
    return MTKImageNamed(name);
}
@end
