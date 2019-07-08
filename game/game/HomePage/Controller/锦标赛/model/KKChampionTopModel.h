//
//  KKChampionTopModel.h
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "MTKJsonModel.h"
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionTopModel : MTKJsonModel
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger win;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger award;
//2019-1-16
@property (nonatomic, assign) float total_value;
//拓展属性 排行榜 阶梯需要使用
@property (nonatomic, assign) NSInteger rank;
//是不是首个
@property (nonatomic, assign) BOOL firstShow;
//是否可以查看战绩
@property (nonatomic, assign) BOOL canLook;
//类型
@property (nonatomic, assign) KKChampionshipsType type;

@end

NS_ASSUME_NONNULL_END
