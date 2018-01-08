//
//  ATThemeManager.h
//  Demo
//
//  Created by AdminTest on 2017/6/28.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATThemeProtocol.h"

/// 当主题发生变化时，会发送这个通知
extern NSString *const ATThemeChangedNotification;

/// 主题发生改变前的值，类型为 NSObject<ATThemeProtocol>，可能为 NSNull
extern NSString *const ATThemeBeforeChangedName;

/// 主题发生改变后的值，类型为 NSObject<ATThemeProtocol>，可能为 NSNull
extern NSString *const ATThemeAfterChangedName;

/**
 *  QMUI Demo 的皮肤管理器，当需要换肤时，请为 currentTheme 赋值；当需要获取当前皮肤时，可访问 currentTheme 属性。
 *  可通过监听 ATThemeChangedNotification 通知来捕获换肤事件，默认地，ATCommonViewController 及 ATCommonTableViewController 均已支持响应换肤，其响应方法是通过 ATChangingThemeDelegate 接口来实现的。
 */
@interface ATThemeManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, strong) NSObject<ATThemeProtocol> *currentTheme;
@end
