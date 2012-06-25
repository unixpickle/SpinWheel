//
//  ANImageWheel.h
//  SpinWheel
//
//  Created by Alex Nichol on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANSpinWheel.h"

@interface ANImageWheel : ANSpinWheel {
    UIImageView * imageView;
}

- (void)setImage:(UIImage *)anImage;
- (UIImage *)image;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)anImage;

@end
