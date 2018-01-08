//
//  ATImagePickerPreviewViewController.h
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

@protocol ATImagePickerPreviewViewControllerDelegate;


@interface ATImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property (nonatomic, weak) id<ATImagePickerPreviewViewControllerDelegate> delegate;

@property (nonatomic, strong) QMUILabel *imageCountLabel;
@property (nonatomic, strong) QMUIAssetsGroup *assetsGroup;
@property (nonatomic, assign) BOOL shouldUseOriginImage;


@end


@protocol ATImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(ATImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray;

@end

