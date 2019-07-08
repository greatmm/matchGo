//
//  KKMatchGoSchemesManager.m
//  game
//
//  Created by linsheng on 2019/1/18.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKMatchGoSchemesManager.h"
#import "NSDictionary+Json.h"
@implementation KKMatchGoSchemesManager
+ (BOOL)dealWithOpenUrl:(NSURL *)url
{
    if ([HNUBZUtil checkEqualFirst:@"matchgo" second:url.host]) {
        NSString *decodedString = url.query.stringByRemovingPercentEncoding;
        NSDictionary *dictionary=[NSDictionary DictionaryWithJsonString:decodedString];
        NSString *str=dictionary[@"features"];
        if ([HNUBZUtil checkStrEnable:str]) {
            if ([str isEqualToString:@"joinRoom"]&&[KKDataTool token]) {
                if([HNUBZUtil checkStrEnable:dictionary[@"expansion"][@"roomID"]])
                {
                    [KKHouseTool enterPwdroomWithPwd:dictionary[@"expansion"][@"roomID"]];
                }
            }
        }
        return true;
    }
    return false;
}
@end
