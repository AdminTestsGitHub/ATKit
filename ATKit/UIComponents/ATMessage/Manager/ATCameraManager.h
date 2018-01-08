//
//  ATCameraManager.h
//  MiLin
//
//  Created by AdminTest on 2017/8/17.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATCameraManagerDelegate;


@interface ATCameraManager : NSObject

@property (nonatomic, weak) id<ATCameraManagerDelegate> delegate;

- (instancetype)initWithDelegate:(UIViewController<ATCameraManagerDelegate> *)vc;

- (void)presentCameraViewController;

@end


@protocol ATCameraManagerDelegate <NSObject>

@optional
- (void)CameraDidFinishWithFilePath:(NSString *)filePath;

@end
