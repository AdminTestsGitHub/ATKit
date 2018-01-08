//
//  ATSegmentedHeaderView.m
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATSegmentedHeaderView.h"

@interface ATSegmentedHeaderView ()

@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleBtns;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) CGFloat btnMargin;
@property (nonatomic, strong) NSMutableArray *redIndexs;
@property (nonatomic, strong) NSMutableArray<UIView *> *redDotViews;

@end

@implementation ATSegmentedHeaderView

- (instancetype)initWithTitles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        self.titles = titles;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    [self addSubview:self.bottomImageView];
    CGFloat margin = SCREEN_WIDTH;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [self generateBtnWithTitle:self.titles[i]];
        [self addSubview:btn];
        [self.titleBtns addObject:btn];
        margin -= btn.width;
        
        UIView *redDotView = [self generateRedDotView];
        [self addSubview:redDotView];
        [self.redDotViews addObject:redDotView];
        
        [self.redIndexs addObject:@(0)];
    }
    self.btnMargin = margin / (self.titles.count + 1);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    __block CGFloat x = self.btnMargin;
    
    self.previousButton.selected = YES;
    
    ATWeak;
    [self.titleBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(x, (weakSelf.height - 44) / 2, obj.width, 44);
        weakSelf.redDotViews[idx].frame = CGRectMake(obj.maxX, 8, 9, 9);
        x += (obj.width + weakSelf.btnMargin);
    }];
    
    self.bottomImageView.frame = CGRectMake(CGRectGetMinX(self.previousButton.frame), self.frame.size.height - 2, self.previousButton.frame.size.width, 2);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!self.previousButton) {
        [self setDefaultIndex:0];
    }
}

- (NSArray *)getAllTitleBtns
{
    return [self.titleBtns copy];
}

- (void)changeSelectedItem:(id)sender
{
    UIButton *btn = sender;
    [self updateBtnAnimated:btn];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ATSegmentedView:didSelectItemWithTitle:index:)]) {
        [self.delegate ATSegmentedView:self didSelectItemWithTitle:btn.titleLabel.text index:self.currentIndex];
    }
}

- (void)setDefaultIndex:(int)idx
{
    self.currentIndex = idx;
    self.previousButton = self.titleBtns[idx];
}

- (void)scrollItemToIndex:(int)idx
{
    self.currentIndex = idx;
    [self updateBtnAnimated:self.titleBtns[idx]];
}

- (void)setRedInIdex:(NSArray *)idxs
{
    [self.redDotViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = ![idxs[idx] boolValue];
    }];
}

- (void)updateBtnAnimated:(UIButton *)btn
{
    self.previousButton.selected = NO;
    btn.selected = YES;
    self.previousButton = btn;
    self.currentIndex = (int)[self.titleBtns indexOfObject:btn];
    
    ATWeak;
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.bottomImageView.frame = CGRectMake(CGRectGetMinX(btn.frame), weakSelf.frame.size.height - 2, btn.frame.size.width, 2);
    }];
}

- (UIButton *)generateBtnWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorMakeWithHex(@"999999") forState:UIControlStateNormal];
    [btn setTitleColor:UIColorMakeWithHex(@"4f412c") forState:UIControlStateSelected];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(changeSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    return btn;
}

- (UIView *)generateRedDotView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorRed;
    view.layer.cornerRadius = 4.5;
    view.hidden = YES;
    return view;
}

- (QMUILabel *)generateOrderNumberLabelWithInteger:(NSInteger)integer inView:(UIView *)view
{
    NSInteger labelTag = 1024;
    QMUILabel *numberLabel = [view viewWithTag:labelTag];
    if (!numberLabel) {
        numberLabel = [[QMUILabel alloc] initWithFont:UIFontBoldMake(2) textColor:UIColorWhite];
        numberLabel.backgroundColor = UIColorRed;
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
        numberLabel.clipsToBounds = YES;
        numberLabel.tag = labelTag;
        [view addSubview:numberLabel];
    }
    numberLabel.text = @"";//[NSString qmui_stringWithNSInteger:integer];
    [numberLabel sizeToFit];
    if (numberLabel.text.length == 1) {
        // 一位数字时，保证宽高相等（因为有些字符可能宽度比较窄）
        CGFloat diameter = fmaxf(CGRectGetWidth(numberLabel.bounds), CGRectGetHeight(numberLabel.bounds));
        numberLabel.frame = CGRectMake(CGRectGetMinX(numberLabel.frame), CGRectGetMinY(numberLabel.frame), diameter, diameter);
    }
    numberLabel.layer.cornerRadius = flat(CGRectGetHeight(numberLabel.bounds) / 2.0);
    return numberLabel;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            //            view.image = UIImageMake(@"");
            view.backgroundColor = UIColorMakeWithHex(@"fd9941");
            view;
        });
    }
    return _bottomImageView;
}

- (NSMutableArray *)titleBtns
{
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

- (NSMutableArray *)redDotViews
{
    if (!_redDotViews) {
        _redDotViews = [NSMutableArray array];
    }
    return _redDotViews;
}

- (NSMutableArray *)redIndexs
{
    if (_redIndexs) {
        _redIndexs = [NSMutableArray array];
    }
    return _redIndexs;
}

- (void)setCurrentIndex:(int)currentIndex
{
    _currentIndex = currentIndex;
    self.redIndexs[currentIndex] = @(0);
    self.redDotViews[currentIndex].hidden = YES;
}

@end
