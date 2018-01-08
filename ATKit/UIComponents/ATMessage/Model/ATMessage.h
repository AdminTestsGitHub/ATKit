//
//  ATMessage.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATMessage : NSObject

/** 消息ID */
@property (nonatomic, copy) NSString *msgID;

/** 消息uniqueID */
@property (nonatomic, assign) uint64_t uniqueID;

/** 是否发送方 */
@property (nonatomic, assign) BOOL isSender;

/** 是否群聊的消息 */
@property (nonatomic, assign) BOOL isGroup;

/** 获取发送方 */
@property (nonatomic, copy) NSString *sender;

/** 当前消息的时间戳 */
@property (nonatomic, strong) NSDate *timestamp;

/** 当前消息的时间字符串 */
@property (nonatomic, copy) NSString *timestampStr;

/** 消息的类型*/
@property (nonatomic, assign) ATMessageType msgType;

/** 消息元素的具体类名 */
@property (nonatomic, copy) NSString *eleClassStr;

///** 当前消息的富文本 即为对话列表所显示的富文本信息 */
//@property (nonatomic, copy) NSAttributedString *attributedText;

/** 当前消息的文本信息 */
@property (nonatomic, copy) NSString *content;

/** 图片数组 */
@property (nonatomic, strong) NSArray *imageList;

/** 语音 视频时长 */
@property (nonatomic, assign) int mediaDuration;

/** 图片 视频cover size */
@property (nonatomic, assign) CGSize imageSize;

/** 消息发送状态 */
@property (nonatomic, assign) ATMessageDeliveryState deliveryState;

/** 消息状态 已读未读撤回 */
@property (nonatomic, assign) ATMessageStatus status;

/** 对应cell类名 */
@property (nonatomic, strong) Class cellClass;

/** 多媒体文件路径 语音，视频，图片等 不为nil 证明是自己发送的 */
@property (nonatomic, copy) NSString *sendMediaPath;

/** 视频, 地理位置的封面图片 临时缓存地址 */
@property (nonatomic, copy) NSString *coverTempPath;

/** 地理位置信息 */
@property (nonatomic, strong) ATLocation *location;


/** 构造本地撤销Tip (不需要发送） */
+ (instancetype)revokeMsgWithSender:(NSString *)sender;
/** 构造本地时间Tip (不需要发送） */
+ (instancetype)dateMsgWithDate:(NSDate *)date;
/** 构造本地失败类型消息 (不需要发送） */
+ (instancetype)failedMsgWithTIMMessage:(ATMessage *)msg;

@end
