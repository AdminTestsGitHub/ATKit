//
//  ATProgressHUD.h
//  MiLin
//
//  Created by AdminTest on 2017/8/16.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  状态指示器对应状态
 */
typedef NS_ENUM(NSUInteger, ATProgressHUDState){
    ATProgressHUDStateSuccess /**< 成功 */,
    ATProgressHUDStateError /**< 出错,失败 */,
    ATProgressHUDStateShort /**< 时间太短失败 */,
    ATProgressHUDStateMessage /**< 自定义失败提示 */,
};


@interface ATProgressHUD : UIView

#pragma mark - Class Methods

/**
 *  上次成功录音时长
 */
+ (NSTimeInterval)seconds;

/**
 *  显示录音指示器
 */
+ (void)show;

/**
 *  隐藏录音指示器,使用自带提示语句
 *
 *  @param message 提示信息
 */
+ (void)dismissWithMessage:(NSString *)message;

/**
 *  隐藏hud,带有录音状态
 *
 *  @param progressState 录音状态
 */
+ (void)dismissWithProgressState:(ATProgressHUDState)progressState;

/**
 *  修改录音的subTitle显示文字
 *
 *  @param str 需要显示的文字
 */
+ (void)changeSubTitle:(NSString *)str;



@end
