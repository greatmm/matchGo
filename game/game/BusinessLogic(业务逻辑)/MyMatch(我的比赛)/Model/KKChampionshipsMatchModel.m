//
//  KKChampionshipsMatchModel.m
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKChampionshipsMatchModel.h"
@implementation KKChampionshipsMyTicketsModel
@end
@implementation KKChampionshipsModel
#pragma mark Super
+ (NSDictionary *)mtkJsonModelKeyMapper
{
    return @{@"id":@"cid"};
}
- (void)injectJSONData:(NSDictionary *)jsonData
{
    [super injectJSONData:jsonData];
    self.ticketsModel.first=_freetickets>0?_freetickets:_times;
    self.ticketsModel.rebuy=_rebuytimes;
    if (self.ticketsModel.costin) {
        self.ticketsModel.used=0;
        self.ticketsModel.buy=0;
    }
    else
    {
        self.ticketsModel.buy=self.ticketsModel.first+(_rebuytimes-self.ticketsModel.rebuytimes);
        self.ticketsModel.used=self.ticketsModel.buy-self.ticketsModel.times;
    }
    
}
- (NSDictionary *)dealWithData:(NSDictionary *)dictionary
{
    self.ticketsModel=[[KKChampionshipsMyTicketsModel alloc] initWithJSONDict:dictionary];
    if ([HNUBZUtil checkDictEnable:dictionary]) {
        return dictionary[@"champion"];
    }
    return dictionary;
}
#pragma mark set/get
- (NSInteger)getCountDownTime
{
    return 0;
}
- (KKMatchStatus )getMatchStatus
{
    //需要检索当前所有比赛 正在比赛中的状态 绝对没有room类型
    return KKSmallHouseStatusNone;
}
- (void)setType:(KKChampionshipsType)type
{
    self.exChampionColor=MTK16RGBCOLOR(0x29C29E);
    _type=type;
//    switch (type) {
//        case KKChampionshipsTypeRating:
//            {
//                self.exChampionName=@"平分锦标赛";
//                
//            }
//            break;
//        case KKChampionshipsTypeLadder:
//        {
//            self.exChampionName=self.name;
//        }
//            break;
//        default:
//            break;
//    }
}
- (NSString *)exChampionName
{
    if (_type==KKChampionshipsTypeRating) {
        return @"平分锦标赛";
    }
    return self.name;
}
- (UIColor *)getTimeShowColor
{
    NSInteger now = [[KKDataTool shareTools] getDateStamp];
    NSInteger startTimeout = (self.starttime.integerValue - now);//距离比赛开始的时间
    if (startTimeout > 0) {
        return MTK16RGBCOLOR(0xBFBFBF);
    }
    return _exChampionColor;
}
//- (NSString *)exChampionName
//{
//    switch (_type) {
//        case KKChampionshipsTypeRating:
//            return  @"平分锦标赛";
//            break;
//        case KKChampionshipsTypeLadder:
//            return  @"阶梯锦标赛";
//            break;
//        default:
//        {
//            return @"";
//        }
//            break;
//    }
//}
#pragma mark request
- (void)getChampionWithData:(MTKCompletionWithModelData)completeBlock
{
    [self fetchWithPath:[NSString stringWithFormat:@"champion/%@",_cid] type:MTKFetchModelTypeGET completionWithData:completeBlock];
}
@end
@implementation KKChampionshipsMatchModel

+ (NSDictionary *)mtkJsonModelKeyMapper
{
    return @{@"id":@"cmid"};
}

@end
