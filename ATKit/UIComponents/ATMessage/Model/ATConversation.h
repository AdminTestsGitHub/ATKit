//
//  ATConversation.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATConversation : NSObject

/** 对话类型 */
@property (nonatomic, assign) ATConversationType conversationType;

/** 会话标识 */
@property (nonatomic, copy) NSString *conversationID;


///** 接受者资料 */
//@property (nonatomic, copy) ATTIMUser *receiverProfile;

/** 会话标题 单聊为对方昵称 群聊为群名称 */
@property (nonatomic, copy) NSString *conversationTitle;

/** 接受者ID */
@property (nonatomic, copy) NSString *receiverID;

/** 接受者名称 */
@property (nonatomic, copy) NSString *receiverName;

/** 对话头像地址 */
@property (nonatomic, copy) NSString *receiverAvatarURLStr;

/** 对话最新一条信息 */
@property (nonatomic, strong) ATMessage *lastMsg;

///** 对话最新一条信息富文本 */
//@property (nonatomic, copy) NSAttributedString *lastMsgStr;
//
///** 最后一条消息时间文本 */
//@property (nonatomic, copy) NSString *lastMsgTimeStr;
//
///** 最后一条消息时间 */
//@property (nonatomic, strong) NSDate *lastMsgTime;

/** 对话未读数 */
@property (nonatomic, assign) int unReadCount;

/** 是否置顶 */
@property (nonatomic, assign) BOOL isTop;

/** 是否有草稿 */
@property (nonatomic, assign) BOOL hasDraft;

/** 草稿内容 */
@property (nonatomic, strong) NSString *draft;


/** 当前用户是否为群管理员 单人对话忽略 */
@property (nonatomic, assign) BOOL isAdmin;

/** 群成员列表 */
@property (nonatomic, strong) NSArray<ATUser *> *memberList;

/** 获取该会话所属用户的id */
@property (nonatomic, copy) NSString *selfIdentifier;

@end
