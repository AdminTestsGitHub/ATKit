//
//  ATThemeProtocol.h
//  Demo
//
//  Created by AdminTest on 2017/6/28.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 所有主题均应实现这个协议，规定了 QMUI Demo 里常用的几个关键外观属性
@protocol ATThemeProtocol <NSObject>

@required

/// 来自于 QMUIConfigurationTemplate 里的自带方法，用于应用配置表里的设置
- (void)setupConfigurationTemplate;

- (UIColor *)themeTintColor;
- (UIColor *)themeListTextColor;
- (UIColor *)themeCodeColor;
- (UIColor *)themeGridItemTintColor;

- (NSString *)themeName;

@end


/// 所有能响应主题变化的对象均应实现这个协议，目前主要用于 ATCommonViewController 及 ATCommonTableViewController
@protocol ATChangingThemeDelegate <NSObject>

@required

- (void)themeBeforeChanged:(NSObject<ATThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<ATThemeProtocol> *)themeAfterChanged;

@end
