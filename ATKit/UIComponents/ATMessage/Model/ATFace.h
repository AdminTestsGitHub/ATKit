//
//  ATFace.h
//  MiLin
//
//  Created by AdminTest on 2017/8/3.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFace : NSObject


@property (nonatomic, copy) NSString *face_name;//以文字命名的表情图片 例如 [微笑].png

@property (nonatomic, copy) NSString *face_id;//以序号命名的表情图片 例如 1.png

@property (nonatomic, copy) NSString *code;//图片的8进制格式

+ (instancetype)emotionWithIdentifier:(NSString *)identifier displayName:(NSString *)displayName;


@end
