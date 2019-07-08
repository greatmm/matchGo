//
//  KKHintTool.h
//  game
//
//  Created by greatkk on 2018/12/5.
//  Copyright © 2018 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKHintTool : NSObject
+(void)showResultHintWithDic:(NSDictionary *)resultDic;//显示匹配和自建房的比赛结果
+(void)showChampionMatchBegin:(NSDictionary *)beginDic;//锦标赛开始
+(void)showChampionMatchEnd:(NSDictionary *)endDic;//锦标赛结算结束
+(void)dismiss;
@end

NS_ASSUME_NONNULL_END
