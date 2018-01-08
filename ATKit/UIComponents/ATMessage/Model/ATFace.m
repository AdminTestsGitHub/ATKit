//
//  ATFace.m
//  MiLin
//
//  Created by AdminTest on 2017/8/3.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATFace.h"

@implementation ATFace

+ (instancetype)emotionWithIdentifier:(NSString *)identifier displayName:(NSString *)displayName
{
    ATFace *emotion = [[ATFace alloc] init];
    emotion.face_id = identifier;
    emotion.face_name = displayName;
    return emotion;
}

- (BOOL)isEqual:(ATFace *)emotion
{
    return [self.face_name isEqualToString:emotion.face_name] || [self.code isEqualToString:emotion.code];
}



@end
