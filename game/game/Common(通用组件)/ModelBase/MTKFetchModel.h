//
//  MTKNetworkModel.h
//  game
//
//  Created by linsheng on 2018/12/20.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MTKFetchModelType) {
    MTKFetchModelTypeGET = 0,
    MTKFetchModelTypePOST,
    MTKFetchModelTypeForm,//暂时没支持
    MTKFetchModelTypePUT,//暂时没支持
    MTKFetchModelTypeDelete//暂时没支持
};
typedef void (^MTKCompletionBlock) (BOOL isSucceeded, NSString *msg,NSError * _Nullable error);
typedef void (^MTKCompletionWithModelData) (BOOL isSucceeded, NSString *msg, NSError * _Nullable error,id _Nullable responseObjectData);
@interface MTKFetchModel : MTKJsonModel
//结果是否正确
@property (nonatomic,assign) BOOL success;
//返回code
@property (nonatomic, assign) NSInteger code;
//返回错误信息
@property (nonatomic, copy) NSString *msg;
// 请求参数
@property (nonatomic, strong) NSDictionary *requestParams;
//是否请求中
@property (nonatomic, assign) BOOL boolRequesting;
// 请求接口
- (void)fetchWithPath:(NSString *)path type:(MTKFetchModelType )type completion:(MTKCompletionBlock)completeBlock;
//返回数据的接口
-(void)fetchWithPath:(NSString *)path type:(MTKFetchModelType )type completionWithData:(MTKCompletionWithModelData)completeBlock;
// 取消请求
- (void)cancelOperation;
// Option 子类覆盖此方法，提供不同URL请求地址,不覆盖提供默认的基本url
- (NSString *)baseURLString;

- (NSDictionary *)dealWithData:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
