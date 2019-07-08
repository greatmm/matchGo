//
//  MTKNetworkModel.m
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKFetchModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "MTKRequestFetchModelPool.h"
@interface MTKFetchModel ()
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic) NSURLSessionDataTask *sessionTask;
@end
@implementation MTKFetchModel
#pragma mark set/get
-(AFHTTPSessionManager *)sessionManager
{
    static NSString *host;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        host = baseUrl;
    });
    
    if (self.baseURLString.length && ![self.baseURLString isEqualToString:host]) {
        NSURL *baseURL = [NSURL URLWithString:[self baseURLString]];
        _sessionManager= [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _sessionManager.requestSerializer.timeoutInterval = 15;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
        return _sessionManager;
    }
    static AFHTTPSessionManager *manager;
    if (!manager) {
        NSURL *baseURL = [NSURL URLWithString:host];
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.requestSerializer.timeoutInterval = 15;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    }
    return manager;
}
- (NSString *)baseURLString
{
    return nil;
}
- (NSString *)getMessageWithError:(NSError *)error
{
    if (error.code == -1001 || error.code == -1005 || error.code == -1009) {
        return @"网络连接异常";
    } else if(error.code == -1003 || error.code == -1004 || error.code == -1011) {
        return  @"连接服务器失败";
    }
    return error.domain;
}
#pragma mark Method

- (void)setupFetchReqHeader
{
    [self.sessionManager.requestSerializer setValue:@"esports_tycoon_iOS" forHTTPHeaderField:@"User-Agent"];
    NSString *token=[KKDataTool token];
    if ([HNUBZUtil checkStrEnable:token]) {
        [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"F-Token"];
    }
}
- (NSDictionary *)setupFetchReqPrams
{
//    NSString *deviceID = [OpenUDID value];
    NSString *version = [KKDataTool appVersion];
    NSMutableDictionary *reqPrams = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"2", @"device", version ?: @"", @"version", nil];//deviceID ?: @"",@"device",
    [reqPrams addEntriesFromDictionary:_requestParams];
    return reqPrams;
}
- (void)getWithPath:(NSString *)path completion:(MTKCompletionWithModelData)completeBlock
{
    [self setupFetchReqHeader];
    hnuSetWeakSelf;
    self.sessionTask=[self.sessionManager
                      GET:path
                      parameters:[self setupFetchReqPrams]
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                      }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          [weakSelf sessionSuccess:task response:responseObject completeBlock:completeBlock];
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if (completeBlock) {
                              completeBlock(false,[weakSelf getMessageWithError:error],error,nil);
                          }
                          [[MTKRequestFetchModelPool sharedRequestPool] releaseRequestModel:weakSelf];
                      }];
}
- (void)postWithPath:(NSString *)path completion:(MTKCompletionWithModelData)completeBlock
{
    [self setupFetchReqHeader];
    hnuSetWeakSelf;
    self.sessionTask=[self.sessionManager
                      POST:path
                      parameters:[self setupFetchReqPrams]
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                      }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          [weakSelf sessionSuccess:task response:responseObject completeBlock:completeBlock];
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                          weakSelf.success=false;
                          if (completeBlock) {
                              completeBlock(false,[weakSelf getMessageWithError:error],error,nil);
                          }
                          [[MTKRequestFetchModelPool sharedRequestPool] releaseRequestModel:weakSelf];
                      }];
}
- (void)fetchWithPath:(NSString *)path  type:(MTKFetchModelType )type completion:(MTKCompletionBlock)completeBlock
{
    [self fetchWithPath:path type:type completionWithData:^(BOOL isSucceeded, NSString *msg, NSError *error,id responseObjectData)
     {
         completeBlock(isSucceeded,msg,error);
     }];
}
-(void)fetchWithPath:(NSString *)path  type:(MTKFetchModelType )type completionWithData:(MTKCompletionWithModelData)completeBlock
{
    self.success=false;
     [[MTKRequestFetchModelPool sharedRequestPool] retainRequetModel:self];
    switch (type) {
            case MTKFetchModelTypeGET:
        {
            [self getWithPath:path completion:completeBlock];
        }
            break;
        default:
        {
            [self postWithPath:path completion:completeBlock];
        }
            break;
    }
}
//处理成功数据
- (void)sessionSuccess:(NSURLSessionDataTask *)task response:(id )responseObject completeBlock:(MTKCompletionWithModelData)completeBlock
{
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        //设置token
        NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
        NSDictionary * dic = [r allHeaderFields];
        if (dic[@"F-Token"]) {
            [KKDataTool saveToken:dic[@"F-Token"]];
        }
    }
    NSDictionary * dict = (NSDictionary *)responseObject;
    if ([HNUBZUtil checkDictEnable:dict]) {
        NSNumber * code = dict[@"c"];
        self.code=code.integerValue;
        if (self.code == 0) {
            self.success=true;
            [self injectJSONData:[self dealWithData:dict[@"d"]]];
            if (completeBlock) {
                completeBlock(true,@"",nil,dict[@"d"]);
            }
        } else {
            NSString *msg = dict[@"m"];
            self.msg=msg;
            if (completeBlock) {
                completeBlock(false,self.msg,[NSError errorWithDomain:self.msg code:self.code userInfo:nil],responseObject);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([HNUBZUtil checkEqualFirst:msg second:@"未登录"]) {
                    if ([KKDataTool token]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KKLogoutNotification object:nil];
                    } else {
                        [KKDataTool showLoginVc];
                    }
                }
            });
        }
    }
    else
    {
        completeBlock(false,@"数据格式错误",nil,responseObject);
    }
    [[MTKRequestFetchModelPool sharedRequestPool] releaseRequestModel:self];
}
- (NSDictionary *)dealWithData:(NSDictionary *)dictionary
{
    return dictionary;
}
#pragma mark clean
- (void)dealloc{
    [_sessionTask cancel];
}

-(void)cancelOperation
{
    [_sessionTask cancel];
}
@end
