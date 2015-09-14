//
//  YALTween.m
//  Pager
//
//  Created by aleksey on 10.07.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

#import "YALTween.h"
@import UIKit;

@interface YALTween ()

@property (nonatomic) CGFloat animatable;
@property (nonatomic, weak) id object;
@property (nonatomic, copy) NSString *key;
@property (nonatomic) NSRange range;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval tweenDuration;

@end

@implementation YALTween

@dynamic animatable;

- (instancetype)initWithObject:(id<NSObject>)object
                           key:(NSString *)key
                         range:(NSRange)range
                      duration:(NSTimeInterval)duration {

    if (self = [super init]) {
        _object = object;
        _key = key;
        _range = range;
        _tweenDuration = duration;
    }
    
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"animatable"]) {
        return YES;
    }
    return [key isEqualToString:@"animatable"] ? YES : [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)key {
    if (![key isEqualToString:@"animatable"]) return [super actionForKey:key];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    [animation setTimingFunction: _timingFunction ?: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setFromValue:@(_range.location)];
    [animation setToValue:@(_range.length)];
    [animation setDuration:_tweenDuration];
    [animation setBeginTime:CACurrentMediaTime() + _delay];
    
    return animation;
}

- (void)display {
    if (_mapper) {
        [_object setValue:_mapper([self.presentationLayer animatable]) forKey:_key];
    } else {
        [_object setFloat:[self.presentationLayer animatable] forKey:_key];
    }

    NSLog(@"print!");
}

- (void)start {
    [self setAnimatable:_range.length];
    [[[UIApplication sharedApplication].delegate window].rootViewController.view.layer addSublayer:self];
}

- (void)startWithDelay:(NSTimeInterval)delay {
    _delay = delay;
    
    [self start];
}

@end
