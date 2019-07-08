//
//  KKChampionRewardManager.m
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionRewardManager.h"
#import "KKChampionRewardTableViewCell.h"
@implementation KKChampionRewardManager
//- (void)checkWithResponse:(id)responseObjectData
//{
//    if ([HNUBZUtil checkArrEnable:responseObjectData]) {
//        self.array_main=responseObjectData;
//    }
//}
- (void)setDataWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    KKChampionRewardTableViewCell *asd=cell;
    asd.index=indexPath.row+1;
    [super setDataWithCell:cell indexPath:indexPath];
}
@end
