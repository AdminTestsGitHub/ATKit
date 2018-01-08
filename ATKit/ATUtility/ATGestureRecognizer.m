//
//  ATGestureRecognizer.m
//  DPCA
//
//  Created by AdminTest on 2017/12/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ATGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateBegan;
    _startPoint = [(UITouch *)[touches anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    if (_action) _action(self, ATGestureRecognizerStateBegan);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateChanged;
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    CGPoint previousPoint = [touch previousLocationInView:self.view];
    _previousPoint = previousPoint;
    _currentPoint = currentPoint;
    if (_action) _action(self, ATGestureRecognizerStateMoved);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
    _endPoint = [(UITouch *)[touches anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    if (_action) _action(self, ATGestureRecognizerStateEnded);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
//    _endPoint = [(UITouch *)[touches anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    if (_action) _action(self, ATGestureRecognizerStateCancelled);
}

- (void)reset {
    self.state = UIGestureRecognizerStatePossible;
}

- (void)cancel {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateCancelled;
        if (_action) _action(self, ATGestureRecognizerStateCancelled);
    }
}

@end
