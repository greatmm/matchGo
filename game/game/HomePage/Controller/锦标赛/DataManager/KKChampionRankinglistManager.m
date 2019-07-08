//
//  KKChampionRankinglistManager.m
//  game
//
//  Created by linsheng on 2019/1/14.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionRankinglistManager.h"
#import "KKChampionMoneyRankTableViewCell.h"
#import "KKChampionTopModel.h"
@implementation KKChampionRankinglistManager
- (id)initWithType:(KKChampionshipsType)type cid:(NSNumber *)cid
{
    if (self=[super initWithUrl:[NSString stringWithFormat:@"champion/%@/top",cid] model:[KKChampionTopModel class] cell:[KKChampionMoneyRankTableViewCell class]]) {
        _cId=cid;
        _type=type;
//        self.modelForLoading.dictKey=@"top";
        self.int_pageNumber=0;
    }
    return self;
}
- (void)checkWithResponse:(id)responseObjectData
{
    [super checkWithResponse:responseObjectData];
    if (responseObjectData[@"champion"]) {
        _modelChampions=[[KKChampionshipsModel alloc] initWithJSONDict:responseObjectData[@"champion"]];
    }
    KKChampionTopModel *tmpModel=nil;
    NSNumber * userId = [KKDataTool user].userId;
    for (int i=0;i<self.array_main.count;i++) {
        KKChampionTopModel *model=self.array_main[i];
        model.type=_type;
        if (userId.integerValue==model.uid) {
            if (model.firstShow) {
                tmpModel=nil;
                break;
            }
            if (_type==KKChampionshipsTypeRating) {
                model.rank=i+1;
            }
            tmpModel=[KKChampionTopModel new];
            [tmpModel injectDataWithModel:model];
            tmpModel.firstShow=true;
        }
        else model.canLook=true;
        if (_type==KKChampionshipsTypeRating) {
            model.rank=i+1;
            model.canLook=false;
        }
    }
    if (tmpModel) {
        [self.array_main insertObject:tmpModel atIndex:0];
    }
}
//- (void)setDataWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
//{
////    if (self.mineDic) {
////        if (indexPath.row == 0) {
////            cell.rank = self.rank;
////            [cell setShowLines:true];
////            [cell assignWithDic:self.mineDic];
////        } else {
////            cell.rank = indexPath.row ;
////            [cell setShowLines:false];
////            [cell assignWithDic:self.topArr[indexPath.row - 1]];
////        }
////    } else {
////        cell.rank = indexPath.row+1;
////        [cell setShowLines:false];
////        [cell assignWithDic:self.topArr[indexPath.row]];
////
////    }
//}
@end
