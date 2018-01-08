//
//  CALayer+ATUIColor.m
//  DPCA
//
//  Created by AdminTest on 2017/12/27.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "CALayer+ATUIColor.h"

@implementation CALayer (ATUIColor)

- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderColorWithUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}


@end
