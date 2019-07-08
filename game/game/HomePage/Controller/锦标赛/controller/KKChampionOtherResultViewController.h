//
//  KKChampionOtherResultViewController.h
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKBaseViewController.h"
#import "KKChampionResultViewController.h"
#import "KKChampionTopModel.h"
#import "KKChampionshipsMatchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChampionOtherResultViewController : KKChampionResultViewController
- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId model:(KKChampionTopModel *)model champion:(KKChampionshipsModel *)champion;
@end

NS_ASSUME_NONNULL_END
