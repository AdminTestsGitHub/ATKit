//
//  ATAudioManager.h
//  MiLin
//
//  Created by AdminTest on 2017/8/16.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATAudioManagerDelegate;


@interface ATAudioManager : NSObject

@property (nonatomic, weak) id <ATAudioManagerDelegate> delegate;

- (instancetype)initWithDelegate:(id<ATAudioManagerDelegate>)delegate;

- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

- (void)startPlay:(NSString *)path;
- (void)stopPlay;

@end


@protocol ATAudioManagerDelegate <NSObject>

@optional
- (void)audioRecorderDidFinishRecording:(NSString *)path;
- (void)audioPlayerDidFinishPlaying;

@end
