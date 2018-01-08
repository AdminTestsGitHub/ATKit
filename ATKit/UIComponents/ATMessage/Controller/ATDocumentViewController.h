//
//  ATDocumentViewController.h
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCommonViewController.h"
@protocol ATDocumentViewControllerDelegate;


@interface ATDocumentViewController : ATCommonViewController

@property (nonatomic, weak) id<ATDocumentViewControllerDelegate> delegate;

@end


@protocol ATDocumentViewControllerDelegate <NSObject>

- (void)ATDocumentViewController:(ATDocumentViewController *)documentVC selectedFileName:(NSString *)fileName;


@end
