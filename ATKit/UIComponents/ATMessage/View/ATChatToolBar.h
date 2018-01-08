//
//  ATChatToolBar.h
//  MiLin
//
//  Created by AdminTest on 2017/8/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATChatToolBarDelegate;


@interface ATChatToolBar : UIView

/** chotBox的顶部边线 */
@property (nonatomic, strong) UIView *topLine;
/** 录音按钮 */
@property (nonatomic, strong) UIButton *voiceButton;
/** 表情按钮 */
@property (nonatomic, strong) UIButton *faceButton;
/** (+)按钮 */
@property (nonatomic, strong) UIButton *moreButton;
/** 按住说话 */
@property (nonatomic, strong) QMUIButton *talkButton;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) ATChatToolBarStatus status;

@property (nonatomic, weak) id<ATChatToolBarDelegate> delegate;


- (void)sendMessage;

@end



@protocol ATChatToolBarDelegate <NSObject>

@optional
- (void)ATChatToolBar:(ATChatToolBar *)toolBar buttonDidClickWithAction:(ATChatToolBarStatus)action;

- (void)ATChatToolBar:(ATChatToolBar *)toolBar sendTextMessage:(NSString *)textMessage;
- (void)ATChatToolBar:(ATChatToolBar *)toolBar sendAudioMessage:(NSString *)audioPath second:(int)second;

@end
