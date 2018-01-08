//
//  NSString+ATExtension.h
//  MiLin
//
//  Created by AdminTest on 2017/9/22.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ATExtension)

/** 如果含有中文则转义 */
- (NSString *)URLEncodeString;

/** 是否含有中文 */
- (BOOL)includeChinese;

/** 计算文字高度 */
- (CGSize)sizeThatFitsMaxWidth:(CGFloat)width andFont:(UIFont *)font;

/** 是否为空 */
- (BOOL)isEmpty;

/** 是否包含str */
- (BOOL)isContainsString:(NSString *)str;

@end
