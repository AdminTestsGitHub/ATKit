//
//  ATChatImageCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatImageCell.h"
#import "UIButton+AFNetworking.h"
#import "HZPhotoBrowser.h"

@interface ATChatImageCell () <HZPhotoBrowserDelegate>

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, copy) NSString *imagePath;

@end

@implementation ATChatImageCell

- (void)addSubviews
{
    [super addSubviews];
    [self.contentView addSubview:self.imageBtn];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    [super configWithModel:vm];
  
    self.imageBtn.frame = vm.picViewF;
    
    if (!ATArrayIsEmpty(vm.msg.imageList)) {

        /*
        [self.msg getLocalImagePathWithImageType:TIM_IMAGE_TYPE_THUMB succ:^(NSString *path) {
            self.imagePath = path;
            UIImage *arrowImg = [[ATMediaManager sharedInstance] getArrowImageWtihImagePath:path size:vm.picViewF.size isSender:self.msg.isSender];
            [self.imageBtn setImage:arrowImg forState:UIControlStateNormal];
            self.bubbleView.userInteractionEnabled = YES;
        } fail:^(int code, NSString *msg) {
            [self.imageBtn setImage:UIImageMake(@"fs_icon") forState:UIControlStateNormal];
            self.bubbleView.userInteractionEnabled = NO;
        }];
         */
    } else {
        NSString *imagePath = vm.msg.sendMediaPath;
        if (imagePath && imagePath.length > 0) {
            self.imagePath = imagePath;
            UIImage *arrowImg = [[ATMediaManager sharedInstance] getArrowImageWtihImagePath:imagePath size:vm.picViewF.size isSender:self.msg.isSender];
            [self.imageBtn setImage:arrowImg forState:UIControlStateNormal];
            self.bubbleView.userInteractionEnabled = YES;
        }
    }
}

- (void)imageBtnClick:(UIButton *)sender
{
    if (sender.currentImage == nil) {
        return;
    }
    
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = sender; // 原图的父控件
    browser.imageCount = 1; // 图片总数
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}

#pragma mark - <HZPhotoBrowserDelegate>
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    __block UIImage *img;
    if (!ATArrayIsEmpty(self.vm.msg.imageList)) {
        img = [UIImage imageWithContentsOfFile:self.imagePath];
    } else {
        NSString *imagePath = self.vm.msg.sendMediaPath;
        if (imagePath && imagePath.length > 0) {
            img = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    
    return img;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (!ATArrayIsEmpty(self.vm.msg.imageList)) {
        
        return [NSURL URLWithString:@""];
    } else {
        return [NSURL URLWithString:self.imagePath];
    }
}

- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 3;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}




@end
