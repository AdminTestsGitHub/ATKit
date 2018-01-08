//
//  ATAudioView.h
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATAudioView : UIView

@property (nonatomic, copy) NSString *audioName;

@property (nonatomic, copy) NSString *audioPath;

- (void)releaseTimer;

@end
