//
//  ATSegmentedSectionView.m
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATSegmentedSectionView.h"

@implementation ATSegmentedSectionView

- (instancetype)initWithConfigModel:(id)configModel;
{
    self = [super init];
    if (self) {
        self.configModel = configModel;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    
}
@end


@implementation ATSegmentedSectionHeaderView

- (void)addSubviews
{
    self.backgroundColor = UIColorWhite;
    [self addSubview:self.separatorView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.stateLabel];
    [self configData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.separatorView.frame = CGRectMake(0, 0, self.width, 10);
    CGFloat h = self.height - 10;
    self.avatarImageView.frame = CGRectMake(10, (h - 32) / 2 + 10, 32, 32);
    self.nameLabel.frame = CGRectMake(self.avatarImageView.maxX + 12, (h - 30) / 2 + 10, 100, 30);
    self.stateLabel.frame = CGRectMake(self.width - 110, (h - 30) / 2 + 10, 100, 30);
}

- (void)configData
{
    /*
    ATSquareUserModel *user = [self.configModel.dataSource valueForKey:@"user"];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:UIImageMake(@"fs_icon")];
    self.nameLabel.text = user.nickname;
    self.stateLabel.text = self.configModel.orderStatusTitle;
     */
}

#pragma mark - Event Response

- (void)avatarImageViewClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ATSegmentedSectionHeaderView:didClickBtnWithData:)]) {
        [self.delegate ATSegmentedSectionHeaderView:self didClickBtnWithData:nil];
    }
}

- (UIView *)separatorView
{
    if (!_separatorView) {
        _separatorView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColorMakeWithHex(@"f0f0f0");
            view;
        });
    }
    return _separatorView;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 16;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewClick)];
            [view addGestureRecognizer:tap];
            
            view;
        });
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = UIFontMake(15);
            label.textColor = UIColorMakeWithHex(@"4f412c");
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = UIFontMake(13);
            label.textColor = UIColorMakeWithHex(@"fd9941");
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
    }
    return _stateLabel;
}

@end


static CGFloat kBtnHeight = 33;
static CGFloat kBtnWidth = 80;

@implementation ATSegmentedSectionFooterView

- (instancetype)initWithConfigModel:(id)configModel
{
    self = [super init];
    if (self) {
        self.configModel = configModel;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.backgroundColor = UIColorWhite;
    [self addSubview:self.separatorView];
    
//    [self.configModel.actionTitles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self addSubview:[self generateBtnWithTitle:obj tag:idx]];
//    }];
    [self addSubview:[self generateBtnWithTitle:self.configModel tag:0]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.separatorView.frame = CGRectMake(0, 0, self.width, .5);
    
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(self.width - (self.btnArray.count - idx) * 100, (self.height - kBtnHeight) / 2, kBtnWidth, kBtnHeight);
    }];
}

- (UIButton *)generateBtnWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorMakeWithHex(@"4f412c") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = UIFontMake(15);
    btn.tag = tag;
    btn.layer.borderColor = UIColorMakeWithHex(@"b5b5b5").CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [self.btnArray addObject:btn];
    
    return btn;
}

- (void)btnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ATSegmentedSectionFooterView:didClickBtnWithIndexPathSection:btnTitle:index:)]) {
        [self.delegate ATSegmentedSectionFooterView:self didClickBtnWithIndexPathSection:self.section btnTitle:sender.titleLabel.text index:sender.tag];
    }
}

- (void)configWithModel:(id)model
{
    
}

- (UIView *)separatorView
{
    if (!_separatorView) {
        _separatorView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColorMakeWithHex(@"f0f0f0");
            view;
        });
    }
    return _separatorView;
}

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
@end
