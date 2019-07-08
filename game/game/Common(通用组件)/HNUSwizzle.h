//
//  HNUSwizzle.h
//  HeiNiu
//
//  Created by JOY on 16/11/10.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import <Foundation/Foundation.h>

// exchange instance method
BOOL hnu_swizzleInstanceMethod(Class aClass, SEL originalSel, SEL replacementSel);

// exchange class method
BOOL hnu_swizzleClassMethod(Class aClass, SEL originalSel, SEL replacementSel);

// exchange method with IMP, and store orignal IMP
BOOL hnu_swizzleMethodAndStoreIMP(Class aClass, SEL originalSel, IMP replacementIMP,IMP *orignalStoreIMP);
// exchange IMP of seletor with IMP
IMP  hnu_swizzleMethodIMP(Class aClass, SEL originalSel, IMP replacementIMP);

@interface NSObject (HNUSwizzle)

// exchange instance method
+ (BOOL)hnu_swizzleMethodWithOrignalSel:(SEL)orignalSel replacementSel:(SEL)replacementSel;

// exchange class method
+ (BOOL)hnu_swizzleClassMethodWithOrignalSel:(SEL)orignalSel replacementSel:(SEL)replacementSel;

// exchange method with IMP, and store orignal IMP
+ (BOOL)hnu_swizzleMethodWithOrignalSel:(SEL)orignalSel replacementIMP:(IMP)replacementIMP orignalStoreIMP:(IMP *)orignalStoreIMP;
// exchange IMP of seletor with IMP
+ (IMP)hnu_swizzleMethodWithOrignalSel:(SEL)orignalSel replacementIMP:(IMP)replacementIMP;

@end
