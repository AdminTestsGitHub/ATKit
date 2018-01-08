//
//  ATChatDefines.h
//  MiLin
//
//  Created by AdminTest on 2017/8/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#ifndef ATChatDefines_h
#define ATChatDefines_h

#import "ATFace.h"
#import "ATLocation.h"
#import "ATUser.h"
#import "ATGroup.h"
#import "ATMessage.h"
#import "ATConversation.h"


#import "ATFaceManager.h"
#import "ATMediaManager.h"
#import "ATAudioManager.h"

/** ATTIMConversationManager同步对话列表 通知对话列表刷新 被动刷新 */
static NSString *const kATNotificationReloadConversationList = @"kATNotificationReloadConversationList";

/** 消息到来了，通知对话列表和聊天页面刷新 被动刷新 */
static NSString *const kATNotificationOnNewMessage = @"kATNotificationOnNewMessage";

/** 新发送一条消息，通知列表刷新 主动刷新 */
static NSString *const kATNotificationSendNewMessage = @"kATNotificationSendNewMessage";

/** 撤销一条消息，通知列表刷新 主动刷新 */
static NSString *const kATNotificationRevokeMessage = @"kATNotificationRevokeMessage";


//聊天的一些配置 暂时放在ATDefines里
#define ATChatVoiceMaxSecond 60.
#define ATChatFont UIFontMake(14)
#define ATChatMessageFont UIFontMake(16)
#define ATChatTipFont UIFontMake(13)
#define ATChatTimeTipFont UIFontMake(10)
#define ATChatCellHeaderSize 45 * pw
#define ATChatCellPadding 10

#define ATChatPicsCachePath @"ChatCache/Pics"
#define ATChatWavsCachePath @"ChatCache/Wavs"
#define ATChatVideosCachePath @"ChatCache/Videos"
#define ATChatFilesCachePath @"ChatCache/Files"

/** 带箭头的图片缓存路径 暂时改为内存缓存
 #define ATChatPicArrowsCachePath @"Chat/PicArrows"
 #define ATChatVideoCoversCachePath @"Chat/VideoCovers"
 */

#define ATChatToolBarHeight         49
#define ATChatToolBarBtnSize        37
#define ATChatToolBarInputHeight             ATChatToolBarHeight * 0.74
#define ATChatToolBarInputMaxHeight         104

#define ATChatVideoViewH SCREEN_WIDTH * 0.64 // 录制视频视图高度
#define ATChatVideoViewX SCREEN_HEIGHT * 0.36 // 录制视频视图X



static NSString *const ATRouterEventVideoRecordFinish   = @"ATRouterEventVideoRecordFinish";
static NSString *const ATRouterEventVideoRecordExit   = @"ATRouterEventVideoRecordExit";

#endif /* ATChatDefines_h */
