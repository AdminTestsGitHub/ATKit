//
//  ATMessageManager.h
//  MiLin
//
//  Created by AdminTest on 2017/8/3.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 消息发送 */
@interface ATMessageManager : NSObject

+ (void)sendMsg:(ATMessage *)msg inConversation:(ATConversation *)conv success:(void (^)())success failed:(void (^)(int code, NSString *msg))failed;

+ (void)revokeMsg:(ATMessage *)msg inConversation:(ATConversation *)conv success:(void (^)())success failed:(void (^)(int code, NSString *msg))failed;


/** 构造文本类型消息 */
+ (ATMessage *)createATMessageWithContent:(NSString *)content;

/** 构造图片类型消息 */
+ (ATMessage *)createATMessageWithImagePath:(NSString *)imagePath;

/** 构造视频类型消息 */
+ (ATMessage *)createATMessageWithVideoPath:(NSString *)videoPath;

/** 构造音频类型消息 */
+ (ATMessage *)createATMessageWithVoicePath:(NSString *)path sec:(int)sec;

/** 构造文件类型消息 */
+ (ATMessage *)createATMessageWithFilePath:(NSString *)filePath;

/** 构造地理位置类型消息 */
+ (ATMessage *)createATMessageWithLocation:(ATLocation *)location;

/** 构造系统消息 */
+ (ATMessage *)createATMessage;

/** 构造通用类型消息 */
+ (ATMessage *)createATMessageWithContent:(NSString *)content
                                      imagePath:(NSString *)imagePath
                                      voiceData:(NSData *)data
                                       filePath:(NSString *)filePath;


@end
