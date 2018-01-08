//
//  ATChatBaseCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatBaseCell.h"

@implementation ATChatBaseCell

- (instancetype)initWithType:(ATChatCellType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.cellType = type;
        
        [self initialize];
        [self addSubviews];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)addSubviews
{
    if (self.cellType == ATChatCellType_Group) {
        [self.contentView addSubview:self.nameLabel];
    }
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.retryButton];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    self.vm = vm;
    self.msg = vm.msg;
    
    self.headImageView.frame     = vm.headImageViewF;
    self.bubbleView.frame        = vm.bubbleViewF;
    self.nameLabel.frame         = vm.nameLabelF;
    
    //frame setting && data setting
    if (self.cellType == ATChatCellType_System) {
        self.headImageView.image = UIImageMake(@"2x");
        self.bubbleView.image = [UIImage imageNamed:@"liaotianbeijing1"];
    } else {
        [self configViewModel:vm];
    }
}

- (void)configViewModel:(ATChatViewModel *)vm
{
    if (vm.msg.isSender) {    // 发送者
        self.activityView.frame  = vm.activityF;
        self.retryButton.frame   = vm.retryButtonF;
        
        switch (vm.msg.deliveryState) { // 发送状态
            case ATMessageDeliveryState_Delivering:
            {
                [self.activityView setHidden:NO];
                [self.retryButton setHidden:YES];
                [self.activityView startAnimating];
            }
                break;
            case ATMessageDeliveryState_Delivered:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:YES];
                
            }
                break;
            case ATMessageDeliveryState_Failure:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        
        self.headImageView.image = UIImageMake(@"");
        
        if (vm.msg.msgType == ATMessageType_File) {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianfile"];
        } else {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianbeijing2"];
        }
        
    } else {    // 接收者
        self.retryButton.hidden  = YES;
        self.bubbleView.image    = [UIImage imageNamed:@"liaotianbeijing1"];
        
        /*
        if (self.cellType == ATChatCellType_Group) {
         
            [[ATContactManager sharedInstance] getSingleUserWithUserID:vm.msg.sender succ:^(ATUser *user) {
                self.nameLabel.text = user.nickname;
                [self.headImageView seageWithURL:[NSURL URLWithString:user.faceURL] placeholderImage:UIImageMake(@"fs_icon")];
            } fail:^(int code, NSString *msg) {
                self.nameLabel.text = msg;
                [self.headImageView seage:UIImageMake(@"fs_icon")];
            }];
            
        } else {
             [[ATContactManager sharedInstance] getSingleUserWithUserID:vm.msg.sender succ:^(ATUser *user) {
                 [self.headImageView seageWithURL:[NSURL URLWithString:user.faceURL] placeholderImage:UIImageMake(@"fs_icon")];
             } fail:^(int code, NSString *msg) {
                 
             }];
        }
         */
    }
}

- (NSArray *)showMenuItems
{
    NSMutableArray *array = [NSMutableArray array];
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    [array addObject:copyItem];
    
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    [array addObject:deleteItem];
    
    UIMenuItem *transItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transMessage:)];
    [array addObject:transItem];
    
    if (self.msg.isSender) {//五分钟之内可以撤回
        NSInteger minitesPast = [NSDate minitesOffsetBetweenStartDate:self.msg.timestamp endDate:[NSDate date]];
        if (minitesPast < 5 && (self.msg.deliveryState != ATMessageDeliveryState_Failure)) {
            UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeMessage:)];
            [array addObject:revokeItem];
        }
    }
    
    return array;
}

- (void)copyMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellCopyMessage:)]) {
        [self.delegate chatCellCopyMessage:self];
    }
}

- (void)revokeMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellRevokeMessage:)]) {
        [self.delegate chatCellRevokeMessage:self];
    }
}

- (void)deleteMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDeleteMessage:)]) {
        [self.delegate chatCellDeleteMessage:self];
    }
}

- (void)transMessage:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellTransMessage:)]) {
        [self.delegate chatCellTransMessage:self];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL can = ((action == @selector(copyMessage:)) || (action == @selector(deleteMessage:)) || (action == @selector(revokeMessage:)) || (action == @selector(transMessage:)));
    return can;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Getter and Setter

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorMake(180, 178, 178);
            label.font = UIFontMake(13);
            label.backgroundColor = UIColorClear;
            
            label;
        });
    }
    return _nameLabel;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = ATChatCellHeaderSize / 2;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
        [_headImageView addGestureRecognizer:tapGes];
    }
    return _headImageView;
}

- (UIImageView *)bubbleView {
    if (_bubbleView == nil) {
        _bubbleView = [[UIImageView alloc] init];
        _bubbleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_bubbleView addGestureRecognizer:tap];

        //长按手势不加在气泡view上的原因是，当为表情富文本 或者图片的时候 由于设计原因 不容易响应longpess事件 因此加在tableview身上， 这样做解决在任何cell上面长按都能响应longress事件，导致的问题是 长按的locationview 没落在气泡里的话， 一直按的时候无法滑动tableview，暂不影响，用户不容易触发，偶现
//        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//        longRecognizer.minimumPressDuration = 0.5;
//        [_bubbleView addGestureRecognizer:longRecognizer];
//        
//        [tap requireGestureRecognizerToFail:longRecognizer];   // Priority long
    }
    return _bubbleView;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        [_retryButton setImage:[UIImage imageNamed:@"button_retry_comment"] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

#pragma mark - Respond Method

- (void)retryButtonClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(chatCellReSendMessage:)]) {
        [self.delegate chatCellReSendMessage:self];
    }
}

- (void)headClicked
{
    if ([self.delegate respondsToSelector:@selector(chatCellHeadImageClicked:)]) {
        [self.delegate chatCellHeadImageClicked:self.vm.msg.sender];
    }
}

- (void)tapAction:(UIGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(chatCellClicked:)]) {
        [self.delegate chatCellClicked:self];
    }
}

- (void)longPress:(UIGestureRecognizer *)sender
{
    if (![UIMenuController sharedMenuController].isMenuVisible) {
        [self showMenu];
    }
}

- (void)showMenu
{
    NSArray *showMenus = [self showMenuItems];
    if (showMenus.count)
    {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:showMenus];
        [menu setTargetRect:self.bubbleView.frame inView:self.contentView];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canShowMenuOnTouchOf:(UIGestureRecognizer *)ges
{
    CGPoint p = [ges locationInView:self.bubbleView];
    BOOL contain = CGRectContainsPoint(self.bubbleView.bounds, p);
    
    return contain;
}

@end
