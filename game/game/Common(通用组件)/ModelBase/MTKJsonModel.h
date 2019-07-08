//
//  MTKJsonModel.h
//  EyeStock
//
//  Created by linsheng on 2018/11/5.
//  Copyright © 2018年 NiuBang. All rights reserved.
//
#import <Foundation/Foundation.h>

/*
所有属性大小写不敏感
*/

@interface MTKJsonModel : NSObject<NSCoding,NSCopying>

- (instancetype)initWithJSONDict:(NSDictionary *)dict;
//插入json字符串
- (void)injectWithJsonString:(NSString*)jsonString;
//替换模型数据 只能处理字典
- (void)injectJSONData:(NSDictionary*)jsonData;
//替换模型数据
- (void)injectDataWithModel:(MTKJsonModel*)model;
//不区分大小写
- (NSDictionary *)jsonDict;
//区分大小写
-(NSDictionary *)jsonDictCaseSensitive;

- (NSString *)jsonString;

//键的map @{Json字段名称:属性名称} 都使用小写
+ (NSDictionary *)mtkJsonModelKeyMapper;

//bz 2018-10-10 检测是否类似 用于相似检测拷贝
- (NSString *)bzDetectionKey;
@end
