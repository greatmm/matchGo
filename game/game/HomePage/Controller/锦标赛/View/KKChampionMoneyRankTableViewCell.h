//
//  KKChampionMoneyRankTableViewCell.h
//  game
//
//  Created by greatkk on 2018/11/6.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChampionMoneyRankTableViewCell : KKBaseTableViewCell
@property (assign,nonatomic) NSInteger rank;

-(void)assignWithDic:(NSDictionary *)dic;
- (void)setShowLines:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
