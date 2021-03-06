//
//  ATCalendarHeaderView.m
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCalendarHeaderView.h"
#import "ATCalendarHelper.h"

@interface ATCalendarHeaderView()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *titleButton;

@end

@implementation ATCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor colorWithRed:127.0/255.0 green:143.0/255.0 blue:164.0/255.0 alpha:1];
    
    [self addSubview: self.leftBtn];
    [self addSubview: self.titleButton];
    [self addSubview: self.rightBtn];
    
    __weak typeof(self) weakSelf = self;
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        make.left.equalTo(@15);
        make.centerY.equalTo(strongSelf.mas_centerY);
        make.height.equalTo(strongSelf.mas_height);
        make.width.equalTo(strongSelf.mas_height);
    }];
    
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.mas_centerX);
        make.centerY.equalTo(strongSelf.mas_centerY);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        make.trailing.equalTo(@-15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.equalTo(strongSelf.mas_height);
        make.width.equalTo(strongSelf.mas_height);
    }];
}

- (void)leftBtnDidClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(header:didClickLeftBtn:)]) {
        [self.delegate header:self didClickLeftBtn:button];
    }
}

- (void)rightBtnDidClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(header:didClickRightBtn:)]) {
        [self.delegate header:self didClickRightBtn:button];
    }
}


- (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName
{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"ATCalendarPicker.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *img_path = [bundle pathForResource:imgName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:img_path];
}

- (void)verifyBeginAndEnd
{
    if ([self.title isEqualToString:self.beginYearMonth]) {
        self.leftBtn.enabled = NO;
    } else {
        self.leftBtn.enabled = YES;
    }
    
    if ([self.title isEqualToString:self.endYearMonth]) {
        self.rightBtn.enabled = NO;
    } else {
        self.rightBtn.enabled = YES;
    }
}

#pragma mark - setter & getter

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage: [self imagesNamedFromCustomBundle:@"ic_lastday"] forState:UIControlStateNormal];
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 30, 30);
        [_leftBtn addTarget:self action:@selector(leftBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage: [self imagesNamedFromCustomBundle:@"ic_nextday"] forState:UIControlStateNormal];
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 0);
        [_rightBtn addTarget:self action:@selector(rightBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _titleButton;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    // 格式化显示日期
    NSArray *dates = [title componentsSeparatedByString:@"-"];
    [self.titleButton setTitle:[NSString stringWithFormat:@"%@年 - %@月",dates.firstObject,dates.lastObject] forState:UIControlStateNormal];
    
    // 验证开始时间和结束时间
    [self verifyBeginAndEnd];
}

- (void)setBeginYearMonth:(NSString *)beginYearMonth
{
    _beginYearMonth = beginYearMonth;
    
    // 验证开始时间和结束时间
    [self verifyBeginAndEnd];
}

- (void)setEndYearMonth:(NSString *)endYearMonth
{
    _endYearMonth = endYearMonth;
    
    // 验证开始时间和结束时间
    [self verifyBeginAndEnd];
}

@end
