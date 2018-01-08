//
//  ATCameraManager.m
//  MiLin
//
//  Created by AdminTest on 2017/8/17.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCameraManager.h"
#import "ATCameraViewController.h"

@interface ATCameraManager ()

@property (nonatomic, strong) UIViewController *vc;

@end


@implementation ATCameraManager

- (instancetype)initWithDelegate:(UIViewController<ATCameraManagerDelegate> *)vc
{
    self = [super init];
    if (self) {
        self.vc = vc;
        self.delegate = vc;
    }
    return self;
}

- (void)presentCameraViewController
{
    ATCameraViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"ATCameraViewController" owner:nil options:nil].lastObject;
    ctrl.HSeconds = 10;//设置可录制最长时间
    ctrl.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            NSURL *videoURL = item;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(CameraDidFinishWithFilePath:)]) {
                NSString *path = [videoURL absoluteString];
                path = [path substringFromIndex:7];
                [self.delegate CameraDidFinishWithFilePath:path];
                 
            }
            
        } else {
            //图片
            if (self.delegate && [self.delegate respondsToSelector:@selector(CameraDidFinishWithFilePath:)]) {
                [self.delegate CameraDidFinishWithFilePath:item];
            }
        }
    };
    [self.vc presentViewController:ctrl animated:YES completion:nil];
}


@end
