//
//  ATStarView.m
//  DPCA
//
//  Created by AdminTest on 2018/1/5.
//  Copyright © 2018年 AdminTest. All rights reserved.
//

#import "ATStarView.h"

static NSString * const kStarImageStyleNormal = @"star_gray.png";
static NSString * const kStarImageStyleHighlight = @"star_yellow.png";

@interface ATStarView ()

@property (nonatomic, strong) UIView *upperView;
@property (nonatomic, strong) UIView *belowView;

@end


@implementation ATStarView

- (instancetype)initWithFrame:(CGRect)frame valueChangedBlock:(void(^)(CGFloat score))valueChangedBlock {
    self = [super init];
    if (self) {
        self.valueChangedBlock = valueChangedBlock;
        [self defaultSetting];
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultSetting];
        [self configureUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.currentScore > self.totalScore) {
        _currentScore = self.totalScore;
    }
    else if (self.currentScore < 0) {
        _currentScore = 0;
    }
    else {
        _currentScore = self.currentScore;
    }
    
    CGFloat scorePercent = self.currentScore / self.totalScore;
    if (self.isFullStarLimited == YES) {
        scorePercent = [self changeToCompleteStar:scorePercent];
    }
    
    self.upperView.frame = CGRectMake(0, 0, self.bounds.size.width * scorePercent, self.bounds.size.height);
}

#pragma mark - Private Methods
- (void)defaultSetting
{
    self.numberOfStars = 5;
    self.totalScore = self.numberOfStars;
    self.currentScore = 0;
    self.isTouchable = YES;
    self.isFullStarLimited = YES;

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}

- (void)configureUI
{
    self.belowView = [self createStarViewWithImageName:kStarImageStyleNormal];
    self.upperView = [self createStarViewWithImageName:kStarImageStyleHighlight];
    
    [self addSubview:self.belowView];
    [self addSubview:self.upperView];
}

- (UIView *)createStarViewWithImageName:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    
    for (NSInteger i = 0; i < self.numberOfStars; i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.image = [UIImage imageNamed:imageName];
        starImageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars,
                                         0,
                                         self.bounds.size.width / self.numberOfStars,
                                         self.bounds.size.height);
        starImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:starImageView];
    }
    return view;
}

- (CGFloat)changeToCompleteStar:(CGFloat)percent
{
    if (percent <= 0.2) {
        percent = 0.2;
    }
    else if (percent > 0.2 && percent <= 0.4) {
        percent = 0.4;
    }
    else if (percent > 0.4 && percent <= 0.6) {
        percent = 0.6;
    }
    else if (percent > 0.6 && percent <= 0.8) {
        percent = 0.8;
    }
    else {
        percent = 1.0;
    }
    return percent;
}

- (void)setCurrentScore:(CGFloat)currentScore
{
    if (_currentScore == currentScore) {
        return;
    }
    _currentScore = currentScore;
    
    [self setNeedsLayout];
}

#pragma mark - Event Response

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    CGFloat offset = point.x;
    CGFloat offsetPercent = offset/self.bounds.size.width;
    
    if (self.isFullStarLimited == YES) {
        offsetPercent = [self changeToCompleteStar:offsetPercent];
    }
    
    self.currentScore = offsetPercent * self.totalScore;
    
    if (self.valueChangedBlock) {
        self.valueChangedBlock(self.currentScore);
    }
}
@end
