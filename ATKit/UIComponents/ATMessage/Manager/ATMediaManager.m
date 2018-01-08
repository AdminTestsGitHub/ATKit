//
//  ATMediaManager.m
//  MiLin
//
//  Created by AdminTest on 2017/8/4.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATMediaManager.h"

static UIImage *_failedImage;

@interface ATMediaManager ()

@property (nonatomic, strong) NSCache *videoCoverCache;//视频封面缓存
@property (nonatomic, strong) NSCache *arrowImageCache;//箭头图片缓存

@end

@implementation ATMediaManager

+ (instancetype)sharedInstance
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        _failedImage  = [UIImage imageNamed:@"icon_album_picture_fail_big"];
    });
    return _instance;
}

/************************************/

#pragma mark - public

- (BOOL)checkMediaExist:(ATMediaType)type mediaID:(NSString *)ID
{
    NSString *path = [self getFullCacheDirectoryWithMediaType:type MediaID:ID];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSData *)getMedia:(ATMediaType)type mediaID:(NSString *)ID
{
    NSString *path = [self getFullCacheDirectoryWithMediaType:type MediaID:ID];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

//
- (NSString *)getCacheMediaPath:(ATMediaType)type
{
    NSString *path = [NSString pathWithComponents:@[kCachesDirectory, [self dir:type]]];
    [self createFolderWithPath:path];

    return path;
}

- (NSString *)getFullCacheDirectoryWithMediaType:(ATMediaType)type MediaID:(NSString *)ID
{
    NSString *path = [NSString pathWithComponents:@[kCachesDirectory, [self dir:type]]];
    [self createFolderWithPath:path];

    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", ID, [self extension:type]]];
}

- (NSString *)getFullCacheDirectoryWithMediaType:(ATMediaType)type
{
    NSString *path = [NSString pathWithComponents:@[kCachesDirectory, [self dir:type]]];
    [self createFolderWithPath:path];
    
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [self generateFileName], [self extension:type]]];
}

- (NSString *)generateFileName
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"record_%.0f",timeInterval];
    return fileName;
}

/** 图片箭头处理 */
- (UIImage *)getArrowImageWtihImagePath:(NSString *)imagePath size:(CGSize)imageSize isSender:(BOOL)isSender
{
    if (!imagePath) return nil;
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    NSString *mediaName = imagePath.lastPathComponent;
    if ([self.arrowImageCache objectForKey:mediaName]) {
        return [self.arrowImageCache objectForKey:mediaName];
    } else {
        UIImage *res = nil;//[UIImage makeArrowImageWithSize:imageSize image:image isSender:isSender];
        [self.arrowImageCache setObject:res forKey:mediaName];
        return res;
    }
}

/** 获取视频封面 只缓存在内存中NSCache*/
- (UIImage *)getArrowImageWithCoverImagePath:(NSString *)coverImagePath size:(CGSize)imageSize isSender:(BOOL)isSender
{
    if (!coverImagePath) return nil;
    
    NSString *mediaName = coverImagePath.lastPathComponent;
    if ([self.videoCoverCache objectForKey:mediaName]) {
        return [self.videoCoverCache objectForKey:mediaName];
    } else {
        /*
        UIImage *thumbnailImage = [UIImage imageWithContentsOfFile:coverImagePath];
        UIImage *videoArrowImage = [UIImage makeArrowImageWithSize:imageSize image:thumbnailImage isSender:isSender];
        UIImage *resultImg = [UIImage addImage2:[UIImage imageNamed:@"App_video_play_btn_bg"] toImage:videoArrowImage];
        if (resultImg) {
            [self.videoCoverCache setObject:resultImg forKey:mediaName];
        }
        return resultImg;
         */
    }
    return nil;
}

/** 获取视频封面缓存路径 */
- (NSString *)getVideoCoverTempPath:(NSString *)videoPath size:(CGSize)imageSize isSender:(BOOL)isSender
{
    return @"";
}

/** 保存图片到本地沙盒 */
- (NSString *)saveImageToLocalSandBox:(UIImage *)image
{
    NSString *path = [self getFullCacheDirectoryWithMediaType:ATMediaType_image];

    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:path atomically:NO];
    
    return path;
}

#pragma mark - privite
- (BOOL)createFolderWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            NSLog(@"create folder failed");
        }
    }
    return isDirExist ? : isDirExist;
}

- (void)clearCaches
{
    [self.videoCoverCache removeAllObjects];
    [self.arrowImageCache removeAllObjects];
}

#pragma mark - getters

- (NSString *)dir:(ATMediaType)type
{
    return @[ATChatPicsCachePath, ATChatWavsCachePath, ATChatVideosCachePath][type];
}

- (NSString *)extension:(ATMediaType)type
{
    return @[@"png", @"wav", @"mp4"][type];
}

- (NSCache *)videoCoverCache
{
    if (!_videoCoverCache) {
        _videoCoverCache = [[NSCache alloc] init];
    }
    return _videoCoverCache;
}

- (NSCache *)arrowImageCache
{
    if (!_arrowImageCache) {
        _arrowImageCache = [[NSCache alloc] init];
    }
    return _arrowImageCache;
}

@end
