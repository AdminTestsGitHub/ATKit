//
//  ATChatBaseCell.h
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatViewModel.h"

@class ATMessage;
@class ATConversation;
@protocol ATChatBaseCellDelegate;


@interface ATChatBaseCell : QMUITableViewCell

//单聊还是群聊
@property (nonatomic, assign) ATChatCellType cellType;

// 消息模型
@property (nonatomic, strong) ATChatViewModel *vm;

//消息
@property (nonatomic, strong) ATMessage *msg;

// 头像
@property (nonatomic, strong) UIImageView *headImageView;

//名字
@property (nonatomic, strong) UILabel *nameLabel;

// 内容气泡视图
@property (nonatomic, strong) UIImageView *bubbleView;
// 菊花视图所在的view
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 重新发送
@property (nonatomic, strong) UIButton *retryButton;

@property (nonatomic, weak) id<ATChatBaseCellDelegate> delegate;

- (instancetype)initWithType:(ATChatCellType)type reuseIdentifier:(NSString *)reuseIdentifier;

- (void)addSubviews;

- (void)configWithModel:(ATChatViewModel *)vm;
- (BOOL)canShowMenuOnTouchOf:(UIGestureRecognizer *)ges;
- (void)showMenu;

@end


@protocol ATChatBaseCellDelegate <NSObject>

@optional

- (void)chatCellClicked:(ATChatBaseCell *)cell;
- (void)chatCellHeadImageClicked:(NSString *)userID;

- (void)chatCellReSendMessage:(ATChatBaseCell *)baseCell;
- (void)chatCellCopyMessage:(ATChatBaseCell *)baseCell;
- (void)chatCellDeleteMessage:(ATChatBaseCell *)baseCell;
- (void)chatCellRevokeMessage:(ATChatBaseCell *)baseCell;
- (void)chatCellTransMessage:(ATChatBaseCell *)baseCell;
@end


