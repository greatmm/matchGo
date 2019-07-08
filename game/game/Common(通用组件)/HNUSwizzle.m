//
//  HNUSwizzle.m
//  HeiNiu
//
//  Created by JOY on 16/11/10.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import "HNUSwizzle.h"
#import <objc/objc.h>
#import <objc/runtime.h>

BOOL hnu_swizzleInstanceMethod(Class aClass, SEL originalSel, SEL replacementSel)
{
    Method origMethod = class_getInstanceMethod(aClass, originalSel);
    Method replMethod = class_getInstanceMethod(aClass, replacementSel);
    
    if (!origMethod) {
        return NO;
    }
    
    if (!replMethod) {
        return NO;
    }
    
    if (class_addMethod(aClass, originalSel, method_getImplementation(replMethod), method_getTypeEncoding(replMethod)))
    {
        class_replaceMethod(aClass, replacementSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, replMethod);
    }
    return YES;
}

BOOL hnu_swizzleClassMethod(Class aClass, SEL originalSel, SEL replacementSel)
{
    return hnu_swizzleInstanceMethod(object_getClass((id)aClass), originalSel, replacementSel);
}

IMP  hnu_swizzleMethodIMP(Class aClass, SEL originalSel, IMP replacementIMP)
{
    Method origMethod = class_getInstanceMethod(aClass, originalSel);
    
    if (!origMethod) {
        return NULL;
    }
    
    IMP origIMP = method_getImplementation(origMethod);
    
    if(!class_addMethod(aClass, originalSel, replacementIMP,
                        method_getTypeEncoding(origMethod)))
    {
        method_setImplementation(origMethod, replacementIMP);
    }
    return origIMP;
}

// other way implement
BOOL  hnu_swizzleMethodAndStoreIMP(Class aClass, SEL originalSel, IMP replacementIMP,IMP *orignalStoreIMP)
{
    IMP imp = NULL;
    Method method = class_getInstanceMethod(aClass, originalSel);
    
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(aClass, originalSel, replacementIMP, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }else{
    }
    
    if (imp && orignalStoreIMP)
    {
        *orignalStoreIMP = imp;
    }
    return (imp != NULL);
}



@implementation NSObject (HNUSwizzle)
+ (BOOL)hnu_swizzleMethodWithOrignalSel:(SEL)orignalSel replacementSel:(SEL)replacementSel
{
    return hnu_swizzleInstanceMethod(self, orignalSel, replacementSel);
}

+ (BOOL)hnu_swizzleClassMethodWithOrignalSel:(SEL)orignalSel replacementSel:(SEL)replacementSel
{
    return hnu_swizzleClassMethod(self, orignalSel, replacementSel);
}

+ (IMP) hnu_swizzleMethodWithOrignalSel:(SEL)orignalSel replacementIMP:(IMP)replacementIMP
{
    return hnu_swizzleMethodIMP(self, orignalSel, replacementIMP);
}

+ (BOOL)hnu_swizzleMethodWithOrignalSel:(SEL)orignalSel replacementIMP:(IMP)replacementIMP orignalStoreIMP:(IMP *)orignalStoreIMP
{
    return hnu_swizzleMethodAndStoreIMP(self, orignalSel, replacementIMP, orignalStoreIMP);
}

@end


