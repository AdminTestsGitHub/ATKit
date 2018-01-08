//
//  ATChatLocationCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatLocationCell.h"

@interface ATChatLocationCell ()

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) ATLocation *location;

@end

@implementation ATChatLocationCell

- (void)addSubviews
{
    [super addSubviews];
    [self.contentView addSubview:self.imageBtn];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    [super configWithModel:vm];
    
    /*
    if (vm.msg.location) {
        self.location = vm.msg.location;
        
//        UIImage *img = [UIImage imageWithContentsOfFile:vm.msg.location.coverPath];
//        UIImage *arrowImg = [[ATMediaManager sharedInstance] getArrowImage:img size:vm.picViewF.size mediaPath:vm.msg.location.coverPath isSender:vm.msg.isSender];
//        [self.imageBtn setImage:arrowImg forState:UIControlStateNormal];
        [self.imageBtn setTitle:vm.msg.location.desc forState:UIControlStateNormal];
        [self.imageBtn setBackgroundColor:UIColorTheme2];
        self.imageBtn.titleLabel.numberOfLines = 0;
    }
     */
    
    self.imageBtn.frame = vm.picViewF;
    self.bubbleView.userInteractionEnabled = _imageBtn.imageView.image;
}

- (void)imageBtnClick:(UIButton *)sender
{
    if (sender.currentImage == nil) {
        return;
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
