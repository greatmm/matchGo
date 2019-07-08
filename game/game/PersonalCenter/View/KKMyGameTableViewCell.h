//
//  KKMyGameTableViewCell.h
//  game
//
//  Created by GKK on 2018/8/21.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"
#import "KKRoomItem.h"
#import "KKChampionSummaryModel.h"
@interface KKMyGameTableViewCell : KKBaseTableViewCell
@property (nonatomic,assign) NSInteger type;
-(void)assignWithItem:(KKRoomItem *)item;//自建房，匹配
-(void)assignWithModel:(KKChampionSummaryModel *)model;//锦标赛
@end
