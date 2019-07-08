//
//  KKChampionOtherResultManager.h
//  game
//
//  Created by linsheng on 2019/1/16.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionResultManager.h"
#import "KKChampionTopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionOtherResultManager : KKChampionResultManager
@property (nonatomic, strong) KKChampionTopModel * model;
- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId  model:(KKChampionTopModel *)model;
@end

NS_ASSUME_NONNULL_END
