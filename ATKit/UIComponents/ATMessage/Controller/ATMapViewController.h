//
//  ATMapViewController.h
//  MiLin
//
//  Created by AdminTest on 2017/7/24.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCommonViewController.h"

@protocol ATMapViewControllerDelegate;


@interface ATMapViewController : ATCommonViewController

@property (nonatomic, weak) id<ATMapViewControllerDelegate> delegate;

@end


@protocol ATMapViewControllerDelegate <NSObject>

@optional
- (void)ATMapViewController:(ATMapViewController *)vc didSelectPointWithLocation:(ATLocation *)location;

@end
