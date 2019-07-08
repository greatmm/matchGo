//
//  KKUser.m
//  game
//
//  Created by GKK on 2018/8/22.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKUser.h"
#import <objc/runtime.h>
@interface KKUser()<NSCoding,NSSecureCoding>

@end

@implementation KKUser

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId": @"id"};
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    unsigned int count = 0;
    //取出对象的所有属性
    Ivar *ivars = class_copyIvarList([self class], &count);
    //对所有属性进行遍历
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    free(ivars);
}
-(id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            if (value) {
                // 设置到成员变量身上
                [self setValue:value forKey:key];
            }
        }
        free(ivars);
    }
    return self;
}
+ (BOOL)supportsSecureCoding
{
    return YES;
}
@end


