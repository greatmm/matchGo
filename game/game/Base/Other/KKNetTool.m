//
//  KKNetTool.m
//  game
//
//  Created by GKK on 2018/8/15.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKNetTool.h"
#import <AFNetworking.h>
#import "Appdelegate.h"
#import "HNUPushManager.h"
@implementation KKNetTool
#pragma mark Regid
+(void)postClearAliasSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@push/clear",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - 检查版本更新
+(void)getUpdateVersionSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@versions/ios_update",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - 结果相关
+(void)verifyPaymentOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@payment/apple/verify",baseUrl] para:parm headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)exchangeGlodWithDiamond:(NSNumber *)diamond SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@account/exchange",baseUrl] para:@{@"diamond":diamond} headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)createPaymentOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@payment/order",baseUrl] para:parm headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)giveUpWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@match/%@/giveup",baseUrl,matchId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)reportResultWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@match/%@/hurry",baseUrl,matchId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)reportResultWithMatchid:(NSNumber *)matchId imgs:(NSArray *)imgs SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self postImagesWithUrl:[NSString stringWithFormat:@"%@match/%@/report",baseUrl,matchId] para:nil imgS:imgs name:@"report[]" SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - 房间相关
+(void)getMatchInfoWithMatchId:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@matches/%@",baseUrl,matchId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getRoomInfoWithRoomId:(NSString *)roomId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@rooms/%@",baseUrl,roomId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getMatchDatasuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@setting/match",baseUrl] para:nil headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getAllMatchesWithPara:(NSString *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
{
    NSString * url;
    if (para) {
        url = [NSString stringWithFormat:@"%@matches?%@",baseUrl,para];
    } else {
        url = [NSString stringWithFormat:@"%@matches",baseUrl];
    }
    [self get:url para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getAllRoomsWithPara:(NSString *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
{
    NSString * url;
    if (para) {
        url = [NSString stringWithFormat:@"%@rooms?%@",baseUrl,para];
    } else {
        url = [NSString stringWithFormat:@"%@rooms",baseUrl];
    }
    [self get:url para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getMyRoomsWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@match/list",baseUrl] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)createRoomWithParm:(NSDictionary *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@room",baseUrl] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)joinRoomWithMatchId:(NSNumber *)matchId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@room/%@/join",baseUrl,matchId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)joinPrivateRoomWithPassword:(NSString *)password successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@match/joinprivate/%@",baseUrl,password] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)joinRoomWithCode:(NSString *)code successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@room/joincode/%@",baseUrl,code] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)readyGameWithMatchId:(NSNumber *)matchId para:(NSDictionary *)para successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@room/%@/ready",baseUrl,matchId] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)leaveRoomWithMatchId:(NSNumber *)matchId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@room/%@/left",baseUrl,matchId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)myStartRoomWithSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@match/stat",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - 锦标赛
+(void)getChampionInfoWithCid:(NSNumber *)cId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@champion/%@",baseUrl,cId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getChampionMatchInfoWithMatchId:(NSNumber *)mId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@champion/match/%@",baseUrl,mId] para:nil headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)beginChampionMatchWithCid:(NSNumber *)cId gamerId:(NSNumber *)gamerId successBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    id pDic = @{@"version":[KKDataTool appVersion],@"device":@2,@"gamerid":gamerId};
    [manager.requestSerializer setValue:@"esports_tycoon_iOS" forHTTPHeaderField:@"User-Agent"];
    if ([KKDataTool token]) {
        [manager.requestSerializer setValue:[KKDataTool token]  forHTTPHeaderField:@"F-Token"];
    }
    [manager POST:[NSString stringWithFormat:@"%@champion/%@/match",baseUrl,cId] parameters:pDic constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *data= [NSJSONSerialization dataWithJSONObject:pDic options:NSJSONWritingPrettyPrinted error:nil];
        [formData appendPartWithHeaders:nil body:data];
    } progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSDictionary * dic = [r allHeaderFields];
            if (dic[@"F-Token"]) {
                [KKDataTool saveToken:dic[@"F-Token"]];
            }
        }
        NSDictionary * dict = (NSDictionary *)responseObject;
        if (successBlock) {
            successBlock(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"失败：%@",error);
        if (errorBlock) {
            errorBlock(error);
        }
    }];
//    [self post:[NSString stringWithFormat:@"%@champion/%@/match",baseUrl,cId] para:@{@"gamerid":gamerId} headerPara:YES SuccessBlock:^(NSDictionary *dic) {
//        if (successBlock) {
//            successBlock(dic);
//        }
//    } erreorBlock:^(NSError *error) {
//        if (errorBlock) {
//            errorBlock(error);
//        }
//    } progressBlock:nil];
}
+(void)giveUpChampionWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@champion/match/%@/giveup",baseUrl,matchId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)reportChampionResultWithMatchid:(NSNumber *)matchId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@champion/match/%@/hurry",baseUrl,matchId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)reportChampionResultWithMatchid:(NSNumber *)matchId imgs:(NSArray *)imgs SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self postImagesWithUrl:[NSString stringWithFormat:@"%@champion/match/%@/report",baseUrl,matchId] para:nil imgS:imgs name:@"report[]" SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getMyChampionRoomsWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@champion/summaries",baseUrl] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getMyChampionRoomsWithCid:(NSNumber *)cId Para:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@champion/%@/match/list",baseUrl,cId] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getChampionTopUsersWithCid:(NSNumber *)cId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@champion/%@/top",baseUrl,cId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getLatestChampionsSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@champions/latest",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)championExchangeWithCid:(NSNumber *)cId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@champion/%@/exchange",baseUrl,cId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - 首页
+ (void)getGamesSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock{
    [self get:[NSString stringWithFormat:@"%@%@",baseUrl,gamesUrl] para:nil headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHomeDataSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@setting/home",baseUrl] para:nil headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getChoicesGamesWithGameid:(NSNumber *)gameID mId:(NSNumber *)mId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@choices/game/%@/matchtype/%@",baseUrl,gameID,mId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getGameinfoWithGameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@%@%@",baseUrl,gameUrl,gameID] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getBindAccountListWithGameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@%@%@/bind",baseUrl,gameUrl,gameID] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getBindAccountListSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@game/bind",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)bindGameWithPara:(NSDictionary *)para Gameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    id pDic;
    if (para) {
        pDic = para.mutableCopy;
        pDic[@"version"] = [KKDataTool appVersion];
        if (![para.allKeys containsObject:@"device"]) {
            pDic[@"device"] = @2;
        }
    } else {
        pDic = @{@"version":[KKDataTool appVersion],@"device":@2};
    }
    [manager.requestSerializer setValue:@"esports_tycoon_iOS" forHTTPHeaderField:@"User-Agent"];
    DLOG(@"请求的参数：%@",pDic);
    DLOG(@"请求的Url:%@",[NSString stringWithFormat:@"%@game/%@/bind",baseUrl,gameID]);
    //bz 2018-12-25 token
    if ([KKDataTool token]) {
        [manager.requestSerializer setValue:[KKDataTool token]  forHTTPHeaderField:@"F-Token"];
    }
    [manager POST:[NSString stringWithFormat:@"%@game/%@/bind",baseUrl,gameID] parameters:pDic constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *data= [NSJSONSerialization dataWithJSONObject:pDic options:NSJSONWritingPrettyPrinted error:nil];
        [formData appendPartWithHeaders:nil body:data];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        DLOG(@"请求的结果：%@",responseObject);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSDictionary * dic = [r allHeaderFields];
            //            NSLog(@"headers == %@",dic);
            if (dic[@"F-Token"]) {
                [KKDataTool saveToken:dic[@"F-Token"]];
            }
        }
        NSDictionary * dict = (NSDictionary *)responseObject;
        if (successBlock) {
            successBlock(dict);
        }
        NSNumber * code = dict[@"c"];
        if (code.integerValue == 0) {
            [[HNUPushManager sharePushManager] jPushSetTags];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"失败：%@",error);
        if (errorBlock) {
            errorBlock(error);
        }
        //        NSLog(@"错误码%ld",(long)error.code);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == -1001 || error.code == -1005 || error.code == -1009) {
                [KKAlert showText:@"网络连接异常"];
            } else if(error.code == -1003 || error.code == -1004 || error.code == -1011) {
                [KKAlert showText:@"连接服务器失败"];
            } else {
                [KKAlert showText:@"获取数据失败"];
            }
        });
    }];
//    [self post:[NSString stringWithFormat:@"%@game/%@/bind",baseUrl,gameID] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
//        if (successBlock) {
//
//            successBlock(dic);
//            [[HNUPushManager sharePushManager] jPushSetTags];
//        }
//    } erreorBlock:^(NSError *error) {
//        if (errorBlock) {
//            errorBlock(error);
//        }
//    } progressBlock:nil];
}
+(void)ensureBindGameWithPara:(NSDictionary *)para Gameid:(NSNumber *)gameID SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@game/%@/confirmbind",baseUrl,gameID] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)updateBindGameWithPara:(NSDictionary *)para Gameid:(NSNumber *)gameID bindId:(NSNumber *)bindId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@game/%@/bind/%@",baseUrl,gameID,bindId] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
         [[HNUPushManager sharePushManager] jPushSetTags];
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)deleteBindGameWithGameid:(NSNumber *)gameID bindId:(NSNumber *)bindId SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@game/%@/bind/%@/del",baseUrl,gameID,bindId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
         [[HNUPushManager sharePushManager] jPushSetTags];
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getMessageListWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@account/messages",baseUrl] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getRecordWithCurrency:(NSNumber *)currency para:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@account/trading/%@",baseUrl,currency] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - ws
+(void)getWSListSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@%@",baseUrl,wsUrl] para:nil headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - 匹配相关
+(void)startMatchWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@match/pair",baseUrl] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)ensureMatchWithUuid:(NSNumber *)uuid SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@match/pair/%@",baseUrl,uuid] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)cancelMatchWithSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@match/pair/cancel",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

#pragma mark - 登录，验证码，用户信息
+(void)getCaptchaSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock{
    [self get:[NSString stringWithFormat:@"%@%@",baseUrl,captchaUrl] para:nil  headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getLoginVcodeWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock{
    NSString * url = [NSString stringWithFormat:@"%@%@",baseUrl,vCodeUrl];
    id pDic;
    if (para) {
        pDic = para.mutableCopy;
    } else {
        pDic = @{@"version":[KKDataTool appVersion],@"device":@2};
    }
    [self post:url para:pDic headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)loginWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,loginUrl] para:para headerPara:NO SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)logoutSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@logout",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getAccountSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@%@",baseUrl,accountUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)updateAccountWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,accountUrl] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+(void)getAddressesSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@%@",baseUrl,addressesUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)addAddressWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,addAddressUrl] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)updateAddressWithPara:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock addressId:(NSNumber *)addressId
{
    [self post:[NSString stringWithFormat:@"%@%@/%@",baseUrl,addAddressUrl,addressId] para:para headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)deleteAddressSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock addressId:(NSNumber *)addressId
{
    [self post:[NSString stringWithFormat:@"%@%@/%@/del",baseUrl,addAddressUrl,addressId] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)getMyWalletSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self get:[NSString stringWithFormat:@"%@account/wallet",baseUrl] para:nil headerPara:YES SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)uploadAvatarWithImg:(UIImage *)img SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self postImageWithUrl:[NSString stringWithFormat:@"%@%@",baseUrl,avatarUrl] para:nil img:img name:@"avatar" fileName:@"avatar.png" SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
#pragma mark - 基础请求类
//上传多张图片
+(void)postImagesWithUrl:(NSString *)url para:(NSDictionary *)para imgS:(NSArray *)imgs name:(NSString *)name SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock progressBlock:(void (^)(NSProgress * _Nonnull uploadProgress))progressBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    [manager.requestSerializer setValue:@"esports_tycoon_iOS" forHTTPHeaderField:@"User-Agent"];
    if ([KKDataTool token]) {
        [manager.requestSerializer setValue:[KKDataTool token]  forHTTPHeaderField:@"F-Token"];
    }
    [manager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSInteger count = imgs.count;
        for (int i = 0; i < count; i ++) {
            UIImage * image = imgs[i];
            NSData *data = [self scaleImage:image toKb:800.0];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@%d.jpg", dateString,i];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD showProgress:uploadProgress.completedUnitCount * 1.0/uploadProgress.totalUnitCount];
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//        NSLog(@"上传成功");
//        NSLog(@"%@",responseObject);
        NSDictionary * dict = (NSDictionary *)responseObject;
        NSNumber * code = dict[@"c"];
        if (code.integerValue == 0) {
            if (successBlock) {
                successBlock(dict[@"d"]);
            }
        } else {
            NSString * m = dict[@"m"];
            if (errorBlock) {
                errorBlock((NSError *)m);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"上传失败%@",error);
        if (errorBlock) {
            errorBlock(error);
        }
//        NSLog(@"错误码%ld",error.code);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == -1001 || error.code == -1005 || error.code == -1009) {
                [KKAlert showText:@"网络连接异常"];
            } else if(error.code == -1003 || error.code == -1004 || error.code == -1011) {
                [KKAlert showText:@"连接服务器失败"];
            } else {
                [KKAlert showText:@"获取数据失败"];
            }
        });
    }];
}
//上传一张图片
+(void)postImageWithUrl:(NSString *)url para:(NSDictionary *)para img:(UIImage *)img name:(NSString *)name fileName:(NSString *)fileName SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock progressBlock:(void (^)(NSProgress * _Nonnull uploadProgress))progressBlock
{
//    NSLog(@"%@ -- 参数：%@--img:%@",url,para,img);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    if ([KKDataTool token]) {
        [manager.requestSerializer setValue:[KKDataTool token]  forHTTPHeaderField:@"F-Token"];
    }
    [manager.requestSerializer setValue:@"esports_tycoon_iOS" forHTTPHeaderField:@"User-Agent"];
    [manager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *data = [self scaleImage:img toKb:800];
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary * dict = (NSDictionary *)responseObject;
        NSNumber * code = dict[@"c"];
        if (code.integerValue == 0) {
            if (successBlock) {
                successBlock(dict[@"d"]);
            }
        } else {
            NSString * m = dict[@"m"];
            if (errorBlock) {
                errorBlock((NSError *)m);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"上传失败%@",error);
        if (errorBlock) {
            errorBlock(error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"错误码%ld",error.code);
            if (error.code == -1001 || error.code == -1005 || error.code == -1009) {
                [KKAlert showText:@"网络连接异常"];
            } else if(error.code == -1003 || error.code == -1004 || error.code == -1011) {
                [KKAlert showText:@"连接服务器失败"];
            } else {
                [KKAlert showText:@"上传失败"];
            }
        });
    }];
}
+ (void)get:(NSString *)url para:(NSDictionary *)para headerPara:(BOOL)headerPara SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock progressBlock:(void (^)(NSProgress * _Nonnull uploadProgress))progressBlock
{
    id pDic;
    if (para) {
        pDic = para.mutableCopy;
        pDic[@"version"] = [KKDataTool appVersion];
        pDic[@"device"] = @2;
    } else {
        pDic = @{@"version":[KKDataTool appVersion],@"device":@2};
    }
//    url=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer setValue:@"esports_tycoon_iOS" forHTTPHeaderField:@"User-Agent"];
//    if (headerPara) {
        NSString * token = [KKDataTool token];
    //bz 2018-12-25 token
        if (token) {
            [manager.requestSerializer setValue:token  forHTTPHeaderField:@"F-Token"];
        }
//    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    DLOG(@"请求的url==%@",url);
    DLOG(@"请求的参数==%@",pDic);
    [manager GET:url parameters:pDic progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLOG(@"请求的结果%@",responseObject);
        NSDictionary * dict = (NSDictionary *)responseObject;
        NSNumber * code = dict[@"c"];
        if (code == nil) {
            //请求版本更新时没有code
            successBlock(dict);
            return;
        }
        if (code.integerValue == 0) {
            if (successBlock) {
                successBlock(dict[@"d"]);
            }
        } else {
            NSString * m = dict[@"m"];
            if (errorBlock) {
                errorBlock((NSError *)m);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([m isEqualToString:@"未登录"]) {
                    if ([KKDataTool token]) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:KKLogoutNotification object:nil];
                    } else {
                        [KKDataTool showLoginVc];
                    }
                } else if(!([m containsString:@"不足"] || [m isEqualToString:@"有比赛中的房间"])){
                    [KKAlert showText:m];
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
//        NSLog(@"错误码%ld",error.code);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == -1001 || error.code == -1005 || error.code == -1009) {
                [KKAlert showText:@"网络连接异常"];
            } else if(error.code == -1003 || error.code == -1004 || error.code == -1011) {
                [KKAlert showText:@"连接服务器失败"];
            } else {
                [KKAlert showText:@"获取数据失败"];
            }
        });
//        NSLog(@"%@",error);
    }];
}
+ (void)post:(NSString *)url para:(NSDictionary *)para headerPara:(BOOL)headerPara SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock progressBlock:(void (^)(NSProgress * _Nonnull uploadProgress))progressBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    id pDic;
    if (para) {
        pDic = para.mutableCopy;
        pDic[@"version"] = [KKDataTool appVersion];
        if (![para.allKeys containsObject:@"device"]) {
            pDic[@"device"] = @2;
        }
    } else {
        pDic = @{@"version":[KKDataTool appVersion],@"device":@2};
    }
    [manager.requestSerializer setValue:@"esports_tycoon_iOS" forHTTPHeaderField:@"User-Agent"];
    DLOG(@"请求的url：%@",url);
    DLOG(@"请求的参数：%@",pDic);
//    if (headerPara) {
    //bz 2018-12-25 token
        if ([KKDataTool token]) {
             [manager.requestSerializer setValue:[KKDataTool token]  forHTTPHeaderField:@"F-Token"];
        }
       
//    }
    [manager POST:url parameters:pDic constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *data= [NSJSONSerialization dataWithJSONObject:pDic options:NSJSONWritingPrettyPrinted error:nil];
        [formData appendPartWithHeaders:nil body:data];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        DLOG(@"请求的结果：%@",responseObject);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSDictionary * dic = [r allHeaderFields];
//            NSLog(@"headers == %@",dic);
            if (dic[@"F-Token"]) {
                [KKDataTool saveToken:dic[@"F-Token"]];
            }
        }
        NSDictionary * dict = (NSDictionary *)responseObject;
        NSNumber * code = dict[@"c"];
        if (code.integerValue == 0) {
            if (successBlock) {
                successBlock(dict[@"d"]);
            }
        } else {
            NSString * m = dict[@"m"];
            if (errorBlock) {
                errorBlock((NSError *)m);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([m isEqualToString:@"未登录"]) {
                    if ([KKDataTool token]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KKLogoutNotification object:nil];
                    } else {
                        [KKDataTool showLoginVc];
                    }
                } else if(!([m containsString:@"不足"] || [url containsString:@"bind"] || [m isEqualToString:@"有比赛中的房间"])){
                    [KKAlert showText:m];
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败：%@",error);
        if (errorBlock) {
            errorBlock(error);
        }
//        NSLog(@"错误码%ld",(long)error.code);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == -1001 || error.code == -1005 || error.code == -1009) {
                [KKAlert showText:@"网络连接异常"];
            } else if(error.code == -1003 || error.code == -1004 || error.code == -1011) {
                [KKAlert showText:@"连接服务器失败"];
            } else {
                [KKAlert showText:@"获取数据失败"];
            }
        });
    }];
}

+(NSData *)scaleImage:(UIImage *)img toKb:(NSInteger)maxLength{
    NSInteger maxKb = maxLength * 1024;
    CGFloat compression = 1.0f;
    CGFloat minCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(img, compression);
    while ([imageData length] > maxKb && compression > minCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(img, compression);
    }
    return imageData;
}
@end
