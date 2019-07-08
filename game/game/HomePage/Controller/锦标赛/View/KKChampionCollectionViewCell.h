//
//  KKChampionCollectionViewCell.h
//  game
//
//  Created by greatkk on 2018/12/27.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKChampionListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionCollectionViewCell : UICollectionViewCell
@property (assign,nonatomic) BOOL isBig;//首页还是锦标赛列表页，默认是首页NO，YES表示是锦标赛列表页
-(void)assignWithItem:(KKChampionListModel*)item;
@end

NS_ASSUME_NONNULL_END
