//
//  GesturePadView.h
//  gesturetest
//
//  Created by Eric Nelson on 5/1/13.
//  Copyright (c) 2013 Sandalsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface GestureView : UIView {
    NSMutableDictionary *currentTouches;
    NSMutableArray *completeStrokes;
    
}
@property BOOL showStroke;

- (void)clearAll;

@end
