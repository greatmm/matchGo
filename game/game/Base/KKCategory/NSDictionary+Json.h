//
//  NSDictionary+PBJson.h
//  MaiTalk
//
//  Created by linsheng on 16/4/12.
//  Copyright © 2016年 linsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

- (NSString *)JsonString;

+ (NSDictionary *)DictionaryWithJsonString:(NSString*)jsonString;

@end
