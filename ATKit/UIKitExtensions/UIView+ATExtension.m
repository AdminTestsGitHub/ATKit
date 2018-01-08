//
//  UIView+ATExtension.m
//  WeBuy
//
//  Created by AdminTest on 2017/3/28.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "UIView+ATExtension.h"

@implementation UIView (ATExtension)


- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setMaxX:(CGFloat)maxX
{

}

- (void)setMinX:(CGFloat)minX
{

}

- (void)setMaxY:(CGFloat)maxY
{

}

- (void)setMinY:(CGFloat)minY
{

}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)minX
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)minY
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}



//淡入
- (void)fadeInWithTime:(NSTimeInterval)time
{
    self.alpha = 0;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

//淡出
- (void)fadeOutWithTime:(NSTimeInterval)time
{
    self.alpha = 1;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//缩放
- (void)scalingWithTime:(NSTimeInterval)time scale:(CGFloat)scale
{
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}
@end
