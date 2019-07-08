//
//  HNUBaseMultiDelegateManager.h
//  HeiNiu
//
//  Created by JOY on 16/11/9.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import <Foundation/Foundation.h>
//用以支持多重代理的基本类
@interface HNUBaseMultiDelegateManager : NSObject
//添加代理
-(void)addDelegate:(id)delegate;
//移除代理
-(void)removeDelegate:(id)delegate;
//获取当前的delegate列表
-(NSArray *)delegatesArray;
//每个delegate执行任务
- (void)operateDelegate:(void (^)(id delegate))operation;
@end
