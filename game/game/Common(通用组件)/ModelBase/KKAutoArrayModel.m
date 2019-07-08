//
//  KKAutoArrayModel.m
//  game
//
//  Created by linsheng on 2018/12/26.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAutoArrayModel.h"

@implementation KKAutoArrayModel
- (id)initWithKey:(NSString *)key bid:(Class )className
{
    if (self=[super init]) {
        _dictKey=key;
        _modelName=className;
    }
    return self;
}
- (void)injectJSONData:(NSDictionary*)jsonData
{
    [self.arrayOutput removeAllObjects];
    if (jsonData&&[jsonData isKindOfClass:[NSDictionary class]]) {
        self.arrayOutput=[@[] mutableCopy];
        NSArray *array=nil;
        if (![HNUBZUtil checkStrEnable:self.dictKey]) {
            for (id value in jsonData.allValues) {
                if ([value isKindOfClass:[NSArray class]]) {
                    array=value;
                }
            }
        }
        else array=jsonData[self.dictKey];
        if ([HNUBZUtil checkArrEnable:array]) {
            for (NSDictionary *dict in array) {
                MTKJsonModel *model = [[_modelName alloc]initWithJSONDict:dict];
                [_arrayOutput addObject:model];
            }
        }
        
    }
    else if([jsonData isKindOfClass:[NSArray class]])
    {
        self.arrayOutput=[@[] mutableCopy];
        NSArray *array=(NSArray *)jsonData;
        for (NSDictionary *dict in array) {
            if ([HNUBZUtil checkDictEnable:dict]) {
                MTKJsonModel *model = [[_modelName alloc]initWithJSONDict:dict];
                [_arrayOutput addObject:model];
            }
            else [_arrayOutput addObject:dict];
            
        }
        
    }
    
}
@end
