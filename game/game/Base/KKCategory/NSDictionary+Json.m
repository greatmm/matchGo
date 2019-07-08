//
//  NSDictionary+PBJson.m
//  MaiTalk
//
//  Created by linsheng on 16/4/12.
//  Copyright © 2016年 linsheng. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

- (NSString *)JsonString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *date = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (!error) {
            NSString *string = [[NSString alloc]initWithData:date encoding:NSUTF8StringEncoding];
            return string;
        }
    }
    return @"";
}

+(NSDictionary *)DictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString.length) {
        NSData *data= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictionary = jsonObject;
            return dictionary;
        }
    }
    return nil;
}

@end
