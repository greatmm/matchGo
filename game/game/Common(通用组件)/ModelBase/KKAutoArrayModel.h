//
//  KKAutoArrayModel.h
//  game
//
//  Created by linsheng on 2018/12/26.
//  Copyright © 2018年 MM. All rights reserved.
// 自动解析控件

#import "MTKFetchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKAutoArrayModel : MTKFetchModel
//model名字
@property (nonatomic, assign) Class modelName;
//key
@property (nonatomic, strong) NSString *dictKey;
//输出数组
@property (nonatomic, strong) NSMutableArray *arrayOutput;

- (id)initWithKey:(NSString *)key bid:(Class )className;

@end

NS_ASSUME_NONNULL_END
