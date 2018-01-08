//
//  ATAudioManager.m
//  MiLin
//
//  Created by AdminTest on 2017/8/16.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ATAudioManager () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@end


@implementation ATAudioManager

- (instancetype)initWithDelegate:(id<ATAudioManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setAudioSessionCategory:AVAudioSessionCategoryPlayAndRecord];
    }
    return self;
}

- (void)setAudioSessionCategory: (NSString *)categoryConstant
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // todo - check categoryConstant type, throw error if necessary
    
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:categoryConstant error:&setCategoryError];
    
    // todo - handle error
    if (!success) { /* handle the error condition */ }
    
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    
    // todo - handle error
    if (!success) { /* handle the error condition */ }
}

#pragma mark - AVAudioRecorder

- (void)startRecord
{
    [self setupAndPrepareToRecord];
}

- (void)stopRecord
{
    [self.recorder stop];
}

- (void)cancelRecord
{
    [self.recorder deleteRecording];
}

- (void)setupAndPrepareToRecord
{
    [self setAudioSessionCategory:AVAudioSessionCategoryRecord];

    NSURL *url = [NSURL URLWithString:[[ATMediaManager sharedInstance] getFullCacheDirectoryWithMediaType:ATMediaType_audio]];
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   
                                   [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                                   
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                   
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                   
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];
    
    
    
    // initiate recorder
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    [self.recorder recordForDuration:60];

}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSString *audioPath = [recorder.url absoluteString];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecorderDidFinishRecording:)]) {
        [self.delegate audioRecorderDidFinishRecording:audioPath];
    }
}

#pragma mark - AVAudioPlayer
- (void)startPlay:(NSString *)path
{
    [self setAudioSessionCategory:AVAudioSessionCategoryPlayback];
    NSError *audioError;

    NSURL *url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&audioError];
    
    //莫名其妙的 加个timer audioPlayerDidFinishPlaying回调就走了
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    self.player.delegate = self;
    self.player.volume = 1;
    [self.player prepareToPlay];
    [self.player play];
}

- (void)timerFired:(NSTimer *)sender
{
    NSLog(@"莫名其妙的 加个timer audioPlayerDidFinishPlaying回调就走了 0.0 %@", self.player);
}

- (void)stopPlay
{
    [self.timer invalidate];
    [self.player stop];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying)]) {
        [self.delegate audioPlayerDidFinishPlaying];
    }
    [self.timer invalidate];
}

// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"解码错误！");
    [self.timer invalidate];
}

- (void)dealloc
{
    [_timer invalidate];
    _recorder = nil;
    _player = nil;
}
@end
