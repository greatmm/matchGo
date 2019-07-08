//
//  KKFileTool.m
//  game
//
//  Created by Jack on 2018/8/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKFileTool.h"
#import "KKDataTool.h"
@implementation KKFileTool
+(NSArray*)chineseCityArr{
    static NSArray * cityArr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"china_city_data.json" ofType:nil];
        NSData * data = [[NSData alloc] initWithContentsOfFile:filePath];
        cityArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    });
    return cityArr;
}
@end
