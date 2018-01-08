//
//  ATChatViewModel.h
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * `ATChatViewModel`主要作用就是提供气泡的layout 方便业务直接使用 布局控件
 */

@class ATChatBaseCell;
@class YYTextLayout;
@class YYTextContainer;
@class ATMessage;

@interface ATChatViewModel : NSObject

/// 消息模型
@property (nonatomic, strong) ATMessage *msg;

//聊天信息的背景图
@property (nonatomic, assign, readonly) CGRect bubbleViewF;

//名字Label
@property (nonatomic, assign, readonly) CGRect nameLabelF;

//聊天信息label
@property (nonatomic, assign, readonly) CGRect chatLabelF;

//提示label
@property (nonatomic, assign, readonly) CGRect tipLabelF;

//发送的菊花视图
@property (nonatomic, assign, readonly) CGRect activityF;

//重新发送按钮
@property (nonatomic, assign, readonly) CGRect retryButtonF;

// 头像
@property (nonatomic, assign, readonly) CGRect headImageViewF;

// topView   /***第一版***/
@property (nonatomic, assign, readonly) CGRect topViewF;

//计算总的高度
@property (nonatomic, assign) CGFloat cellHight;

/// 图片
@property (nonatomic, assign, readonly) CGRect picViewF;

/// 语音图标
@property (nonatomic, assign) CGRect voiceIconF;

/// 语音时长数字
@property (nonatomic, assign) CGRect durationLabelF;

/// 语音未读红点
@property (nonatomic, assign) CGRect redViewF;

+ (instancetype)modelWithMessage:(ATMessage *)msg;

- (ATChatBaseCell *)tableView:(UITableView *)tableView type:(int)type;
@end
