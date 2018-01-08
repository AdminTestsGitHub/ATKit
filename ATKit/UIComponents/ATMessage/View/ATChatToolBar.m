//
//  ATChatToolBar.m
//  MiLin
//
//  Created by AdminTest on 2017/8/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatToolBar.h"
#import "ATRecordHUD.h"
#import "ATProgressHUD.h"
#import "ATAudioManager.h"

@interface ATChatToolBar () <UITextViewDelegate, ATAudioManagerDelegate>

@property (nonatomic, strong) NSArray *btnArray;
@property (nonatomic, strong) ATRecordHUD *recordHUD;
@property (strong, nonatomic) ATAudioManager *mgr;

@end


@implementation ATChatToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        [self addSubviews];
    }
    return self;
}

- (void)initialize
{
    self.mgr = [[ATAudioManager alloc] initWithDelegate:self];
    [self setBackgroundColor:UIColorMake(241, 241, 248)];
    self.status = ATChatToolBarStatus_Input;
    self.btnArray = @[self.voiceButton, self.faceButton, self.moreButton];
}

- (void)addSubviews
{
//    [self addSubview:self.topLine];
    [self addSubview:self.voiceButton];
    [self addSubview:self.textView];
    [self addSubview:self.faceButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.talkButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.status = ATChatToolBarStatus_Input;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 1000) { // 限制1000字内
        textView.text = [textView.text substringToIndex:1000];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self sendMessage];
        return NO;
    }
    return YES;
}

#pragma mark - ATAudioManagerDelegate

- (void)audioRecorderDidFinishRecording:(NSString *)path
{
    if (path) {
        [ATProgressHUD dismissWithProgressState:ATProgressHUDStateSuccess];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ATChatToolBar:sendAudioMessage:second:)]) {
            [self.delegate ATChatToolBar:self sendAudioMessage:path second:[ATProgressHUD seconds]];
        }
    } else {
        [ATProgressHUD dismissWithProgressState:ATProgressHUDStateError];
    }
}

#pragma mark - Private
- (void)sendMessage
{
    if (self.textView.text.length > 0) {     // send Text
        
        if (_delegate && [_delegate respondsToSelector:@selector(ATChatToolBar:sendTextMessage:)]) {
            [_delegate ATChatToolBar:self sendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
}


#pragma mark - Event Response
//FIXME:按钮点击事件 同一个状态只有一个按钮可以为被选状态
- (void)buttonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    BOOL selected = sender.selected;
    
    if (selected) {
        
        //更改状态
        self.status = sender.tag;
        [self.textView resignFirstResponder];
        
        //只有一个按钮可以同时被选中 改变其他按钮为非选中
        [self.btnArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != sender.tag - 1) {
                obj.selected = NO;
            }
        }];

        //通知代理开始各种键盘动画
        if (self.delegate && [self.delegate respondsToSelector:@selector(ATChatToolBar:buttonDidClickWithAction:)]) {
            [self.delegate ATChatToolBar:self buttonDidClickWithAction:sender.tag];
        }
    } else {
        self.status = ATChatToolBarStatus_Input;
        [self.textView becomeFirstResponder];
    }
    
    self.talkButton.hidden = !(sender.tag == ATChatToolBarStatus_Voice && selected);
    self.textView.hidden = !self.talkButton.hidden;
}


/**
 *  开始录音
 */
- (void)startRecordVoice {
    [ATProgressHUD show];
    self.talkButton.highlighted = YES;
    [self.mgr startRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [ATProgressHUD dismissWithMessage:@"取消录音"];
    self.talkButton.highlighted = NO;
    [self.mgr cancelRecord];
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    [self.mgr stopRecord];
}

/**
 *  更新录音显示状态,手指向上滑动后提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [ATProgressHUD changeSubTitle:@"松开取消录音"];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [ATProgressHUD changeSubTitle:@"向上滑动取消录音"];
}

#pragma mark - Getter and Setter
- (UIView *)topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        [_topLine setBackgroundColor:UIColorMake(165, 165, 165)];
    }
    return _topLine;
}

- (UIButton *)voiceButton
{
    if (_voiceButton == nil) {
        _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (ATChatToolBarHeight - ATChatToolBarBtnSize) / 2, ATChatToolBarBtnSize, ATChatToolBarBtnSize)];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [_voiceButton setImage:UIImageMake(@"ToolViewKeyboard") forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton sizeToFit];
        _voiceButton.tag = ATChatToolBarStatus_Voice;
    }
    return _voiceButton;
}

- (UIButton *)moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ATChatToolBarBtnSize, (ATChatToolBarHeight - ATChatToolBarBtnSize) / 2, ATChatToolBarBtnSize, ATChatToolBarBtnSize)];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.tag = ATChatToolBarStatus_More;
    }
    return _moreButton;
}

- (UIButton *) faceButton
{
    if (_faceButton == nil) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.moreButton.x - ATChatToolBarBtnSize, (ATChatToolBarHeight - ATChatToolBarBtnSize) / 2, ATChatToolBarBtnSize, ATChatToolBarBtnSize)];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton setImage:UIImageMake(@"ToolViewKeyboard") forState:UIControlStateSelected];
        _faceButton.tag = ATChatToolBarStatus_Face;
    }
    return _faceButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(self.voiceButton.maxX + 4, (ATChatToolBarHeight - ATChatToolBarInputHeight) / 2, self.faceButton.x - self.voiceButton.maxX - 8, ATChatToolBarInputHeight);
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 4.0f;
        _textView.backgroundColor = UIColorMakeWithHex(@"FFFFFF");
        _textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = .5f;
        _textView.layer.masksToBounds = YES;
        _textView.scrollsToTop = NO;
    }
    return _textView;
}

- (QMUIButton *)talkButton
{
    if (_talkButton == nil) {
        _talkButton = [[QMUIButton alloc] init];
        _talkButton.hidden = YES;
        _talkButton.frame = self.textView.frame;
        [_talkButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _talkButton.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _talkButton.layer.borderWidth = 1;
        _talkButton.layer.masksToBounds = YES;
        _talkButton.layer.cornerRadius = 4.0f;
        _talkButton.backgroundColor = UIColorMake(241, 241, 248);
        _talkButton.highlightedBackgroundColor = UIColorGray;
        _talkButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_talkButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
        [_talkButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
        [_talkButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
        [_talkButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
        [_talkButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
        [_talkButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    }
    return _talkButton;
}

- (ATRecordHUD *)recordHUD
{
    if (!_recordHUD) {
        _recordHUD = [[ATRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        _recordHUD.hidden = YES;
        _recordHUD.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        [WINDOW addSubview:_recordHUD];
    }
    return _recordHUD;
}

@end
