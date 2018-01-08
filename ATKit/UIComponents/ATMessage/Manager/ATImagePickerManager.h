//
//  ATImagePickerManager.h
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATImagePickerManagerDelegate;


@interface ATImagePickerManager : NSObject

@property (nonatomic, weak) id<ATImagePickerManagerDelegate> delegate;

- (instancetype)initWithDelegate:(UIViewController<ATImagePickerManagerDelegate> *)vc;

- (void)presentAlbumViewController;

@end


@protocol ATImagePickerManagerDelegate <NSObject>

@optional
- (void)didFinishPickingImageWithImagePaths:(NSArray *)imagePaths;

@end
