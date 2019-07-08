//
//  KKChampionResultManager.h
//  game
//
//  Created by linsheng on 2019/1/14.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKBZBasicDataManager.h"
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionResultManager : KKBZBasicDataManager
@property (nonatomic, strong) NSNumber * gameId;
@property (nonatomic, strong) NSNumber * cid;
@property (nonatomic, assign) KKChampionshipsType type;
@property (nonatomic, strong) KKChampionshipsModel *modelChampions;
- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId type:(KKChampionshipsType )type;
- (NSString *)getHeadInfo;
@end

NS_ASSUME_NONNULL_END
