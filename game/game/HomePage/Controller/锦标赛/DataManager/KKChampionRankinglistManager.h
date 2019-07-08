//
//  KKChampionRankinglistManager.h
//  game
//
//  Created by linsheng on 2019/1/14.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKBZBasicDataManager.h"
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionRankinglistManager : KKBZBasicDataManager
@property (nonatomic, strong) NSNumber * cId;
@property (nonatomic, assign) KKChampionshipsType type;
@property (nonatomic, strong) KKChampionshipsModel *modelChampions;
- (id)initWithType:(KKChampionshipsType)type cid:(NSNumber *)cid;
@end

NS_ASSUME_NONNULL_END
