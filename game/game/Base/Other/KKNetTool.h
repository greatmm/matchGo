//
//  KKNetTool.h
//  game
//
//  Created by GKK on 2018/8/15.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKNetTool : NSObject

#pragma mark - 登录，验证码，用户信息
+(void)getCaptchaSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取校验码
+(void)getLoginVcodeWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取登录验证码
+(void)loginWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//登录
+(void)logoutSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//退出登录
#pragma mark - 个人
+(void)getAccountSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取个人账户信息
//+(void)updateAccountWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//更新个人账户信息
+(void)uploadAvatarWithImg:(UIImage *)img SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//更新头像
//+(void)getAddressesSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取个人地址列表
//+(void)addAddressWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//增加地址
//+(void)updateAddressWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock addressId:(NSNumber *)addressId;//更新地址
//+(void)deleteAddressSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock addressId:(NSNumber *)addressId;//删除一个地址
+(void)getMyWalletSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取我的账号余额
#pragma mark - 首页
+ (void)getGamesSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取首页游戏列表
+ (void)getHomeDataSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取首页其它数据
+ (void)getChoicesGamesWithGameid:(NSNumber *)gameID mId:(NSNumber *)mId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取匹配游戏
+(void)getBindAccountListWithGameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取某个游戏绑定的账号列表
+(void)getBindAccountListSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取所有游戏绑定的账号列表
+(void)getGameinfoWithGameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取游戏信息
+(void)bindGameWithPara:(NSDictionary *)para Gameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//绑定某个游戏
+(void)ensureBindGameWithPara:(NSDictionary *)para Gameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//确认绑定游戏，就是最终的绑定操作
//+(void)updateBindGameWithPara:(NSDictionary *)para Gameid:(NSNumber *)gameID bindId:(NSNumber *)bindId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//更新绑定某个游戏
//+(void)deleteBindGameWithGameid:(NSNumber *)gameID bindId:(NSNumber *)bindId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//删除绑定某个游戏
//+(void)getMessageListWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取通知消息列表
+(void)getRecordWithCurrency:(NSNumber *)currency para:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取金币，钻石，金币，提现，充值等记录
#pragma mark - webSocket
+(void)getWSListSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取websocket地址列表
#pragma mark - 匹配相关
//开始匹配
+(void)startMatchWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//确认匹配
+(void)ensureMatchWithUuid:(NSNumber *)uuid SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//取消匹配
+(void)cancelMatchWithSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
#pragma mark - 房间相关
//获取对战页数据
+(void)getMatchDatasuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//获取所有房间列表
+(void)getAllRoomsWithPara:(NSString *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//获取所有的比赛列表
+(void)getAllMatchesWithPara:(NSString *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//获取房间信息
+(void)getRoomInfoWithRoomId:(NSString *)roomId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//获取比赛信息
+(void)getMatchInfoWithMatchId:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//获取我的房间列表
+(void)getMyRoomsWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//创建房间
+(void)createRoomWithParm:(NSDictionary *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//加入房间
+(void)joinRoomWithMatchId:(NSNumber *)matchId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//加入密码房
//+(void)joinPrivateRoomWithPassword:(NSString *)password successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//加入房间新的接口
+(void)joinRoomWithCode:(NSString *)code successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//坐下(在房间内)
+(void)readyGameWithMatchId:(NSNumber *)matchId para:(NSDictionary *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//离开房间
+(void)leaveRoomWithMatchId:(NSNumber *)matchId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//我当前开始或者等待的房间
+(void)myStartRoomWithSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
#pragma mark - 锦标赛
+(void)getChampionInfoWithCid:(NSNumber *)cId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取锦标赛信息
+(void)getChampionMatchInfoWithMatchId:(NSNumber *)mId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取锦标赛比赛信息
+(void)beginChampionMatchWithCid:(NSNumber *)cId gamerId:(NSNumber *)gamerId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//开始锦标赛比赛
+(void)giveUpChampionWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//锦标赛放弃
+(void)reportChampionResultWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//上传锦标赛结果有接口
+(void)reportChampionResultWithMatchid:(NSNumber *)matchId imgs:(NSArray *)imgs SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
+(void)getMyChampionRoomsWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取我的锦标赛列表(所有的)
+(void)getMyChampionRoomsWithCid:(NSNumber *)cId Para:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取我的锦标赛列表(指定锦标赛)
+(void)getChampionTopUsersWithCid:(NSNumber *)cId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取锦标赛获奖排行
+(void)getLatestChampionsSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取锦标赛列表
+(void)championExchangeWithCid:(NSNumber *)cId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//锦标赛消耗入场券
#pragma mark - 结果相关
//认输
+(void)giveUpWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//上传战绩
+(void)reportResultWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
//上传战绩有图片
+(void)reportResultWithMatchid:(NSNumber *)matchId imgs:(NSArray *)imgs SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
#pragma mark - 创建充值订单
+(void)createPaymentOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
#pragma mark - 钻石兑换成金币
+(void)exchangeGlodWithDiamond:(NSNumber *)diamond SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
#pragma mark - 验证充值订单是否成功
+(void)verifyPaymentOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
#pragma mark - 检查更新数据
+(void)getUpdateVersionSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
+(void)postClearAliasSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
@end
