//
//  KKHouseTool.h
//  game
//
//  Created by greatkk on 2018/12/28.
//  Copyright © 2018 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKHouseTool : NSObject
+(void)enterChampionWihtCid:(NSNumber *)cId;//根据锦标赛id进入锦标赛
+(void)enterChampionWihtChamDic:(NSDictionary *)championDic;//根据锦标赛数据进入比赛(进行中的比赛)
+(void)enterPwdroomWithPwd:(NSString *)pwd;//根据密码房密码，进入房间
+(void)enterRoomWithRoomid:(NSNumber *)roomId popToRootVC:(BOOL)popToRootVC;//根据房间号进入房间
+ (void)enterBigHouseWithDic:(NSDictionary *)dic popToRootVC:(BOOL)popToRootVC;//有数据直接进入房间，比如：创建房间之后直接就有了数据
@end

NS_ASSUME_NONNULL_END
