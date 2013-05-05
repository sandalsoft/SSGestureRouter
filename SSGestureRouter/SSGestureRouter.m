//
//  SSGestureRouter.m
//  SSGestureRouter
//
//  Created by Eric Nelson on 5/3/13.
//  Copyright (c) 2013 Sandalsoft. All rights reserved.
//

#import "SSGestureRouter.h"
#import <QuartzCore/QuartzCore.h>
#import "DollarDefaultGestures.h"



@implementation SSGestureRouter


- (id)initWithCallingView:(UIView *)callingView {
    if ((self = [super init])) {
        
        // Receive notifcations from DollarPGestureRecognizer when touch ends (ie, finger is lifeted up)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gestureTouchesDone:)
                                                     name:GESTURE_TOUCH_END
                                                   object:nil];
        
        self.sendingView = callingView;
        
        self.showViewBorderOutline = NO;
        self.viewBorderOutlineColor = [UIColor redColor];
        self.viewBorderOutlineThickness = 3.0f;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateGesture:)];
        
        if (self.useLongTouchGestureAactivation) {
            self.longTouchActivationDuration = (self.longTouchActivationDuration) ? self.longTouchActivationDuration : 1.0f;
            longPress.minimumPressDuration = self.longTouchActivationDuration;
            [callingView addGestureRecognizer:longPress];
        }
        self.dollarPGestureRecognizer = [[DollarPGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(gestureIsRecognized:)];
        [self.dollarPGestureRecognizer setPointClouds:[DollarDefaultGestures defaultPointClouds]];
        [self.dollarPGestureRecognizer setDelaysTouchesEnded:NO];   
    }
    return self;
}

- (void)startGestureRouter:(UIView *)callingView {
    //    NSLog(@"in router with my view: %@", callingView);
    
    self.gestureView  = [[[NSBundle mainBundle] loadNibNamed:GestureViewiPhoneXib owner:self options:nil] lastObject];
    
    [self.gestureView addGestureRecognizer:self.dollarPGestureRecognizer];
    self.gestureView.backgroundColor = [UIColor colorWithPatternImage:[self takeScreenShot:callingView]];
    [self addBorder:callingView withBorderColor:self.viewBorderOutlineColor withTickness:self.viewBorderOutlineThickness];
    [callingView addSubview:self.gestureView];
}

    // Process the touchesfrom the gesture view
- (void) gestureTouchesDone:(NSNotification *)gestureNotification {
    [self.dollarPGestureRecognizer recognize];
    [self.gestureView removeFromSuperview];
}

- (void)gestureIsRecognized:(DollarPGestureRecognizer *)sender {
    [self removeBorder:self.sendingView];
    DollarResult *result = [sender result];
    //    NSLog(@"Name: %@\nScore: %.2f", [result name], [result score]);
    NSDictionary *gestureDict = @{@"gestureName":[result name],@"gestureScore":[NSNumber numberWithDouble:[result score]]};
    [[self delegate]  gestureRecognitionDidFinish:gestureDict];
}






- (void)activateGesture:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        [self startGestureRouter:self.sendingView];
    }
}


- (UIImage *)takeScreenShot:(UIView *)view {
    CGRect rect = [view bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
}

- (void)addBorder:(UIView *) callingView withBorderColor:(UIColor *)borderColor withTickness:(float)thickness {
    callingView.layer.borderColor = borderColor.CGColor;
    callingView.layer.borderWidth = thickness;
}

- (void)removeBorder:(UIView *) callingView {
    callingView.layer.borderColor = nil;
    callingView.layer.borderWidth = 0;
}


@end
