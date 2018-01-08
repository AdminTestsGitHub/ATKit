//
//  ATStaticTableViewCell.m
//  DPCA
//
//  Created by AdminTest on 2017/12/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATStaticTableViewCell.h"

static CGFloat kPadding = 15;
static CGFloat kMargin = 15;
static CGFloat kLineHeight = 0.5;

@implementation ATStaticTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID =  @"ATStaticTableViewCell";
    ATStaticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ATStaticTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self didInitialized];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setLeftContentLayout];
    [self setLineLayout];
}

- (void)didInitialized
{
    self.topLine.hidden = YES;
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    
//    [self addSubview:self.topLine];
//    [self addSubview:self.bottomLine];
}

- (void)setLeftContentLayout
{
    if (self.data.iconImage) {
        CGFloat iconSize = CGSizeEqualToSize(self.data.iconSize, CGSizeZero) ? 35  : self.self.data.iconSize.width;
        self.iconImageView.frame = CGRectMake(kPadding, (self.frame.size.height - iconSize) / 2, iconSize, iconSize);
    }
    
    if (self.data.title) {
        [self.titleLabel sizeToFit];
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + kMargin, (self.frame.size.height - self.titleLabel.frame.size.height) / 2, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    }
    
    if (self.data.subTitle) {
        [self.subTitleLabel sizeToFit];
        self.subTitleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxX(self.titleLabel.frame) + kMargin, self.subTitleLabel.frame.size.width, self.subTitleLabel.frame.size.height);
    }
}

- (void)setLineLayout
{
    self.topLine.frame = CGRectMake(0, 0, self.frame.size.width, kLineHeight);
    if (self.data.iconImage) {
        self.bottomLine.frame = CGRectMake(kPadding, self.frame.size.height - kLineHeight, self.frame.size.width - kPadding, kLineHeight);
    } else {
        self.bottomLine.frame = CGRectMake(0, self.frame.size.height - kLineHeight, self.frame.size.width, kLineHeight);
    }
    
    if (self.data.isCustomLineLeft) {
        self.bottomLine.frame = CGRectMake(self.data.bottomLeftMargin, self.frame.size.height - kLineHeight, self.frame.size.width - self.data.bottomRightMargin, kLineHeight);
    }
}

#pragma mark - Getters And Setters
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
    }
    return _subTitleLabel;
}

- (UISwitch *)indicatorSwitch
{
    if (!_indicatorSwitch) {
        _indicatorSwitch = [[UISwitch alloc] init];
    }
    return _indicatorSwitch;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor redColor];
    }
    return _textField;
}

- (UIView *)customView
{
    if (!_customView) {
        _customView = [[UIView alloc] init];
    }
    return _customView;
}

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor redColor];
    }
    return _topLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor blueColor];
    }
    return _bottomLine;
}

- (UIView *)defaultAccessoryView
{
    if (!_defaultAccessoryView) {
        _defaultAccessoryView = [[UIView alloc] init];
    }
    return _defaultAccessoryView;
}

- (UIImageView *)defaultAccessoryDisclosureIndicatorImageView
{
    if (!_defaultAccessoryDisclosureIndicatorImageView) {
        _defaultAccessoryDisclosureIndicatorImageView = [[UIImageView alloc] init];
        _defaultAccessoryDisclosureIndicatorImageView.contentMode = UIViewContentModeCenter;
        _defaultAccessoryDisclosureIndicatorImageView.image = TableViewCellDisclosureIndicatorImage;
        [_defaultAccessoryDisclosureIndicatorImageView sizeToFit];
    }
    return _defaultAccessoryDisclosureIndicatorImageView;
}

- (UIImageView *)defaultAccessoryImageView
{
    if (!_defaultAccessoryImageView) {
        _defaultAccessoryImageView = [[UIImageView alloc] init];
    }
    return _defaultAccessoryImageView;
}

- (UILabel *)defaultAccessoryTitleLabel
{
    if (!_defaultAccessoryTitleLabel) {
        _defaultAccessoryTitleLabel = [[UILabel alloc] init];
    }
    return _defaultAccessoryTitleLabel;
}


@end
