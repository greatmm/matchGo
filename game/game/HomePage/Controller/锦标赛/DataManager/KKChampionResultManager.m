//
//  KKChampionResultManager.m
//  game
//
//  Created by linsheng on 2019/1/14.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionResultManager.h"
#import "KKChampionMyResultTableViewCell.h"
@implementation KKChampionResultManager
- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId type:(KKChampionshipsType )type
{
    if (self=[super initWithUrl:[NSString stringWithFormat:@"champion/%@/match/list",cid] model:[KKChampionshipsMatchModel class] cell:[KKChampionMyResultTableViewCell class]]) {
        self.cid=cid;
        self.gameId=gameId;
        self.type=type;
        self.modelForLoading.dictKey=@"matches";
    }
    return self;
}
- (void)checkWithResponse:(id)responseObjectData
{
    [super checkWithResponse:responseObjectData];
    if (responseObjectData[@"champion"]) {
        _modelChampions=[[KKChampionshipsModel alloc] initWithJSONDict:responseObjectData[@"champion"]];
    }
    
}
- (void)setDataWithCell:(KKChampionMyResultTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[KKChampionMyResultTableViewCell class]]) {
        cell.gameId=_gameId.integerValue;
        cell.type=_type;
        cell.choice=_modelChampions.choice;
    }
    [super setDataWithCell:cell indexPath:indexPath];
}
#pragma mark set/get
- (NSString *)getHeadInfo
{
    switch (_type) {
        case KKChampionshipsTypeLadder:
        {
            //计算累计得分
            float a=0;
            for (KKChampionshipsMatchModel *model in self.array_main) {
                if ([model isKindOfClass:[KKChampionshipsMatchModel class]]) {
                    float value=model.value.floatValue;
                    //当且仅当数据大于0的时候有效
                    if (value>0) {
                         a+=value;
                    }
                   
                }
            }
            return [NSString stringWithFormat:@"%0.1f",a];
        }
            break;
        case KKChampionshipsTypeRating:
        {
            //计算累计胜场
             NSInteger a=0;
            for (KKChampionshipsMatchModel *model in self.array_main) {
                if ([model isKindOfClass:[KKChampionshipsMatchModel class]]) {
                    if (model.result==1) {
                        a+=1;
                    }
                }
            }
            return [NSString stringWithFormat:@"%ld次",a];
        }
            break;
        default:
            break;
    }
    return @"";
}
@end
