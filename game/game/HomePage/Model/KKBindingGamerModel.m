//
//  KKBindingGamerModel.m
//  game
//
//  Created by linsheng on 2018/12/26.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBindingGamerModel.h"

@implementation KKBindingGamerModel
//绝地求生:jdqs
//王者荣耀:wzry
//刺激战场:cjzc
//英雄联盟:yxlm

+  (NSString *)getJPushInfo:(KKGameType)game
{
    switch (game) {
            case KKGameTypeJuediQS:
            return @"jdqs";
            case KKGameTypeWangzheRY:
            return @"wzry";
            case KKGameTypeCijiZC:
            return @"cjzc";
            case KKGameTypeYingxiongLM:
            return @"yxlm";
            
        default:
            return @"";
            break;
    }
}
-  (NSString *)getJPushInfo
{
    return [KKBindingGamerModel getJPushInfo:self.gameid];
}
@end
