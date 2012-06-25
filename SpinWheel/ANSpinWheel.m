//
//  ANSpinWheel.m
//  SpinWheel
//
//  Created by Alex Nichol on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANSpinWheel.h"

@interface ANSpinWheel (Private)

- (void)animationTimer:(id)sender;

- (void)pushTouchPoint:(CGPoint)point date:(NSDate *)date;
- (void)clearTouchData;

- (double)calculateFinalAngularVelocity:(NSDate *)finalDate;
- (double)angleForPoint:(CGPoint)point;

@end

@implementation ANSpinWheel

@synthesize angle;
@synthesize angularVelocity;
@synthesize drag;

- (void)startAnimating:(id)sender {
    if (displayTimer) return;
    lastTimerDate = nil;
    displayTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationTimer:)];
    [displayTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimating:(id)sender {
    if (!displayTimer) return;
    [displayTimer invalidate];
    displayTimer = nil;
}

- (void)animationTimer:(id)sender {
    NSDate * newDate = [NSDate date];
    if (!lastTimerDate || angularVelocity == 0) {
        lastTimerDate = newDate;
        return;
    }
    
    NSTimeInterval passed = [newDate timeIntervalSinceDate:lastTimerDate];
    
    double angleReduction = drag * passed * ABS(angularVelocity);
    if (angularVelocity < 0) {
        angularVelocity += angleReduction;
        if (angularVelocity > 0) angularVelocity = 0;
    } else if (angularVelocity > 0) {
        angularVelocity -= angleReduction;
        if (angularVelocity < 0) angularVelocity = 0;
    }
    
    if (ABS(angularVelocity) < 0.01) angularVelocity = 0;
    
    double useAngle = angle;
    useAngle += angularVelocity * passed;
    // limit useAngle to +/- 2*PI
    if (useAngle < 0) {
        while (useAngle < -2 * M_PI) {
            useAngle += 2 * M_PI;
        }
    } else {
        while (useAngle > 2 * M_PI) {
            useAngle -= 2 * M_PI;
        }
    }
    
    self.angle = useAngle;
    lastTimerDate = newDate;
    [self setNeedsDisplay];
}

#pragma mark - Touches -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.angularVelocity = 0;
    initialAngle = angle;
    initialPoint = [[touches anyObject] locationInView:self];
    [self pushTouchPoint:initialPoint date:[NSDate date]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint thePoint = [[touches anyObject] locationInView:self];
    [self pushTouchPoint:thePoint date:[NSDate date]];
    double angleDif = [self angleForPoint:thePoint] - [self angleForPoint:initialPoint];
    self.angle = initialAngle + angleDif;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.angularVelocity = [self calculateFinalAngularVelocity:[NSDate date]];
    [self clearTouchData];
}

#pragma mark - Private -

#pragma mark States

- (void)pushTouchPoint:(CGPoint)point date:(NSDate *)date {
    previousDates[0] = previousDates[1];
    previousPoints[0] = previousPoints[1];
    previousDates[1] = date;
    previousPoints[1] = point;
}

- (void)clearTouchData {
    previousDates[0] = nil;
    previousDates[1] = nil;
    previousPoints[0] = CGPointZero;
    previousPoints[1] = CGPointZero;
}

#pragma mark Calculation

- (double)calculateFinalAngularVelocity:(NSDate *)finalDate {
    if (!previousDates[0]) return 0;
    NSTimeInterval delay = [finalDate timeIntervalSinceDate:previousDates[0]];
    double prevAngle = [self angleForPoint:previousPoints[0]];
    double endAngle = [self angleForPoint:previousPoints[1]];
    return (endAngle - prevAngle) / delay;
}

- (double)angleForPoint:(CGPoint)point {
    CGPoint center = CGPointMake(self.frame.size.width / 2,
                                 self.frame.size.height / 2);
    return atan2(point.y - center.y, point.x - center.x);
}

@end
