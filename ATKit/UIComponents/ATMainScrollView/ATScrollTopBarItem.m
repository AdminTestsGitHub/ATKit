//
//  ATScrollTopBarItem.m
//  MiLin
//
//  Created by AdminTest on 2017/9/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATScrollTopBarItem.h"

static CGFloat kNormalSize = 14;
static CGFloat kDefaultRate = 1.15;


@interface ATScrollTopBarItem ()
{
    CGFloat rgba[4];
    CGFloat rgbaGAP[4];
}

@end


@implementation ATScrollTopBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:kNormalSize]];
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles AndIndex:(int)index
{
    self = [super init];
    if (self) {
        [self setTitle:titles[index] forState:UIControlStateNormal];
    }
    return self;
}

- (void)selectedItemWithoutAnimation
{
    self.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(self.rate, self.rate);
    }];
}

- (void)deselectedItemWithoutAnimation
{
    self.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark -- private Method

- (void)setRGB
{
    int numNormal = (int)CGColorGetNumberOfComponents(self.normalColor.CGColor);
    int numSelected = (int)CGColorGetNumberOfComponents(self.selectedColor.CGColor);
    if (numNormal == 4&&numSelected == 4) {
        // UIDeviceRGBColorSpace
        const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
        const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
        rgba[0] = norComponents[0];
        rgbaGAP[0] = selComponents[0] - rgba[0];
        rgba[1] = norComponents[1];
        rgbaGAP[1] = selComponents[1] - rgba[1];
        rgba[2] = norComponents[2];
        rgbaGAP[2] = selComponents[2] - rgba[2];
        rgba[3] = norComponents[3];
        rgbaGAP[3] = selComponents[3] - rgba[3];
    } else {
        if (numNormal == 2) {
            const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
            self.normalColor = [UIColor colorWithRed:norComponents[0] green:norComponents[0] blue:norComponents[0] alpha:norComponents[1]];
        }
        if (numSelected == 2) {
            const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
            self.selectedColor = [UIColor colorWithRed:selComponents[0] green:selComponents[0] blue:selComponents[0] alpha:selComponents[1]];
        }
    }
    
}

- (void)ChangSelectedColorWithRate:(CGFloat)rate
{
    [self setRGB];
    CGFloat r = rgba[0] + rgbaGAP[0]*(1-rate);
    CGFloat g = rgba[1] + rgbaGAP[1]*(1-rate);
    CGFloat b = rgba[2] + rgbaGAP[2]*(1-rate);
    CGFloat a = rgba[3] + rgbaGAP[3]*(1-rate);
    self.titlecolor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    [self setTitleColor:self.titlecolor forState:UIControlStateNormal];
    
}

- (void)ChangSelectedColorAndScalWithRate:(CGFloat)rate
{
    [self ChangSelectedColorWithRate:rate];
    CGFloat scalrate = self.rate - rate * (self.rate - 1);
    self.transform = CGAffineTransformMakeScale(scalrate, scalrate);
}

#pragma mark -- getter Method

- (UIColor *)normalColor
{
    if (!_normalColor) {
        _normalColor = UIColorMakeWithHex(@"666666");
    }
    return _normalColor;
}

- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        _selectedColor = [UIColor redColor];
    }
    return _selectedColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self setTitleColor:self.selectedColor forState:UIControlStateNormal];
    } else {
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
}

- (UIColor *)titlecolor
{
    if (!_titlecolor) {
        _titlecolor = self.normalColor;
    }
    return _titlecolor;
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (self.fontName) {
        self.titleLabel.font = [UIFont fontWithName:self.fontName size:fontSize];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    _fontSize = fontSize;
    
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
    self.fontSize = self.nomrmalSize;
    
}

- (CGFloat)nomrmalSize
{
    if (_nomrmalSize == 0) {
        _nomrmalSize = kNormalSize;
    }
    return _nomrmalSize;
}

- (CGFloat)rate
{
    if (_rate == 0) {
        _rate = kDefaultRate;
    }
    return _rate;
}


@end
