//
//  ATFaceManager.m
//  MiLin
//
//  Created by AdminTest on 2017/8/3.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATFaceManager.h"
#import "NSAttributedString+YYText.h"

static NSString *const QQEmotionString = @"0-[微笑];1-[撇嘴];2-[色];3-[发呆];4-[得意];5-[流泪];6-[害羞];7-[闭嘴];8-[睡];9-[大哭];10-[尴尬];11-[发怒];12-[调皮];13-[呲牙];14-[惊讶];15-[难过];16-[酷];17-[冷汗];18-[抓狂];19-[吐];20-[偷笑];21-[可爱];22-[白眼];23-[傲慢];24-[饥饿];25-[困];26-[惊恐];27-[流汗];28-[憨笑];29-[大兵];30-[奋斗];31-[咒骂];32-[疑问];33-[嘘];34-[晕];35-[折磨];36-[衰];37-[骷髅];38-[敲打];39-[再见];40-[擦汗];41-[抠鼻];42-[鼓掌];43-[糗大了];44-[坏笑];45-[左哼哼];46-[右哼哼];47-[哈欠];48-[鄙视];49-[委屈];50-[快哭了];51-[阴险];52-[亲亲];53-[吓];54-[可怜];55-[菜刀];56-[西瓜];57-[啤酒];58-[篮球];59-[乒乓];60-[咖啡];61-[饭];62-[猪头];63-[玫瑰];64-[凋谢];65-[示爱];66-[爱心];67-[心碎];68-[蛋糕];69-[闪电];70-[炸弹];71-[刀];72-[足球];73-[瓢虫];74-[便便];75-[月亮];76-[太阳];77-[礼物];78-[拥抱];79-[强];80-[弱];81-[握手];82-[胜利];83-[抱拳];84-[勾引];85-[拳头];86-[差劲];87-[爱你];88-[NO];89-[OK];90-[爱情];91-[飞吻];92-[跳跳];93-[发抖];94-[怄火];95-[转圈];96-[磕头];97-[回头];98-[跳绳];99-[挥手];100-[激动];101-[街舞];102-[献吻];103-[左太极];104-[右太极];105-[嘿哈];106-[捂脸];107-[奸笑];108-[机智];109-[皱眉];110-[耶];111-[红包];112-[鸡]";

static NSArray * _emojiEmotions,*_custumEmotions,*gifEmotions,*_qmuiEmotions;

@implementation ATFaceManager

+ (NSArray *)emojiEmotions
{
    if (_emojiEmotions) {
        return _emojiEmotions;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_face.plist" ofType:nil];
    
    NSMutableArray<ATFace *> *faces = [[NSMutableArray alloc] init];
    NSArray<NSDictionary *> *emotionArray = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *emotion in emotionArray) {
        ATFace *face = [ATFace emotionWithIdentifier:emotion[@"face_id"] displayName:emotion[@"face_name"]];
        [faces addObject:face];
    }
    _emojiEmotions = [NSArray arrayWithArray:faces];
    return _emojiEmotions;
}

+ (NSArray *)qmuiEmotions
{
    if (_qmuiEmotions) {
        return _qmuiEmotions;
    }
    NSMutableArray<ATFace *> *emotions = [[NSMutableArray alloc] init];
    NSArray<NSString *> *emotionStringArray = [QQEmotionString componentsSeparatedByString:@";"];
    for (NSString *emotionString in emotionStringArray) {
        NSArray<NSString *> *emotionItem = [emotionString componentsSeparatedByString:@"-"];
        NSString *identifier = [NSString stringWithFormat:@"smiley_%@", emotionItem.firstObject];
        ATFace *emotion = [ATFace emotionWithIdentifier:identifier displayName:emotionItem.lastObject];
        [emotions addObject:emotion];
    }
    _qmuiEmotions = [NSArray arrayWithArray:emotions];
    return _qmuiEmotions;
}

+ (NSString *)getFaceNameByFaceID:(NSString *)idx
{
    NSString *smiley_idx = [@"smiley_" stringByAppendingString:idx];
    NSArray *faceArr = [self qmuiEmotions];
    for (ATFace *face in faceArr) {
        if ([face.face_id isEqualToString:smiley_idx]) {
            return face.face_name;
        }
    }
    return @"";
}

+ (NSString *)getFaceIDByFaceName:(NSString *)faceName
{
    NSArray *faceArr = [self emojiEmotions];
    for (ATFace *face in faceArr) {
        if ([faceName isEqualToString:face.face_name]) {
            return face.face_id;
        }
    }
    return @"";
}


+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                               color:(UIColor *)color
                                                font:(UIFont *)font
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:message];

    [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeStr.length)];
    if (color) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributeStr.length)];
    }
    
    NSArray *resultArray = [self faceTextCheckingResultWithContent:message];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    if (!ATArrayIsEmpty(resultArray)) {
        NSArray *faceArr = [self qmuiEmotions];
        for (NSTextCheckingResult *match in resultArray) {
            NSRange range    = match.range;
            NSString *faceName = [message substringWithRange:range];
            for (ATFace *face in faceArr) {
                if ([face.face_name isEqualToString:faceName]) {
                    
                    //                NSTextAttachment *image = [[NSTextAttachment alloc] init];
                    //                image.image = UIImageMake(face.face_name);
                    //                image.bounds = CGRectMake(0, 0, lineHeight, lineHeight);
                    
                    UIImage *image = [self QMUIImageMake:face.face_id];
                    
                    NSAttributedString *attachment = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:font.lineHeight];
                    //                NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:image];
                    
                    NSDictionary *faceDic = @{@"image" : attachment,
                                              @"range" : [NSValue valueWithRange:range]};
                    [tempArray addObject:faceDic];
                    break;
                }
            }
        }
        
        for (int i = (int)tempArray.count - 1; i >= 0; i--) {
            NSRange range;
            [tempArray[i][@"range"] getValue:&range];
            [attributeStr replaceCharactersInRange:range withAttributedString:tempArray[i][@"image"]];
        }
    }

    return attributeStr;
}

+ (NSArray<NSTextCheckingResult *> *)faceTextCheckingResultWithContent:(NSString *)content
{
    NSString *regEmj  = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";// [微笑]、［哭］等自定义表情处理
    NSError *error    = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regEmj options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!expression) {
        NSLog(@"faceTextCheckingResultWithContent:%@",error);
    }
    
    NSArray *res = [expression matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    return res;
}

+ (UIImage *)QMUIImageMake:(NSString *)faceID
{
    UIImage *image = [QMUIHelper imageInBundle:[QMUIHelper resourcesBundleWithName:QMUIResourcesQQEmotionBundleName] withName:faceID];
    return image;
}

@end
