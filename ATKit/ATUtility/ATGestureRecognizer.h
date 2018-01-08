//
//  ATGestureRecognizer.h
//  DPCA
//
//  Created by AdminTest on 2017/12/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// State of the gesture
typedef NS_ENUM(NSUInteger, ATGestureRecognizerState) {
    ATGestureRecognizerStateBegan, ///< gesture start
    ATGestureRecognizerStateMoved, ///< gesture moved
    ATGestureRecognizerStateEnded, ///< gesture end
    ATGestureRecognizerStateCancelled, ///< gesture cancel
};

/**
 A simple UIGestureRecognizer subclass for receive touch events.
 */
@interface ATGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGPoint startPoint; ///< start point
@property (nonatomic, readonly) CGPoint endPoint; ///< end point.
@property (nonatomic, readonly) CGPoint currentPoint; ///< current move point.
@property (nonatomic, readonly) CGPoint previousPoint; ///< previous move point.

/// The action block invoked by every gesture event.
@property (nullable, nonatomic, copy) void (^action)(ATGestureRecognizer *gesture, ATGestureRecognizerState state);

/// Cancel the gesture for current touch.
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
