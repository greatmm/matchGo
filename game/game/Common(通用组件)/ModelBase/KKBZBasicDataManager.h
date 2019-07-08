//
//  KKBZBasicDataManager.h
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTKFetchModel.h"
#import "KKAutoArrayModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^MTKManagerCompletionBlock) (BOOL isSucceeded, NSString *msg,NSError * error,BOOL end);
@interface KKBZBasicDataManager : NSObject<UITableViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *dictionary_loadingInfo;//请求的字段
@property (nonatomic, strong) KKAutoArrayModel *modelForLoading;
@property (nonatomic, strong) NSMutableArray *array_main;//主存储块
@property (nonatomic, strong) NSString *string_loadingUrl;//请求的地址
@property (nonatomic, assign) int int_pageNumber;
@property (nonatomic, assign) Class classModel,classCell;//对象

@property (nonatomic, copy)  MTKManagerCompletionBlock blockCompletion;

@property (nonatomic, assign) BOOL lock_request;//线程锁
@property (nonatomic, assign)   BOOL boolFristReloadData;//是否替换所有数据
@property (nonatomic, assign) BOOL autoTableViewSeparatorSet;

/**
 初始化

 @param url 请求url
 @param classModel model class
 @param classCell cell class
 @return KKBZBasicDataManager实例
 */
- (id)initWithUrl:(NSString *)url model:(Class)classModel cell:(Class)classCell;

/**
 开始请求

 @param dictionary 请求参数
 */
- (void)startLoadWithDictionary:(NSDictionary *)dictionary;


/**
处理结果 需要增加字段

 @param responseObjectData 结果;
 */
- (void)checkWithResponse:(id)responseObjectData;
/**
 设置tableviewcell值

 @param cell tableviewcell
 @param indexPath 位置
 */
- (void)setDataWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/**
 多重cell的情况

 @param indexPath tableview位置
 @return cell class
 */
- (Class)getCellClassWithIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
