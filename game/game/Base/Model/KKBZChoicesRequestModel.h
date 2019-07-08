//
//  KKBZChoicesRequestModel.h
//  game
//
//  Created by linsheng on 2018/12/24.
//  Copyright © 2018年 MM. All rights reserved.
//


#import "KKBZGoldModel.h"
#import "KKBZChoiceTypes.h"
#import "KKBZChoicesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKBZChoicesRequestModel : MTKFetchModel
@property (nonatomic, strong)NSArray <KKBZGoldModel >*gold;
@property (nonatomic, strong)NSArray <KKBZChoicesModel >*choices;
@property (nonatomic, strong)NSArray <KKBZChoiceTypes >*choicetypes;

@end

NS_ASSUME_NONNULL_END
