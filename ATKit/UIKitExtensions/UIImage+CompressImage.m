//
//  UIImage+CompressImage.m
//  MiLin
//
//  Created by AdminTest on 2017/6/3.
//  Copyright © 2017年 AdminTest. All rights reserved.
//


#import "UIImage+CompressImage.h"

typedef NS_ENUM(NSInteger, CompressType){
    session = 800,
    timeline = 1280
};

@implementation UIImage (CompressImage)

+(JPEGImage *)needCompressImage:(UIImage *)image size:(CGSize )size scale:(CGFloat )scale
{
    JPEGImage *newImage = nil;
    //创建画板
    UIGraphicsBeginImageContext(size);
    
    //写入图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //得到新的图片
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //释放画板
    UIGraphicsEndImageContext();
    
    //比例压缩
    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, scale)];
//    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, 1.0) scale:scale];
    
    return newImage;
}

+ (JPEGImage *)needCompressImageData:(NSData *)imageData size:(CGSize )size scale:(CGFloat )scale
{
    PNGImage *image = [UIImage imageWithData:imageData];
    return [UIImage needCompressImage:image size:size scale:scale];
}

+ (JPEGImage *)needCenterImage:(UIImage *)image size:(CGSize )size scale:(CGFloat )scale
{
    /* 想切中间部分,待解决 */
#warning area of center image
    JPEGImage *newImage = nil;
    //创建画板
    UIGraphicsBeginImageContext(size);
    
    //写入图片,在中间
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //得到新的图片
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //释放画板
    UIGraphicsEndImageContext();
    
    //比例压缩
    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, scale)];

    return newImage;
}

+(JPEGImage *)jpegImageWithPNGImage:(PNGImage *)pngImage
{
    return [UIImage needCompressImage:pngImage size:pngImage.size scale:1.0];
}

+(JPEGImage *)jpegImageWithPNGData:(PNGData *)pngData
{
    PNGImage *pngImage = [UIImage imageWithData:pngData];
    return [UIImage needCompressImage:pngImage size:pngImage.size scale:1.0];
}

+(JPEGData *)jpegDataWithPNGData:(PNGData *)pngData
{
    return UIImageJPEGRepresentation([UIImage jpegImageWithPNGData:pngData], 1.0);
}

+(JPEGData *)jpegDataWithPNGImage:(PNGImage *)pngImage
{
    return UIImageJPEGRepresentation([UIImage jpegImageWithPNGImage:pngImage], 1.0);
}


//生成缩略图
+ (NSData *)base64ImageThumbnai:(UIImage *)image
{
    
    UIImage * nImage = nil;
    //CGSizeMake(100, 100)
    CGSize size = [self imageSize:image.size andType:timeline];
    
    if (image == nil) {
        
        nImage = nil;
        
    }else{
        
        UIGraphicsBeginImageContext(size);
        
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        nImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    UIImage *baseImage = nImage;
    
    NSData * data = UIImageJPEGRepresentation(baseImage, 0.5);
    return data;
}

+(CGSize)imageSize:(CGSize)size andType:(CompressType)type{
    //计算大小
    CGFloat boundary = 1280;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    if (width <= boundary || height <= boundary) {
        return CGSizeMake(width, height);
    }
    int proportion = MAX(width, height)/MIN(width, height);
    if (proportion <= 2) {
        int x = MAX(width, height)/boundary;
        if (width > height) {
            width = boundary;
            height = height/x;
        }else{
            width = width/x;
            height = boundary;
        }
    }else{
        if (MIN(width, height)>=boundary) {
            boundary = type == session?800:1280;
            int x = MIN(width, height)/boundary;
            if (width<height) {
                width = boundary;
                height = height/x;
            }else{
                width = width/x;
                height = boundary;
            }
        }
    }
    return CGSizeMake(width, height);
    
}

@end
