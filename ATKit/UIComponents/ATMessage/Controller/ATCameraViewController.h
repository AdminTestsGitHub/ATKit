//
//  ATCameraViewController.h
//  MiLin
//
//  Created by AdminTest on 2017/8/17.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCommonViewController.h"
typedef void(^TakeOperationSureBlock)(id item);

@interface ATCameraViewController : ATCommonViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (assign, nonatomic) NSInteger HSeconds;

@property (nonatomic, assign) BOOL forbidTranscribe;//屏蔽拍摄 默认no

@end
