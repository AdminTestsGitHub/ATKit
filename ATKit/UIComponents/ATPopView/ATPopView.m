//
//  ATPopView.m
//  MiLin
//
//  Created by AdminTest on 2017/10/19.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATPopView.h"

static CGFloat kIconHeight = 92;
static CGFloat kTitleHeight = 30;

@implementation ATCustomBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectMake(0, (contentRect.size.height - kIconHeight - kTitleHeight) / 2, contentRect.size.width, kIconHeight);
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, (contentRect.size.height - kIconHeight - kTitleHeight) / 2 + kIconHeight, contentRect.size.width, kTitleHeight);
    return rect;
}

@end


@implementation ATPopMenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon {
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = icon;
    }
    return self;
}

@end



@interface ATPopView ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UIButton *disBtn;
@property (nonatomic, assign) BOOL btnCanceled;

@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) void (^selectBlock)(ATPopMenuItem *result);

@end


@implementation ATPopView

+ (instancetype)showInView:(UIView *)view withItems:(NSArray *)items selectBlock:(void (^)(ATPopMenuItem *item))block
{
    ATPopView *pop = [[ATPopView alloc] initWithSuperView:view withItems:items selectBlock:block];
    [view addSubview:pop];
    [pop show];
    return pop;
}

- (instancetype)initWithSuperView:(UIView *)superView withItems:(NSArray *)items selectBlock:(void (^)(ATPopMenuItem *item))block
{
    self = [super initWithFrame:superView.bounds];
    if (self) {
        self.superView = superView;
        self.items = items;
        self.selectBlock = block;
        
        [self setUpUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundView];
//    [self addSubview:self.headerImageView];
    [self addSubview:self.centerView];
    [self addSubview:self.disBtn];
}

- (void)show
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self fadeInWithTime:0.25];
    [UIView animateWithDuration:0.25 animations:^{
        self.disBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
    [self showItemAnimation];
}

- (void)dismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fadeOutWithTime:0.25];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    });
    [UIView animateWithDuration:0.25 animations:^{
        self.disBtn.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)showItemAnimation
{
    [self.btns enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        CGFloat x = btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        btn.frame = CGRectMake(x, [UIScreen mainScreen].bounds.size.height + y - self.frame.origin.y, width, height);
        btn.alpha = 0.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx * 0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseIn animations:^{
                btn.alpha = 1;
                btn.frame = CGRectMake(x, y, width, height);
            } completion:^(BOOL finished) {
                if ([btn isEqual:[self.btns lastObject]]) {
                    self.superview.superview.userInteractionEnabled = YES;
                }
            }];
        });
        
    }];
}

- (void)dismissItemAnimation
{
    [self.btns enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        CGFloat x = btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.btns.count - idx) * 0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
                btn.alpha = 0;
                btn.frame = CGRectMake(x, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y + y, width, height);
            } completion:^(BOOL finished) {
                if ([btn isEqual:[self.btns firstObject]]) {
                    self.superview.superview.userInteractionEnabled = YES;
                }
            }];
        });
        
    }];
    [self dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissItemAnimation];
//    [self dismiss];
}

- (void)didTouchBtn:(UIButton *)sender
{
    [sender scalingWithTime:.15 scale:1.2];
}

- (void)didClickBtn:(UIButton *)sender
{
    if (self.btnCanceled) {
        self.btnCanceled = NO;
        NSLog(@"return  return  return  return");
        
        return;
    }
    
    [self.btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (sender != obj) {
            [obj scalingWithTime:.25 scale:0.3];
            [obj fadeOutWithTime:.25];
        } else {
            [sender scalingWithTime:.25 scale:1];
            [sender scalingWithTime:.25 scale:1.5];
            [sender fadeOutWithTime:.25];
            //缩放动画
//            CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//            scale.fromValue = [NSNumber numberWithFloat:1.0f];
//            scale.toValue = [NSNumber numberWithFloat:1.7f];
//
//            CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"transform.opacity"];
//            opacity.fromValue = [NSNumber numberWithFloat:1.0f];
//            opacity.toValue = [NSNumber numberWithFloat:0.0f];
//
//            CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//            groupAnimation.
//            groupAnimation.animations = @[scale, opacity];
//            groupAnimation.duration = 0.25f;
//            [sender.layer addAnimation:groupAnimation forKey:@"groupAnimation"];

            
        }
    }];
    if (self.selectBlock) {
        self.selectBlock(self.items[sender.tag]);
    }
    [self dismiss];
}

- (void)didCancelBtn:(UIButton *)sender
{
    self.btnCanceled = YES;
    [sender scalingWithTime:0.25 scale:1];
}

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = ({

//            UIImageView *view = [[UIImageView alloc] init];
//            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
////            view.image = [UIImage imageWithView:self.superView];
//            view.backgroundColor = [UIColor whiteColor];
//
//            view;
            
            /*
            UIImage *blurredBackgroundImage = [UIImage qmui_imageWithView:self.superView];
            blurredBackgroundImage = [UIImageEffects imageByApplyingExtraLightEffectToImage:blurredBackgroundImage];
            */
            UIImage *blurredBackgroundImage = [UIImage imageWithView:self.superView];
            UIImageView *blurredDimmingView = [[UIImageView alloc] initWithImage:blurredBackgroundImage];
            blurredDimmingView;
//            UIImageView *view = [[UIImageView alloc] init];
//            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            view.image = [UIImage imageWithView:self.superView];
//
//            view;

        });
    }
    return _backgroundView;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            UIImage *image = UIImageMake(@"images.bundle/compose_slogan");
            view.frame = CGRectMake(0, 100, image.size.width, image.size.height);
            
            view;
        });
    }
    return _headerImageView;
}

- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = ({
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, self.frame.size.height * 0.65, self.frame.size.width, self.frame.size.height * 0.4);
            int i = 0;
            for (ATPopMenuItem *item in self.items) {
                ATCustomBtn *btn = [ATCustomBtn buttonWithType:UIButtonTypeCustom];
                [btn setImage:UIImageMake(item.icon) forState:UIControlStateNormal];
                [btn.imageView setContentMode:UIViewContentModeCenter];
                [btn setTitle:item.title forState:UIControlStateNormal];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:UIColorMakeWithHex(@"555555") forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15*pw];
                
                [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchDown];
                [btn addTarget:self action:@selector(didCancelBtn:) forControlEvents:UIControlEventTouchDragOutside];
                
                CGFloat x = (i % 4) * view.frame.size.width / 4.0;
                CGFloat y = (i / 4) * view.frame.size.height / 2.0;
                CGFloat width = view.frame.size.width / 4.0;
                CGFloat height = view.size.height / 2;
                
                btn.frame = CGRectMake(x, y, width, height);
                btn.tag = i++;
                [view addSubview:btn];
                [self.btns addObject:btn];
            }
            
            view;
        });
    }
    return _centerView;
}

- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = @[].mutableCopy;
    }
    return _btns;
}

- (UIButton *)disBtn
{
    if (!_disBtn) {
        _disBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake((SCREEN_WIDTH-35.5*pw)/2, SCREEN_HEIGHT-25*ph-35.5*pw, 35.5*pw, 35.5*pw);
            [btn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(dismissItemAnimation) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
    }
    return _disBtn;
}

@end
