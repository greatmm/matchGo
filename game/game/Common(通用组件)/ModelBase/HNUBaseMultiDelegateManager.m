//
//  HNUBaseMultiDelegateManager.m
//  HeiNiu
//
//  Created by JOY on 16/11/9.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import "HNUBaseMultiDelegateManager.h"

@interface HNUWeakObjectBridge : NSObject

@property (nonatomic,weak) id contentObject;

@end

@implementation HNUWeakObjectBridge

-(id)initWithContentObject:(id)contentObject
{
    if (self = [self init]) {
        _contentObject = contentObject;
    }
    return self;
}
@end

@interface HNUBaseMultiDelegateManager()

@property (nonatomic,strong) NSMutableArray *delegateBridgesArray;

@end

@implementation HNUBaseMultiDelegateManager

-(NSMutableArray *)delegateBridgesArray
{
    if (!_delegateBridgesArray) {
        _delegateBridgesArray = [NSMutableArray array];
    }
    return _delegateBridgesArray;
}

-(void)addDelegate:(id)delegate
{
    BOOL isExist = NO;
    for (NSInteger i = self.delegateBridgesArray.count - 1 ; i>=0;i--) {
        HNUWeakObjectBridge *bridge = self.delegateBridgesArray[i];
        if (bridge.contentObject == delegate) {
            isExist = YES;
            break;
        }else if(bridge.contentObject == nil){
            [self.delegateBridgesArray removeObject:bridge];
        }
    }
    if (!isExist) {
        HNUWeakObjectBridge *bridge = [[HNUWeakObjectBridge alloc]initWithContentObject:delegate];
        [self.delegateBridgesArray addObject:bridge];
    }
}

-(void)removeDelegate:(id)delegate
{
    for (NSInteger i = self.delegateBridgesArray.count - 1 ; i>=0;i--) {
        HNUWeakObjectBridge *bridge = self.delegateBridgesArray[i];
        if (bridge.contentObject == delegate || bridge.contentObject == nil) {
            [self.delegateBridgesArray removeObject:bridge];
        }
    }
}

-(void)clearDiscardedDelegates
{
    for (NSInteger i = self.delegateBridgesArray.count - 1 ; i>=0;i--) {
        HNUWeakObjectBridge *bridge = self.delegateBridgesArray[i];
        if (bridge.contentObject == nil) {
            [self.delegateBridgesArray removeObject:bridge];
        }
    }
}

-(NSArray *)delegatesArray
{
    NSMutableArray *delegatesArr= [NSMutableArray array];
    for (NSInteger i = self.delegateBridgesArray.count - 1 ; i>=0;i--) {
        HNUWeakObjectBridge *bridge = self.delegateBridgesArray[i];
        if (bridge.contentObject) {
            [delegatesArr addObject:bridge];
        }
    }
    return delegatesArr;
}

-(void)operateDelegate:(void (^)(id))operation
{
    for (NSInteger i = self.delegateBridgesArray.count - 1 ; i>=0;i--) {
        HNUWeakObjectBridge *bridge = self.delegateBridgesArray[i];
        if (bridge.contentObject && operation) {
            operation(bridge.contentObject);
        }
    }
}

@end
