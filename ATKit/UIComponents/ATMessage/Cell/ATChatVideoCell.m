//
//  ATChatVideoCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatVideoCell.h"
#import "ATAVPlayer.h"

@interface ATChatVideoCell ()

@property (nonatomic, strong) UIButton *imageBtn;

@property (nonatomic, strong) ATAVPlayer *player;

@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *videoPath;

@end

@implementation ATChatVideoCell

- (void)addSubviews
{
    [super addSubviews];
    [self.contentView addSubview:self.imageBtn];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    [super configWithModel:vm];
    
    self.imageBtn.frame = vm.picViewF;
    self.bubbleView.image = nil;

    /*
    if (self.msg.coverTempPath) {
        UIImage *videoArrowImage = [[ATMediaManager sharedInstance] getArrowImageWithCoverImagePath:self.msg.coverTempPath size:self.vm.picViewF.size isSender:self.msg.isSender];
        [self.imageBtn setImage:videoArrowImage forState:UIControlStateNormal];
        self.bubbleView.userInteractionEnabled = YES;
    } else {
        [self.msg getLocalVideoCoverImagePath:^(NSString *path) {
            UIImage *videoArrowImage = [[ATMediaManager sharedInstance] getArrowImageWithCoverImagePath:path size:self.vm.picViewF.size isSender:self.msg.isSender];
            [self.imageBtn setImage:videoArrowImage forState:UIControlStateNormal];
            self.bubbleView.userInteractionEnabled = YES;
        } fail:^(int code, NSString *msg) {
            [self.imageBtn setImage:UIImageMake(@"fs_icon") forState:UIControlStateNormal];
            self.bubbleView.userInteractionEnabled = NO;
        }];
    }
     */
    
}

- (void)imageBtnClick:(UIButton *)btn
{
    /*
    [self.msg getLocalVideoPath:^(NSString *path) {
        [self videoPlay:path];
    } fail:^(int code, NSString *msg) {
        NSLog(@"%s , %d, %@", __func__, code, msg);
    }];
     */
}

- (void)videoPlay:(NSString *)path
{
    self.player = [[ATAVPlayer alloc] initWithFrame:WINDOW.bounds withShowInView:WINDOW url:[NSURL fileURLWithPath:path] animated:YES];
}

- (void)stopVideo
{
    if (self.player) {
        [self.player stopPlayer];
    }
}

#pragma mark - Getter
- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}

@end
