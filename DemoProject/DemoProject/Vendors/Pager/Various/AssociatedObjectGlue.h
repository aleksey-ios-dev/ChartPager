//
// Created by aleksey on 14.09.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

void setAssociatedObject_glue(NSObject *object, const NSString *key, NSObject *value) {
    objc_setAssociatedObject(object, (__bridge const void *)(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

NSObject *getAssociatedObject_glue(NSObject *object, const NSString* key) {
    return objc_getAssociatedObject(object, (__bridge const void *)(key));
}