//
//  ATProgressHUD.m
//  MiLin
//
//  Created by AdminTest on 2017/8/16.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATProgressHUD.h"

@interface ATProgressHUD ()

@property (assign, nonatomic) CGFloat angle;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *edgeImageView;
@property (strong, nonatomic) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (assign, nonatomic) ATProgressHUDState progressState;
@property (assign, nonatomic) NSTimeInterval seconds;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end

@implementation ATProgressHUD

@synthesize overlayWindow = _overlayWindow;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.edgeImageView];
    [self addSubview:self.centerLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.titleLabel];
}

#pragma mark - Private Methods

- (void)show {
    self.angle = 0.0f;
    self.seconds = 0;
    self.subTitleLabel.text = @"向上滑动取消";
    self.centerLabel.text = @"60";
    self.titleLabel.text = @"录音时间";
    [self timer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:.5 animations:^{
            self.alpha = 1;
        } completion:nil];
        [self setNeedsDisplay];
    });
}

- (void)timerAction {
    self.angle -= 3;
    self.seconds ++ ;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    self.edgeImageView.transform = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    float second = [self.centerLabel.text floatValue];
    if (second <= 10.0f) {
        self.centerLabel.textColor = [UIColor redColor];
    } else {
        self.centerLabel.textColor = [UIColor yellowColor];
    }
    self.centerLabel.text = [NSString stringWithFormat:@"%.1f",second-0.1];
    [UIView commitAnimations];
}

- (void)setSubTitle:(NSString *)subTitle {
    self.subTitleLabel.text = subTitle;
}

- (void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer invalidate];
        self.timer = nil;
        self.subTitleLabel.text = nil;
        self.titleLabel.text = nil;
        self.centerLabel.textColor = [UIColor whiteColor];
        
        CGFloat timeLonger;
        if (self.progressState == ATProgressHUDStateShort) {
            timeLonger = 1;
        } else {
            timeLonger = 0.6;
        }
        [UIView animateWithDuration:timeLonger
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [self removeFromSuperview];
                                 
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:self.overlayWindow];
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}


#pragma mark - Setters

- (void)setProgressState:(ATProgressHUDState)progressState {
    if ([ATProgressHUD seconds] < 1) {
        progressState = ATProgressHUDStateShort;
    }
    switch (progressState) {
        case ATProgressHUDStateSuccess:
            self.centerLabel.text = @"录音成功";
            break;
        case ATProgressHUDStateShort:
            self.centerLabel.text = @"时间太短";
            break;
        case ATProgressHUDStateError:
            self.centerLabel.text = @"录音失败";
            break;
        case ATProgressHUDStateMessage:
            break;
    }
}


#pragma mark - Getters

- (NSTimer *)timer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
    return _timer;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
        _centerLabel.backgroundColor = [UIColor clearColor];
        _centerLabel
        .center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
        _centerLabel.text = @"60";
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont systemFontOfSize:30];
        _centerLabel.textColor = [UIColor yellowColor];
        
    }
    return _centerLabel;
}

- (UIImageView *)edgeImageView {
    if (!_edgeImageView) {
        _edgeImageView = [[UIImageView alloc]initWithImage:({
            NSString *imageName = @"chat_bar_record_circle";
            UIImage *image = [UIImage imageNamed:@""];
            image;})
                          ];
        _edgeImageView.center =  CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
    }
    return _edgeImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        _titleLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2 - 30);
        _titleLabel.text = @"录音时间";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}


- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        _subTitleLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2 + 30);
        _subTitleLabel.text = @"向上滑动取消录音";
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _subTitleLabel.textColor = [UIColor whiteColor];
    }
    return _subTitleLabel;
}

- (UIWindow *)overlayWindow {
    if(!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.userInteractionEnabled = NO;
        [_overlayWindow makeKeyAndVisible];
    }
    return _overlayWindow;
}

#pragma mark - Class Methods

+ (ATProgressHUD *)sharedView {
    static dispatch_once_t once;
    static ATProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[ATProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    });
    return sharedView;
}

+ (void)show {
    [[ATProgressHUD sharedView] show];
}

+ (void)dismissWithProgressState:(ATProgressHUDState)progressState {
    [[ATProgressHUD sharedView] setProgressState:progressState];
    [[ATProgressHUD sharedView] dismiss];
}

+ (void)dismissWithMessage:(NSString *)message {
    [[ATProgressHUD sharedView] setProgressState:ATProgressHUDStateMessage];
    [ATProgressHUD sharedView].centerLabel.text = message;
    [[ATProgressHUD sharedView] dismiss];
}

+ (void)changeSubTitle:(NSString *)str
{
    [[ATProgressHUD sharedView] setSubTitle:str];
}

+ (NSTimeInterval)seconds{
    return [[ATProgressHUD sharedView] seconds] / 10;
}



@end
