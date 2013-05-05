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

- (void) gestureTouchesDone:(NSNotification *)gestureNotification {
    // Process the touchesfrom the gesture view
    [self.dollarPGestureRecognizer recognize];
    [self.gestureView removeFromSuperview];
}

- (void)gestureIsRecognized:(DollarPGestureRecognizer *)sender {
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


- (void)startGestureRouter:(UIView *)callingView {
    //    NSLog(@"in router with my view: %@", callingView);

    self.gestureView  = [[[NSBundle mainBundle] loadNibNamed:GestureViewiPhoneXib owner:self options:nil] lastObject];

    [self.gestureView addGestureRecognizer:self.dollarPGestureRecognizer];
    self.gestureView.backgroundColor = [UIColor colorWithPatternImage:[self takeScreenShot:callingView]];
    
    [callingView addSubview:self.gestureView];
    
    
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


@end
