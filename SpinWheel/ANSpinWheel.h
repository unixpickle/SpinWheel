//
//  ANSpinWheel.h
//  SpinWheel
//
//  Created by Alex Nichol on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ANSpinWheel : UIView {
    double angle;
    double angularVelocity;
    double drag;
    
    NSDate * lastTimerDate;
    CADisplayLink * displayTimer;
    
    CGPoint initialPoint;
    double initialAngle;
    CGPoint previousPoints[2];
    NSDate * previousDates[2];
}

@property (readwrite) double angle;
@property (readwrite) double angularVelocity;
@property (readwrite) double drag;

- (void)startAnimating:(id)sender;
- (void)stopAnimating:(id)sender;

@end
