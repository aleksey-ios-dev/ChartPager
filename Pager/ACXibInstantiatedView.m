//
// Created by Aleksey on 16.06.14.
// Copyright (c) 2014 Mikhailo Timoscenko. All rights reserved.
//

@import UIKit;

#import "ACXibInstantiatedView.h"
#import "UIView+TLKAppearance.h"

@implementation ACXibInstantiatedView

#pragma mark - Instantiation from nib

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }

    return self;
}

- (void)setup {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    UIView *subview = [nib instantiateWithOwner:self options:nil][0];
    [self setBackgroundColor:[UIColor clearColor]];
    [self tlk_addSubview:subview options:TLKAppearanceOptionOverlay];
}

@end