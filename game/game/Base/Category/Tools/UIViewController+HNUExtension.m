//
//  UIViewController+HNUExtension.m
//  VCExtensionProject
//
//  Created by JOY on 16/12/16.
//  Copyright © 2016年 JOY. All rights reserved.
//

#import "UIViewController+HNUExtension.h"

#import <objc/runtime.h>
#import "HNUSwizzle.h"

@interface UIViewController (HNUExtensionPrivacy)

@end

@implementation UIViewController (HNUExtension)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController hnu_swizzleMethodWithOrignalSel:@selector(viewWillAppear:) replacementSel:@selector(hnu_viewWillAppear:)];
        [UIViewController hnu_swizzleMethodWithOrignalSel:@selector(viewDidAppear:) replacementSel:@selector(hnu_viewDidAppear:)];
        [UIViewController hnu_swizzleMethodWithOrignalSel:@selector(viewDidDisappear:) replacementSel:@selector(hnu_viewDidDisappear:)];
        [UIViewController hnu_swizzleMethodWithOrignalSel:@selector(viewWillDisappear:) replacementSel:@selector(hnu_viewWillDisappear:)];
        [UIViewController hnu_swizzleMethodWithOrignalSel:@selector(viewDidLoad) replacementSel:@selector(hnu_viewDidLoad)];
        
    });
}

#pragma mark Params

#pragma mark LifeCycle

-(void)hnu_viewDidLoad
{
    [self hnu_viewDidLoad];
}
- (void)hnu_viewWillDisappear:(BOOL)animated
{

    [self hnu_viewWillDisappear:animated];
}
-(void)hnu_viewDidDisappear:(BOOL)animated
{
    
    [self hnu_viewDidDisappear:animated];
}

-(void)hnu_viewWillAppear:(BOOL)animated
{
    
    DLOG(@"bztestViewWillAppear%@",[self class]);
    
    [self hnu_viewWillAppear:animated];
}

-(void)hnu_viewDidAppear:(BOOL)animated
{

    [[KKDataTool shareTools] resetPath];
    [self hnu_viewDidAppear:animated];
}



@end


