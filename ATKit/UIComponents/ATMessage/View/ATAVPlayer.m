//
//  ATAVPlayer.m
//  MiLin
//
//  Created by AdminTest on 2017/8/17.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ATAVPlayer ()

@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic, strong) UIButton *closeBtn;


@end

@implementation ATAVPlayer

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url animated:(BOOL)animated
{
    if (self = [self initWithFrame:frame]) {
        //创建播放器层
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = self.bounds;
        
        [self.layer addSublayer:playerLayer];
        if (url) {
            self.videoUrl = url;
        }

        [bgView addSubview:self];
        
        if (animated) {
            self.alpha = 0;
            CGFloat height = bgView.size.height * SCREEN_WIDTH / bgView.size.width;
            [UIView animateWithDuration:.5 animations:^{
                self.frame = CGRectMake(0, SCREEN_HEIGHT / 2 - height / 2, SCREEN_WIDTH, height);
                self.alpha = 1;
            }];
            [self addSubview:self.closeBtn];
        }
    }
    return self;
}

- (void)closeBtnAction
{
    [self stopPlayer];
    [self removeFromSuperview];
}

- (void)dealloc {
    [self removeAvPlayerNtf];
    [self stopPlayer];
    self.player = nil;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:[self getAVPlayerItem]];
        [self addAVPlayerNtf:_player.currentItem];
        
    }
    
    return _player;
}

- (AVPlayerItem *)getAVPlayerItem {
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.videoUrl];
    return playerItem;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self removeAvPlayerNtf];
    [self nextPlayer];
}

- (void)nextPlayer {
    [self.player seekToTime:CMTimeMakeWithSeconds(0, _player.currentItem.duration.timescale)];
    [self.player replaceCurrentItemWithPlayerItem:[self getAVPlayerItem]];
    [self addAVPlayerNtf:self.player.currentItem];
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (void) addAVPlayerNtf:(AVPlayerItem *)playerItem {
    //监控状态属性
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeAvPlayerNtf {
    AVPlayerItem *playerItem = self.player.currentItem;
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopPlayer {
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
     } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (void)playbackFinished:(NSNotification *)ntf
{
    NSLog(@"视频播放完成");
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = ({
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(SCREEN_WIDTH - 50, 30, 30, 30);
            [btn setBackgroundImage:UIImageMake(@"hVideo_cancel") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
    }
    return _closeBtn;
}

@end
