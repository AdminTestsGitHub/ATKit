//
//  ATAVPlayer.h
//  MiLin
//
//  Created by AdminTest on 2017/8/17.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ATAVPlayer : UIView

@property (copy, nonatomic) NSURL *videoUrl;

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url animated:(BOOL)animated;

- (void)stopPlayer;

@end
