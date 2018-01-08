//
//  UIImage+ATExtension.h
//  MiLin
//
//  Created by AdminTest on 2017/10/19.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ATExtension)

/*!
 *  获取一个view的虚化image
 */
+ (UIImage *)imageWithView:(UIView *)view;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

/*!
 获得新的圆形图片
 
 @param image 传入需要裁剪成圆形的图片
 @return 返回裁剪好的圆形图片
 */
+ (UIImage *)roundImageWithImage:(UIImage *)image;

/*!
 *  传入图片，cell，imageSize，改变自定义大小的圆形系统 cell image
 *
 *  @param cell      cell
 *  @param image     image 可以自己切圆角：[UIImage roundImageWithImage:UIImageMake(@"icon1.jpg")]；
 *  @param imageSize 图像的 size 记得先切圆角再传 size
 *
 *  @return 返回自定义大小的圆形系统 cell image
 */
+ (UIImage *)changeCellRoundImageViewSizeWithCell:(UITableViewCell *)cell
                                            image:(UIImage *)image
                                        imageSize:(CGSize)imageSize;
@end
