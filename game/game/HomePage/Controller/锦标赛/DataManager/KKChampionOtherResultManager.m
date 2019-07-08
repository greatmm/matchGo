//
//  KKChampionOtherResultManager.m
//  game
//
//  Created by linsheng on 2019/1/16.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionOtherResultManager.h"
#import "KKChampionMoneyRankTableViewCell.h"
@implementation KKChampionOtherResultManager
- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId  model:(KKChampionTopModel *)model
{
    if (self=[super initWithCid:cid gameId:gameId type:KKChampionshipsTypeLadder]) {
        _model=[KKChampionTopModel new];
        //深拷贝 不影响原来数据
        [_model injectDataWithModel:model];
        _model.firstShow=true;
        _model.canLook=false;
        self.string_loadingUrl=[NSString stringWithFormat:@"champion/%@/winner/%ld",self.cid,(long)_model.uid];
    }
    return self;
}
- (void)checkWithResponse:(id)responseObjectData
{
    [super checkWithResponse:responseObjectData];
    [self.array_main insertObject:_model atIndex:0];
}
- (Class)getCellClassWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return [KKChampionMoneyRankTableViewCell class];
    }
    return self.classCell;
}
@end
