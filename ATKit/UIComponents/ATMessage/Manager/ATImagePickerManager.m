//
//  ATImagePickerManager.m
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATImagePickerManager.h"
#import "ATImagePickerPreviewViewController.h"
#

static NSInteger kMaxSelectedImageCount = 9;
static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;

@interface ATImagePickerManager () <QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate, QMUIImagePickerPreviewViewControllerDelegate, ATImagePickerPreviewViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIViewController *vc;

@end

@implementation ATImagePickerManager

- (instancetype)initWithDelegate:(UIViewController<ATImagePickerManagerDelegate> *)vc
{
    self = [super init];
    if (self) {
        self.vc = vc;
        self.delegate = vc;
    }
    return self;
}

#pragma mark - public
- (void)presentCamera
{
    if (![ATUIHelper hasPermissionToGetCamera]) {
        [ATAlert alertWithTitle:@"请在iPhone的“设置-隐私”选项中，允许咪邻访问你的相机。" message:nil cancelButtonTitle:nil otherButtonTitle:@"确定" rightHandler:^{
            
        }];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.vc presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            NSLog(@"camera is no available!");
        }
    }
}

- (void)presentAlbumViewController
{
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:@"照片"];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:@"照片"];
    }
}

#pragma mark - private
- (void)finish:(NSMutableArray<QMUIAsset *> *)assets isOriginImage:(BOOL)isOriginImage
{
    NSMutableArray *res = [NSMutableArray array];
    
    [assets enumerateObjectsUsingBlock:^(QMUIAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *originImage = [obj originImage];

        UIImage *temp;
        if (!isOriginImage) {
#warning admintest to do
//            temp = [UIImage simpleImage:originImage];
        } else {
            temp = originImage;
        }
        NSString *filePath = [[ATMediaManager sharedInstance] saveImageToLocalSandBox:originImage];
        
        [res addObject:filePath];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingImageWithImagePaths:)]) {
        [self.delegate didFinishPickingImageWithImagePaths:res];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title
{
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = title;
    
    ATNavigationController *navigationController = [[ATNavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    
    [self.vc presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - QMUIAlbumViewControllerDelegate
/// 点击相簿里某一行时，需要给一个 QMUIImagePickerViewController 对象用于展示九宫格图片列表
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = kMaxSelectedImageCount;
    return imagePickerViewController;
}

#pragma mark - QMUIImagePickerViewControllerDelegate
- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    
    [self finish:imagesAssetArray isOriginImage:NO];
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController
{
    ATImagePickerPreviewViewController *imagePickerPreviewViewController = [[ATImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    imagePickerPreviewViewController.maximumSelectImageCount = kMaxSelectedImageCount;
    imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
    imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
    return imagePickerPreviewViewController;
}

#pragma mark - <QMUIImagePickerPreviewViewControllerDelegate>
- (void)imagePickerPreviewViewController:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController didCheckImageAtIndex:(NSInteger)index {
    // 在预览界面选择图片时，控制显示当前所选的图片，并且展示动画
    ATImagePickerPreviewViewController *customImagePickerPreviewViewController = (ATImagePickerPreviewViewController *)imagePickerPreviewViewController;
    NSUInteger selectedCount = [imagePickerPreviewViewController.selectedImageAssetArray count];
    if (selectedCount > 0) {
        customImagePickerPreviewViewController.imageCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(selectedCount)];
        customImagePickerPreviewViewController.imageCountLabel.hidden = NO;
        [QMUIImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:customImagePickerPreviewViewController.imageCountLabel];
    } else {
        customImagePickerPreviewViewController.imageCountLabel.hidden = YES;
    }
    
}

#pragma mark - <ATImagePickerPreviewViewControllerDelegate>
- (void)imagePickerPreviewViewController:(ATImagePickerPreviewViewController *)imagePickerPreviewViewController sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    
    [self finish:imagesAssetArray isOriginImage:imagePickerPreviewViewController.shouldUseOriginImage];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 图片压缩后再上传服务器
    // 保存路径
#warning admintest to do
    UIImage *simpleImg = nil;//[UIImage simpleImage:orgImage];
    NSString *filePath = [[ATMediaManager sharedInstance] saveImageToLocalSandBox:simpleImg];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingImageWithImagePaths:)]) {
        [self.delegate didFinishPickingImageWithImagePaths:@[filePath]];
    }
}

#pragma mark - getters
- (UIImagePickerController *)imagePicker
{
    if (nil == _imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationCustom;
        _imagePicker.view.backgroundColor = [UIColor whiteColor];
    }
    return _imagePicker;
}


@end
