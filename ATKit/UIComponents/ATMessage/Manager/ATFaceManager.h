//
//  ATFaceManager.h
//  MiLin
//
//  Created by AdminTest on 2017/8/3.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFaceManager : NSObject

+ (NSArray *)emojiEmotions;

+ (NSArray *)qmuiEmotions;//qmui

+ (NSString *)getFaceNameByFaceID:(NSString *)idx;

+ (NSString *)getFaceIDByFaceName:(NSString *)faceName;

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                               color:(UIColor *)color
                                                font:(UIFont *)font;

//正则匹配 [微笑]、［哭］等表情 
+ (NSArray<NSTextCheckingResult *> *)faceTextCheckingResultWithContent:(NSString *)content;

@end
