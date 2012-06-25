//
//  ANImageWheel.m
//  SpinWheel
//
//  Created by Alex Nichol on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANImageWheel.h"

@implementation ANImageWheel

- (void)setImage:(UIImage *)anImage {
    [imageView setImage:anImage];
}

- (UIImage *)image {
    return [imageView image];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)anImage {
    if ((self = [self initWithFrame:frame])) {
        [imageView setImage:anImage];
    }
    return self;
}

- (void)setAngle:(double)anAngle {
    [super setAngle:anAngle];
    [[imageView layer] setTransform:CATransform3DMakeRotation(angle, 0, 0, 1)];
}

@end
