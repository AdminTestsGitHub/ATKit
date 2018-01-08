//
//  ATConversationListCell.m
//  MiLin
//
//  Created by AdminTest on 2017/7/26.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATConversationListCell.h"
#import "ATConversationListModel.h"
#import "YYLabel.h"

static const CGFloat topPadding = 8;
static const CGFloat leftPadding = 9;

@interface ATConversationListCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) QMUILabel *usernameLabel;
@property (nonatomic, strong) QMUILabel *dateLabel;
@property (nonatomic, strong) YYLabel *messageLabel;
@property (nonatomic, strong) QMUILabel *unreadLabel;


@end

@implementation ATConversationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self avatarImageView];
        [self usernameLabel];
        [self dateLabel];
        [self messageLabel];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = [NSString stringWithFormat:@"%@cellID", NSStringFromClass(self.class)];
    ATConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ATConversationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configWithConversation:(ATTIMConversation *)conv
{
/*
    if (conv.conversationType == TIM_C2C) {
        [[ATTIMContactManager sharedInstance] getSingleTIMUserWithUserID:conv.receiverID succ:^(ATTIMUser *user) {
            [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.faceURL]];
            self.usernameLabel.text = user.nickname;
        } fail:^(int code, NSString *msg) {
            self.usernameLabel.text = msg;
        }];
    } else if (conv.conversationType == TIM_GROUP) {
        [[ATTIMContactManager sharedInstance] getSingleGroupProfileWithGroupID:conv.receiverID succ:^(ATTIMGroup *group) {
            [self.avatarImageView setImageWithURL:[NSURL URLWithString:group.faceURL]];
            self.usernameLabel.text = group.groupName;
        } fail:^(int code, NSString *msg) {
            self.usernameLabel.text = msg;
        }];
    } else if (conv.conversationType == TIM_SYSTEM) {
        self.avatarImageView.image = [UIImage imageNamed:@"2x"];
        self.usernameLabel.text = @"咪邻系统消息";
    }
    
    NSAttributedString *text = [ATFaceManager transferMessageString:conv.lastMsg.content color:UIColorMake(180, 178, 178) font:ATChatFont];

    self.messageLabel.attributedText = text;
    self.dateLabel.text = conv.lastMsg.timestampStr;
    self.unreadLabel = [self generateUnreadLabelWithInteger:conv.unReadCount inView:self];
 */
}

- (QMUILabel *)generateUnreadLabelWithInteger:(NSInteger)integer inView:(UIView *)view
{
    NSInteger labelTag = 1024;
    QMUILabel *numberLabel = [view viewWithTag:labelTag];
    if (!numberLabel) {
        numberLabel = [[QMUILabel alloc] initWithFont:UIFontBoldMake(12) textColor:UIColorWhite];
        numberLabel.backgroundColor = UIColorRed;
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
        numberLabel.clipsToBounds = YES;
        numberLabel.tag = labelTag;
        [view addSubview:numberLabel];
    }
    numberLabel.text = [NSString qmui_stringWithNSInteger:integer];
    [numberLabel sizeToFit];
    if (numberLabel.text.length == 1) {
        // 一位数字时，保证宽高相等（因为有些字符可能宽度比较窄）
        CGFloat diameter = fmaxf(CGRectGetWidth(numberLabel.bounds), CGRectGetHeight(numberLabel.bounds));
        numberLabel.frame = CGRectMake(CGRectGetMinX(numberLabel.frame), CGRectGetMinY(numberLabel.frame), diameter, diameter);
    }
    numberLabel.layer.cornerRadius = flat(CGRectGetHeight(numberLabel.bounds) / 2.0);
    return numberLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageWidth = self.height - topPadding * 2;
    
    self.avatarImageView.frame = CGRectMake(leftPadding, topPadding, imageWidth, imageWidth);
    self.usernameLabel.frame = CGRectMake(self.avatarImageView.maxX + 8, topPadding + 2, self.width - self.avatarImageView.maxX - 8 - 100, 25);
    self.messageLabel.frame = CGRectMake(self.usernameLabel.minX, self.usernameLabel.maxY, self.usernameLabel.width + 100, 25);
    self.dateLabel.frame = CGRectMake(self.width - 100, topPadding, 90, 22);
    self.unreadLabel.frame = CGRectSetXY(self.unreadLabel.frame, self.width - self.unreadLabel.width - 9, _messageLabel.minY);
}


#pragma mark - Getter and Setter

- (UIView *)avatarImageView
{
    if (_avatarImageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        _avatarImageView = imageV;
    }
    return _avatarImageView;
}

- (QMUILabel *)usernameLabel
{
    if (_usernameLabel == nil) {
        QMUILabel *label = [[QMUILabel alloc] init];
        [self.contentView addSubview:label];
        _usernameLabel.font = [UIFont systemFontOfSize:17.0];
        _usernameLabel = label;
    }
    return _usernameLabel;
}

- (QMUILabel *)dateLabel
{
    if (_dateLabel == nil) {
        QMUILabel *label = [[QMUILabel alloc] init];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:UIColorMakeWithHex(@"adadad")];
        label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:label];
        _dateLabel = label;
    }
    return _dateLabel;
}

- (YYLabel *)messageLabel
{
    if (_messageLabel == nil) {
        YYLabel *label = [[YYLabel alloc] init];
        [label setTextColor:UIColorMakeWithHex(@"9a9a9a")];
        label.font = ATChatFont;
        [self.contentView addSubview:label];
        _messageLabel = label;
    }
    return _messageLabel;
}


@end
