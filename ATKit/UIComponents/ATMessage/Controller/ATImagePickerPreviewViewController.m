//
//  ATImagePickerPreviewViewController.m
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATImagePickerPreviewViewController.h"

static CGFloat kBottomToolBarViewHeight = 45;
static CGFloat kImageCountLabelSize = 18;

@implementation ATImagePickerPreviewViewController {
    QMUIButton *_sendButton;
    QMUIButton *_originImageCheckboxButton;
    UIView *_bottomToolBarView;
}

@dynamic delegate;

- (void)initSubviews {
    [super initSubviews];
    
    _bottomToolBarView = [[UIView alloc] init];
    _bottomToolBarView.backgroundColor = self.toolBarBackgroundColor;
    [self.view addSubview:_bottomToolBarView];
    
    _sendButton = [[QMUIButton alloc] init];
    _sendButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [_sendButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = UIFontMake(16);
    [_sendButton sizeToFit];
    [_sendButton addTarget:self action:@selector(handleSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBarView addSubview:_sendButton];
    
    _imageCountLabel = [[QMUILabel alloc] init];
    _imageCountLabel.backgroundColor = ButtonTintColor;
    _imageCountLabel.textColor = UIColorWhite;
    _imageCountLabel.font = UIFontMake(12);
    _imageCountLabel.textAlignment = NSTextAlignmentCenter;
    _imageCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _imageCountLabel.layer.masksToBounds = YES;
    _imageCountLabel.layer.cornerRadius = kImageCountLabelSize / 2;
    _imageCountLabel.hidden = YES;
    [_bottomToolBarView addSubview:_imageCountLabel];
    
    _originImageCheckboxButton = [[QMUIButton alloc] init];
    _originImageCheckboxButton.titleLabel.font = UIFontMake(14);
    [_originImageCheckboxButton setTitleColor:self.toolBarTintColor forState:UIControlStateNormal];
    [_originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox") forState:UIControlStateNormal];
    [_originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox_checked") forState:UIControlStateSelected];
    [_originImageCheckboxButton setImage:UIImageMake(@"origin_image_checkbox_checked") forState:UIControlStateSelected|UIControlStateHighlighted];
    [_originImageCheckboxButton setTitle:@"原图" forState:UIControlStateNormal];
    [_originImageCheckboxButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5.0f, 0, 5.0f)];
    [_originImageCheckboxButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5.0f, 0, 0)];
    [_originImageCheckboxButton sizeToFit];
    _originImageCheckboxButton.qmui_outsideEdge = UIEdgeInsetsMake(-6.0f, -6.0f, -6.0f, -6.0f);
    [_originImageCheckboxButton addTarget:self action:@selector(handleOriginImageCheckboxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBarView addSubview:_originImageCheckboxButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateOriginImageCheckboxButtonIfNeed];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat bottomToolBarPaddingHorizontal = 12.0f;
    _bottomToolBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kBottomToolBarViewHeight, CGRectGetWidth(self.view.bounds), kBottomToolBarViewHeight);
    _sendButton.frame = CGRectSetXY(_sendButton.frame, CGRectGetWidth(_bottomToolBarView.frame) - bottomToolBarPaddingHorizontal - CGRectGetWidth(_sendButton.frame), CGFloatGetCenter(CGRectGetHeight(_bottomToolBarView.frame), CGRectGetHeight(_sendButton.frame)));
    _imageCountLabel.frame = CGRectMake(CGRectGetMinX(_sendButton.frame) - 5 - kImageCountLabelSize, CGRectGetMinY(_sendButton.frame) + CGFloatGetCenter(CGRectGetHeight(_sendButton.frame), CGRectGetHeight(_imageCountLabel.frame)), kImageCountLabelSize, kImageCountLabelSize);
    _originImageCheckboxButton.frame = CGRectSetXY(_originImageCheckboxButton.frame, bottomToolBarPaddingHorizontal, CGFloatGetCenter(CGRectGetHeight(_bottomToolBarView.frame), CGRectGetHeight(_originImageCheckboxButton.frame)));
}

- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    [super singleTouchInZoomingImageView:zoomImageView location:location];
    _bottomToolBarView.hidden = !_bottomToolBarView.hidden;
}

- (void)zoomImageView:(QMUIZoomImageView *)imageView didHideVideoToolbar:(BOOL)didHide {
    [super zoomImageView:imageView didHideVideoToolbar:didHide];
    _bottomToolBarView.hidden = didHide;
}

- (void)setDownloadStatus:(QMUIAssetDownloadStatus)downloadStatus {
    [super setDownloadStatus:downloadStatus];
    if (downloadStatus == QMUIAssetDownloadStatusSucceed) {
        _originImageCheckboxButton.enabled = YES;
    } else {
        _originImageCheckboxButton.enabled = NO;
    }
}

- (void)handleSendButtonClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:sendImageWithImagesAssetArray:)]) {
            if (self.selectedImageAssetArray.count == 0) {
                // 如果没选中任何一张，则点击发送按钮直接发送当前这张大图
                QMUIAsset *currentAsset = self.imagesAssetArray[self.imagePreviewView.currentImageIndex];
                [self.selectedImageAssetArray addObject:currentAsset];
            }
            [self.delegate imagePickerPreviewViewController:self sendImageWithImagesAssetArray:self.selectedImageAssetArray];
        }
    }];
}

- (void)handleOriginImageCheckboxButtonClick:(id)sender {
    QMUINavigationButton *button = sender;
    if (button.selected) {
        button.selected = NO;
        [button setTitle:@"原图" forState:UIControlStateNormal];
        [button sizeToFit];
        [_bottomToolBarView setNeedsLayout];
    } else {
        button.selected = YES;
        [self updateOriginImageCheckboxButtonIfNeed];
        
    }
    self.shouldUseOriginImage = button.selected;
}

- (void)updateOriginImageCheckboxButtonIfNeed {
    if (_originImageCheckboxButton.selected) {
        QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
        [imageAsset assetSize:^(long long size) {
            [_originImageCheckboxButton setTitle:[NSString stringWithFormat:@"原图(%@)", [ATUIHelper humanReadableFileSize:size]] forState:UIControlStateNormal];
            [_originImageCheckboxButton sizeToFit];
            [_bottomToolBarView setNeedsLayout];
        }];
    }
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView willScrollHalfToIndex:(NSUInteger)index {
    [super imagePreviewView:imagePreviewView willScrollHalfToIndex:index];
    if (_originImageCheckboxButton.selected) {
        QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:index];
        [imageAsset assetSize:^(long long size) {
            [_originImageCheckboxButton setTitle:[NSString stringWithFormat:@"原图(%@)", [ATUIHelper humanReadableFileSize:size]] forState:UIControlStateNormal];
            [_originImageCheckboxButton sizeToFit];
            [_bottomToolBarView setNeedsLayout];
        }];
    }
}


@end
