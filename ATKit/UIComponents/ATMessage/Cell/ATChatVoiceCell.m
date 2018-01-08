//
//  ATChatVoiceCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatVoiceCell.h"

@interface ATChatVoiceCell () <ATAudioManagerDelegate>

//@property (nonatomic, strong) UIButton    *voiceButton;
@property (nonatomic, strong) UILabel     *durationLabel;
@property (nonatomic, strong) UIImageView *voiceIcon;
@property (nonatomic, strong) UIView      *redView;
@property (nonatomic, strong) ATAudioManager *mgr;

@end

@implementation ATChatVoiceCell

- (void)addSubviews
{
    [super addSubviews];
    [self.contentView addSubview:self.voiceIcon];
    [self.contentView addSubview:self.durationLabel];
//    [self.contentView addSubview:self.voiceButton];
    [self.contentView addSubview:self.redView];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    [super configWithModel:vm];
    /*
    self.durationLabel.text = [NSString stringWithFormat:@"%d''", vm.msg.mediaDuration];
    if (vm.msg.isSender) {  // sender
        self.voiceIcon.image = [UIImage imageNamed:@"right-3"];
        UIImage *image1 = [UIImage imageNamed:@"right-1"];
        UIImage *image2 = [UIImage imageNamed:@"right-2"];
        UIImage *image3 = [UIImage imageNamed:@"right-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    } else {                          // receive
        self.voiceIcon.image = [UIImage imageNamed:@"left-3"];
        UIImage *image1 = [UIImage imageNamed:@"left-1"];
        UIImage *image2 = [UIImage imageNamed:@"left-2"];
        UIImage *image3 = [UIImage imageNamed:@"left-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    }
    self.voiceIcon.animationDuration = 0.8;
    if (vm.msg.status == ATTIMMessageStatus_read) {
        self.redView.hidden  = YES;
    } else if (vm.msg.status == ATTIMMessageStatus_unRead) {
        self.redView.hidden  = NO;
    }
     */
    self.durationLabel.frame = vm.durationLabelF;
    self.voiceIcon.frame     = vm.voiceIconF;
    self.bubbleView.frame   = vm.bubbleViewF;
    self.redView.frame       = vm.redViewF;
    
}

- (void)startPaly
{
//    [self getVoicePathAndPlay];
}

- (void)stopPlay
{
    [self.mgr stopPlay];
    [self.voiceIcon stopAnimating];
}
/*
- (void)getVoicePathAndPlay
{
    // 文件路径
    if (ATStringIsEmpty(self.msg.sendMediaPath)) {
        [self.msg getLocalAudioPath:^(NSString *path) {
            [self paly:path];
        } fail:^(int code, NSString *msg) {
            
        }];
    } else {
        [self paly:self.msg.sendMediaPath];
    }
}

- (void)paly:(NSString *)voicePath
{
    self.mgr = [[ATAudioManager alloc] initWithDelegate:self];
    
    if (self.vm.msg.status == ATTIMMessageStatus_unRead){
        self.vm.msg.status = ATTIMMessageStatus_read;
        self.redView.hidden = YES;
    }
    [self.voiceIcon startAnimating];
    [self.mgr startPlay:voicePath];
}
*/
- (void)audioPlayerDidFinishPlaying
{
    [self.voiceIcon stopAnimating];
}

#pragma mark - Getter

//- (UIButton *)voiceButton
//{
//    if (nil == _voiceButton) {
//        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    }
//    return _voiceButton;
//}

- (UILabel *)durationLabel
{
    if (nil == _durationLabel ) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = ATChatMessageFont;
    }
    return _durationLabel;
}

- (UIImageView *)voiceIcon
{
    if (nil == _voiceIcon) {
        _voiceIcon = [[UIImageView alloc] init];
    }
    return _voiceIcon;
}

- (UIView *)redView
{
    if (nil == _redView) {
        _redView = [[UIView alloc] init];
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = 4;
        _redView.backgroundColor = UIColorRed;
    }
    return _redView;
}

@end
