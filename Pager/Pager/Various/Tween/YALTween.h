//
//  YALTween.h
//  Pager
//
//  Created by aleksey on 10.07.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface YALTween : CALayer

- (instancetype)initWithObject:(id<NSObject>)object
                           key:(NSString *)key
                         range:(NSRange)range
                      duration:(NSTimeInterval)duration;

@property (nonatomic, copy) id(^mapper)(CGFloat animatable);
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

- (void)start;
- (void)startWithDelay:(NSTimeInterval)delay;

@end
