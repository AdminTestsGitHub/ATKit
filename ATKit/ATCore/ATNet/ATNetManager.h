//
//  ATNetManager.h
//  MiLin
//
//  Created by AdminTest on 2017/6/3.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define ATNetManagerShare [ATNetManager sharedATNetManager]

/*! 过期属性或方法名提醒 */
#define ATNetManagerDeprecated(instead) __deprecated_msg(instead)

/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, ATNetworkStatus)
{
    /*! 未知网络 */
    ATNetworkStatusUnknown           = 0,
    /*! 没有网络 */
    ATNetworkStatusNotReachable,
    /*! 手机 3G/4G 网络 */
    ATNetworkStatusReachableViaWWAN,
    /*! wifi 网络 */
    ATNetworkStatusReachableViaWiFi
};

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, ATHttpRequestType)
{
    /*! get请求 */
    ATHttpRequestTypeGet = 0,
    /*! post请求 */
    ATHttpRequestTypePost,
    /*! put请求 */
    ATHttpRequestTypePut,
    /*! delete请求 */
    ATHttpRequestTypeDelete
};

typedef NS_ENUM(NSUInteger, ATHttpRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    ATHttpRequestSerializerJSON,
    /** 设置请求数据为HTTP格式*/
    ATHttpRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, ATHttpResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    ATHttpResponseSerializerJSON,
    /** 设置响应数据为HTTP格式*/
    ATHttpResponseSerializerHTTP,
};

/*! 实时监测网络状态的 block */
typedef void(^ATNetworkStatusBlock)(ATNetworkStatus status);

/*! 定义请求成功的 block */
typedef void( ^ ATResponseSuccessBlock)(id response);
/*! 定义请求失败的 block */
typedef void( ^ ATResponseFailBlock)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ ATUploadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ ATDownloadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);

/*!
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask ATURLSessionTask;


@interface ATNetManager : NSObject

/**
 创建的请求的超时间隔（以秒为单位），此设置为全局统一设置一次即可，默认超时时间间隔为30秒。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 设置网络请求参数的格式，此设置为全局统一设置一次即可，默认：ATHttpRequestSerializerJSON
 */
@property (nonatomic, assign) ATHttpRequestSerializer requestSerializer;

/**
 设置服务器响应数据格式，此设置为全局统一设置一次即可，默认：ATHttpResponseSerializerJSON
 */
@property (nonatomic, assign) ATHttpResponseSerializer responseSerializer;

/**
 自定义请求头：httpHeaderField
 */
@property(nonatomic, strong) NSDictionary *httpHeaderFieldDictionary;

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类ATNetManager单例
 */
+ (instancetype)sharedATNetManager;


#pragma mark - 网络请求的类方法 --- get / post / put / delete
/**
 网络请求的实例方法 get
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return ATURLSessionTask
 */
+ (ATURLSessionTask *)at_request_GETWithUrlString:(NSString *)urlString
                                      isNeedCache:(BOOL)isNeedCache
                                       parameters:(id)parameters
                                     successBlock:(ATResponseSuccessBlock)successBlock
                                     failureBlock:(ATResponseFailBlock)failureBlock
                                    progressBlock:(ATDownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 post
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return ATURLSessionTask
 */
+ (ATURLSessionTask *)at_request_POSTWithUrlString:(NSString *)urlString
                                       isNeedCache:(BOOL)isNeedCache
                                        parameters:(id)parameters
                                       objectClass:(Class)objectClass
                                      successBlock:(ATResponseSuccessBlock)successBlock
                                      failureBlock:(ATResponseFailBlock)failureBlock
                                     progressBlock:(ATDownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 put
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return ATURLSessionTask
 */
+ (ATURLSessionTask *)at_request_PUTWithUrlString:(NSString *)urlString
                                       parameters:(id)parameters
                                     successBlock:(ATResponseSuccessBlock)successBlock
                                     failureBlock:(ATResponseFailBlock)failureBlock
                                    progressBlock:(ATDownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 delete
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return ATURLSessionTask
 */
+ (ATURLSessionTask *)at_request_DELETEWithUrlString:(NSString *)urlString
                                          parameters:(id)parameters
                                        successBlock:(ATResponseSuccessBlock)successBlock
                                        failureBlock:(ATResponseFailBlock)failureBlock
                                       progressBlock:(ATDownloadProgressBlock)progressBlock;

/**
 上传图片(多图)
 
 @param urlString urlString description
 @param parameters 上传图片预留参数---视具体情况而定 可为空
 @param imageArray 上传的图片数组
 @param fileNames 上传的图片数组 fileName
 @param imageType 图片类型，如：png、jpg、gif
 @param imageScale 图片压缩比率（0~1.0）
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progressBlock 上传进度
 @return ATURLSessionTask
 */
+ (ATURLSessionTask *)at_uploadImageWithUrlString:(NSString *)urlString
                                       parameters:(id)parameters
                                       imageArray:(NSArray *)imageArray
                                        fileNames:(NSArray <NSString *>*)fileNames
                                        imageType:(NSString *)imageType
                                       imageScale:(CGFloat)imageScale
                                     successBlock:(ATResponseSuccessBlock)successBlock
                                      failurBlock:(ATResponseFailBlock)failureBlock
                                    progressBlock:(ATUploadProgressBlock)progressBlock;

/**
 视频上传
 
 @param urlString 上传的url
 @param parameters 上传视频预留参数---视具体情况而定 可移除
 @param videoPath 上传视频的本地沙河路径
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 @param progressBlock 上传的进度
 */
+ (void)at_uploadVideoWithUrlString:(NSString *)urlString
                         parameters:(id)parameters
                          videoPath:(NSString *)videoPath
                       successBlock:(ATResponseSuccessBlock)successBlock
                       failureBlock:(ATResponseFailBlock)failureBlock
                      progressBlock:(ATUploadProgressBlock)progressBlock;

/**
 文件下载
 
 @param urlString 请求的url
 @param parameters 文件下载预留参数---视具体情况而定 可移除
 @param savePath 下载文件保存路径
 @param successBlock 下载文件成功的回调
 @param failureBlock 下载文件失败的回调
 @param progressBlock 下载文件的进度显示
 @return ATURLSessionTask
 */
+ (ATURLSessionTask *)at_downLoadFileWithUrlString:(NSString *)urlString
                                        parameters:(id)parameters
                                          savaPath:(NSString *)savePath
                                      successBlock:(ATResponseSuccessBlock)successBlock
                                      failureBlock:(ATResponseFailBlock)failureBlock
                                     progressBlock:(ATDownloadProgressBlock)progressBlock;

/**
 文件上传
 
 @param urlString urlString description
 @param parameters parameters description
 @param fileName fileName description
 @param filePath filePath description
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 @param progressBlock progressBlock description
 @return ATURLSessionTask
 */
+ (ATURLSessionTask *)at_uploadFileWithUrlString:(NSString *)urlString
                                      parameters:(id)parameters
                                        fileName:(NSString *)fileName
                                        filePath:(NSString *)filePath
                                    successBlock:(ATResponseSuccessBlock)successBlock
                                    failureBlock:(ATResponseFailBlock)failureBlock
                                   progressBlock:(ATUploadProgressBlock)progressBlock;

#pragma mark - 网络状态监测
/*!
 *  开启实时网络状态监测，通过Block回调实时获取(此方法可多次调用)
 */
+ (void)at_startNetWorkMonitoringWithBlock:(ATNetworkStatusBlock)networkStatus;

#pragma mark - 自定义请求头
/**
 *  自定义请求头
 */
+ (void)at_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey;

/**
 删除所有请求头
 */
+ (void)at_clearAuthorizationHeader;

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)at_cancelAllRequest;

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)at_cancelRequestWithURL:(NSString *)URL;

/**
 清空缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
- (void)at_clearAllHttpCache;

/**
 检查上次缓存时间（访问时间？）,如果超出时间策略限制，则删除
 */
+ (void)at_checkAndClearHttpCacheWithTimeLimit:(NSTimeInterval)time
                                     urlString:(NSString *)urlString
                                    parameters:(NSDictionary *)parameters;

/**
 清空指定缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
+ (void)at_clearHttpCacheWithUrlString:(NSString *)urlString
                            parameters:(NSDictionary *)parameters;
#pragma mark - 各版本过期方法名
#pragma mark version 2.0 过期方法名
//+ (ATURLSessionTask *)at_requestWithType:(ATHttpRequestType)type
//                               UrlString:(NSString *)urlString
//                              Parameters:(id)parameters
//                            SuccessBlock:(ATResponseSuccessBlock)successBlock
//                            FailureBlock:(ATResponseFailBlock)failureBlock
//                                progress:(ATDownloadProgressBlock)progress ATNetManagerDeprecated("该方法已过期,请使用最新方法：+ (ATURLSessionTask *)at_requestWithType:(ATHttpRequestType)type urlString:(NSString *)urlString parameters:(id)parameters successBlock:(ATResponseSuccessBlock)successBlock failureBlock:(ATResponseFailBlock)failureBlock progress:(ATDownloadProgressBlock)progress");

//+ (ATURLSessionTask *)at_uploadImageWithUrlString:(NSString *)urlString
//                                       parameters:(id)parameters
//                                       ImageArray:(NSArray *)imageArray
//                                         FileName:(NSString *)fileName
//                                     SuccessBlock:(ATResponseSuccessBlock)successBlock
//                                      FailurBlock:(ATResponseFailBlock)failureBlock
//                                   UpLoadProgress:(ATUploadProgressBlock)progress ATNetManagerDeprecated("该方法已过期,请使用最新方法：+ (ATURLSessionTask *)at_uploadImageWithUrlString:(NSString *)urlString parameters:(id)parameters imageArray:(NSArray *)imageArray fileName:(NSString *)fileName successBlock:(ATResponseSuccessBlock)successBlock failurBlock:(ATResponseFailBlock)failureBlock upLoadProgress:(ATUploadProgressBlock)progress");
//
//+ (void)at_uploadVideoWithUrlString:(NSString *)urlString
//                         parameters:(id)parameters
//                          VideoPath:(NSString *)videoPath
//                       SuccessBlock:(ATResponseSuccessBlock)successBlock
//                       FailureBlock:(ATResponseFailBlock)failureBlock
//                     UploadProgress:(ATUploadProgressBlock)progress ATNetManagerDeprecated("该方法已过期,请使用最新方法：+ (void)at_uploadVideoWithUrlString:(NSString *)urlString parameters:(id)parameters videoPath:(NSString *)videoPath successBlock:(ATResponseSuccessBlock)successBlock failureBlock:(ATResponseFailBlock)failureBlock uploadProgress:(ATUploadProgressBlock)progress");
//
//+ (ATURLSessionTask *)at_downLoadFileWithUrlString:(NSString *)urlString
//                                        parameters:(id)parameters
//                                          SavaPath:(NSString *)savePath
//                                      SuccessBlock:(ATResponseSuccessBlock)successBlock
//                                      FailureBlock:(ATResponseFailBlock)failureBlock
//                                  DownLoadProgress:(ATDownloadProgressBlock)progress ATNetManagerDeprecated("该方法已过期,请使用最新方法：+ (ATURLSessionTask *)at_downLoadFileWithUrlString:(NSString *)urlString parameters:(id)parameters savaPath:(NSString *)savePath successBlock:(ATResponseSuccessBlock)successBlock failureBlock:(ATResponseFailBlock)failureBlock downLoadProgress:(ATDownloadProgressBlock)progress");


 @end
