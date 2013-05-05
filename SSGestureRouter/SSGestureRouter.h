//
//  SSGestureRouter.h
//  SSGestureRouter
//
//  Created by Eric Nelson on 5/3/13.
//  Copyright (c) 2013 Sandalsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "GestureView.h"
#import "DollarPGestureRecognizer.h"


@protocol GestureDelegate <NSObject>

@required
- (void)gestureRecognitionDidFinish:(NSDictionary *) gestureDict;
@end


@interface SSGestureRouter : NSObject

@property (strong, nonatomic) IBOutlet GestureView *gestureView;
@property (strong, nonatomic) DollarPGestureRecognizer *dollarPGestureRecognizer;
@property (strong, nonatomic) UIView *sendingView;
@property BOOL useLongTouchGestureAactivation;
@property float longTouchActivationDuration;
@property BOOL showStroke;
@property BOOL showViewBorderOutline;
@property (weak, nonatomic) UIColor *viewBorderOutlineColor;
@property float viewBorderOutlineThickness;
@property (nonatomic, assign) id delegate;



- (id)initWithCallingView:(UIView *)callingView;
- (void)startGestureRouter:(UIView *)callingView;


@end
