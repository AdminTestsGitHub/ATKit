//
//  ATThemeManager.m
//  Demo
//
//  Created by AdminTest on 2017/6/28.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATThemeManager.h"

NSString *const ATThemeChangedNotification = @"ATThemeChangedNotification";
NSString *const ATThemeBeforeChangedName = @"ATThemeBeforeChangedName";
NSString *const ATThemeAfterChangedName = @"ATThemeAfterChangedName";

@implementation ATThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ATThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)setCurrentTheme:(NSObject<ATThemeProtocol> *)currentTheme {
    BOOL isThemeChanged = _currentTheme != currentTheme;
    NSObject<ATThemeProtocol> *themeBeforeChanged = nil;
    if (isThemeChanged) {
        themeBeforeChanged = _currentTheme;
    }
    _currentTheme = currentTheme;
    if (isThemeChanged) {
        [currentTheme setupConfigurationTemplate];
        [[NSNotificationCenter defaultCenter] postNotificationName:ATThemeChangedNotification object:self userInfo:@{ATThemeBeforeChangedName: themeBeforeChanged ?: [NSNull null], ATThemeAfterChangedName: currentTheme ?: [NSNull null]}];
    }
}

@end
