//
//  ATMediaManager.h
//  MiLin
//
//  Created by AdminTest on 2017/8/4.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// 消息状态
typedef NS_ENUM(NSInteger, ATMediaType) {
    ATMediaType_image = 0,
    ATMediaType_audio,
    ATMediaType_video
};

/** 缓存多媒体消息 IMSDK的原因暂时采用沙盒缓存 内存缓存NSCache以后考虑 */
@interface ATMediaManager : NSObject

+ (instancetype)sharedInstance;

/** 检查文件是否已经存在 避免重复缓存 */
- (BOOL)checkMediaExist:(ATMediaType)type mediaID:(NSString *)ID;

/** 根据文件ID 类型获取文件 */
- (NSData *)getMedia:(ATMediaType)type mediaID:(NSString *)ID;

/** 根据文件类型获取缓存目录 */
- (NSString *)getCacheMediaPath:(ATMediaType)type;

/** 根据文件类型 文件ID 获取缓存指定全路径 */
- (NSString *)getFullCacheDirectoryWithMediaType:(ATMediaType)type MediaID:(NSString *)ID;

/** 发送时用 */
- (NSString *)getFullCacheDirectoryWithMediaType:(ATMediaType)type;

/** 图片箭头处理 */
- (UIImage *)getArrowImageWtihImagePath:(NSString *)imagePath size:(CGSize)imageSize isSender:(BOOL)isSender;

/** 获取视频封面 */
- (UIImage *)getArrowImageWithCoverImagePath:(NSString *)coverImagePath size:(CGSize)imageSize isSender:(BOOL)isSender;

/** 获取视频封面缓存路径 */
- (NSString *)getVideoCoverTempPath:(NSString *)videoPath size:(CGSize)imageSize isSender:(BOOL)isSender;

/** 保存图片到本地沙盒 */
- (NSString *)saveImageToLocalSandBox:(UIImage *)image;

@end
