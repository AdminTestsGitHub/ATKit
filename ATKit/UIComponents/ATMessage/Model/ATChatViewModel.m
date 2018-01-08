//
//  ATChatViewModel.m
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatViewModel.h"
#import "ATChatBaseCell.h"
#import "YYTextLayout.h"

@implementation ATChatViewModel

+ (instancetype)modelWithMessage:(ATMessage *)msg
{
    return [[ATChatViewModel alloc] initWithMessage:msg];
}

- (instancetype)initWithMessage:(ATMessage *)msg
{
    self = [super init];
    if (self) {
        [self configWithMessage:msg];
    }
    return self;
}

- (void)configWithMessage:(ATMessage *)msg
{
    self.msg = msg;
    
    BOOL left = !self.msg.isSender;
    BOOL showName = self.msg.isGroup ? left : NO;
    
    CGFloat arrowWidth    = 7;      // 气泡箭头
    CGFloat contentEdgeInsets = 10; //气泡文字的内边距
    CGFloat contentMaxWidth = SCREEN_WIDTH - ATChatCellPadding * 2 - ATChatCellHeaderSize * 2 - arrowWidth * 2 - contentEdgeInsets * 2;
    
    _headImageViewF = CGRectMake(left ?
                                 ATChatCellPadding :
                                 SCREEN_WIDTH - ATChatCellHeaderSize - ATChatCellPadding,
                                 ATChatCellPadding,
                                 ATChatCellHeaderSize,
                                 ATChatCellHeaderSize
                                 );
    if (showName) {
        _nameLabelF = CGRectMake(CGRectGetMaxX(_headImageViewF) + arrowWidth, CGRectGetMinY(_headImageViewF), 200, 20);
    } else {
        _nameLabelF = CGRectZero;
    }
    
    if (msg.msgType == ATMessageType_Text) { // 文字 或者  表情
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(contentMaxWidth, CGFLOAT_MAX)];
        NSAttributedString *text = [ATFaceManager transferMessageString:self.msg.content color:nil font:ATChatMessageFont];

        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:text];
        
        CGSize bubbleSize = CGSizeMake(textLayout.textBoundingSize.width + contentEdgeInsets * 2 + arrowWidth, textLayout.textBoundingSize.height + contentEdgeInsets * 2);
        
        _bubbleViewF = CGRectMake(left ?
                                  CGRectGetMaxX(_headImageViewF) + arrowWidth:
                                  CGRectGetMinX(_headImageViewF) - arrowWidth - bubbleSize.width,
                                  CGRectGetMinY(_headImageViewF) + 5 + CGRectGetHeight(_nameLabelF),
                                  bubbleSize.width,
                                  bubbleSize.height
                                  );
        
        _chatLabelF = CGRectMake(
                                 CGRectGetMinX(_bubbleViewF) + contentEdgeInsets + (left ? arrowWidth : 0),
                                 CGRectGetMinY(_bubbleViewF) + contentEdgeInsets,
                                 textLayout.textBoundingSize.width,
                                 textLayout.textBoundingSize.height
                                 );
        
    } else if (msg.msgType == ATMessageType_Image) {
        CGSize imageSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        if (!ATArrayIsEmpty(self.msg.imageList)) {
            CGSize originSize = self.msg.imageSize;
            imageSize = [self handleScaleImage:originSize];
        } else {
            if (self.msg.sendMediaPath) {
                UIImage *sendImage = [UIImage imageWithContentsOfFile:self.msg.sendMediaPath];
                CGSize oriSize = sendImage.size;
                imageSize = [self handleScaleImage:oriSize];
            } else {//针对发送失败的临时解决办法 防止crash 补充完failedMsg之后删除
                imageSize = [self handleScaleImage:imageSize];
            }
        }
        
        
        CGSize bubbleSize      = CGSizeMake(imageSize.width + arrowWidth, imageSize.height);
        _bubbleViewF           = CGRectMake(left ?
                                            CGRectGetMaxX(_headImageViewF) + arrowWidth:
                                            CGRectGetMinX(_headImageViewF) - arrowWidth - bubbleSize.width,
                                            CGRectGetMinY(_headImageViewF) + 5 + CGRectGetHeight(_nameLabelF),
                                            bubbleSize.width,
                                            bubbleSize.height
                                            );

        _picViewF = CGRectMake(CGRectGetMinX(_bubbleViewF),
                               CGRectGetMinY(_bubbleViewF),
                               imageSize.width + arrowWidth,
                               imageSize.height);
        
    } else if (msg.msgType == ATMessageType_Voice) {
        int sec = self.msg.mediaDuration;
        CGFloat bubbleMaxWidth = 250;
        CGFloat radio = bubbleMaxWidth / ATChatVoiceMaxSecond;
        CGFloat bubbleMinWidth = 50;
        CGFloat width = bubbleMinWidth + sec * radio;
        
        CGSize bubbleSize = CGSizeMake(width, 40);

        _bubbleViewF = CGRectMake(left ?
                                  CGRectGetMaxX(_headImageViewF) + arrowWidth:
                                  CGRectGetMinX(_headImageViewF) - arrowWidth - bubbleSize.width,
                                  CGRectGetMinY(_headImageViewF) + 3 + CGRectGetHeight(_nameLabelF),
                                  bubbleSize.width,
                                  bubbleSize.height
                                  );
        
        _voiceIconF = CGRectMake(left ?
                                 CGRectGetMinX(_bubbleViewF) + arrowWidth + ATChatCellPadding :
                                 CGRectGetMaxX(_bubbleViewF) - arrowWidth - ATChatCellPadding * 2,
                                 CGRectGetMinY(_bubbleViewF) + 12,
                                 11,
                                 16.5);// - 20

        _durationLabelF = CGRectMake(left ?
                                     CGRectGetMaxX(_bubbleViewF) + 6 :
                                     CGRectGetMinX(_bubbleViewF) - (sec > 9 ? 28 : 20),
                                     CGRectGetMinY(_bubbleViewF) + ATChatCellPadding * 2 - 5,
                                     50,
                                     20);
        if (left) {
            _redViewF = CGRectMake(CGRectGetMaxX(_bubbleViewF) + 8,
                                   CGRectGetMinY(_bubbleViewF) + 2,
                                   8,
                                   8);
        }
    } else if (msg.msgType == ATMessageType_Video) {
        CGSize imageSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        if (!ATStringIsEmpty(self.msg.coverTempPath)) {
            UIImage *videoImage = [UIImage imageWithContentsOfFile:self.msg.coverTempPath];
            CGSize originSize = CGSizeMake(videoImage.size.width, videoImage.size.height);
            imageSize = [self handleScaleImage:originSize];
        } else {
            CGSize originSize = self.msg.imageSize;
            imageSize = [self handleScaleImage:originSize];
        }
        
        CGSize bubbleSize = CGSizeMake(imageSize.width, imageSize.height);
        _bubbleViewF = CGRectMake(left ?
                                  CGRectGetMaxX(_headImageViewF) + arrowWidth:
                                  CGRectGetMinX(_headImageViewF) - arrowWidth - bubbleSize.width,
                                  CGRectGetMinY(_headImageViewF) + 3 + CGRectGetHeight(_nameLabelF),
                                  bubbleSize.width,
                                  bubbleSize.height
                                  );
        _picViewF = CGRectMake(CGRectGetMinX(_bubbleViewF),
                               CGRectGetMinY(_bubbleViewF),
                               imageSize.width ,
                               imageSize.height);
    } else if (msg.msgType == ATMessageType_Location) {
        CGSize imageSize = CGSizeMake(150, 150);
        CGSize bubbleSize      = CGSizeMake(imageSize.width + arrowWidth, imageSize.height);
        _bubbleViewF           = CGRectMake(left ?
                                            CGRectGetMaxX(_headImageViewF) + arrowWidth:
                                            CGRectGetMinX(_headImageViewF) - arrowWidth - bubbleSize.width,
                                            CGRectGetMinY(_headImageViewF) + 5 + CGRectGetHeight(_nameLabelF),
                                            bubbleSize.width,
                                            bubbleSize.height
                                            );
        
        _picViewF = CGRectMake(CGRectGetMinX(_bubbleViewF),
                               CGRectGetMinY(_bubbleViewF),
                               imageSize.width + arrowWidth,
                               imageSize.height);

    } else if (msg.msgType == ATMessageType_File) {
        
    } else if (msg.msgType == ATMessageType_ProfileSystem) {
        //走系统消息
        _headImageViewF = CGRectMake(
                                     ATChatCellPadding,
                                     ATChatCellPadding,
                                     ATChatCellHeaderSize,
                                     ATChatCellHeaderSize
                                     );
         CGSize contentSize = [self.msg.content sizeThatFitsMaxWidth:contentMaxWidth andFont:ATChatMessageFont];
         CGSize bubbleSize = CGSizeMake(contentSize.width + contentEdgeInsets * 2 + arrowWidth, contentSize.height + contentEdgeInsets * 2);

        _bubbleViewF = CGRectMake(
                                  CGRectGetMaxX(_headImageViewF) + arrowWidth,
                                  CGRectGetMinY(_headImageViewF) + 5 + CGRectGetHeight(_nameLabelF),
                                  bubbleSize.width,
                                  bubbleSize.height
                                  );
        
        _chatLabelF = CGRectMake(
                                 CGRectGetMinX(_bubbleViewF) + contentEdgeInsets + (left ? arrowWidth : 0),
                                 CGRectGetMinY(_bubbleViewF) + contentEdgeInsets,
                                 contentSize.width,
                                 contentSize.height
                                 );

    }
    
    _activityF = left ? CGRectZero : CGRectMake(_bubbleViewF.origin.x - 40, _bubbleViewF.origin.y + (_bubbleViewF.size.height - 40) / 2, 40, 40);
    
    _cellHight = MAX(CGRectGetMaxY(_bubbleViewF), CGRectGetMaxY(_headImageViewF)) + ATChatCellPadding;


    //tip类型的消息单独计算cell高度 因为tip没有头像
    if (msg.msgType == ATMessageType_TipRevoke) {
        CGFloat margin = 5; //contentEdge 
        CGSize size = [self.msg.content sizeThatFitsMaxWidth:contentMaxWidth andFont:ATChatTipFont];

        _tipLabelF = CGRectMake((SCREEN_WIDTH - size.width - margin * 2) / 2, margin, size.width + margin * 2, size.height + margin * 2);
        _activityF = CGRectZero;
        _cellHight = CGRectGetMaxY(_tipLabelF) + margin;
    } else if (msg.msgType == ATMessageType_Tipe || msg.msgType == ATMessageType_GroupTips || msg.msgType == ATMessageType_GroupSystem ) {
        CGFloat paddingTop = msg.msgType == ATMessageType_Tipe ? 3 : 8;
        CGFloat contentEdge = msg.msgType == ATMessageType_Tipe ? 3 : 5;
        UIFont *font = msg.msgType == ATMessageType_Tipe ? ATChatTimeTipFont : ATChatTipFont;
        CGSize size = [self.msg.content sizeThatFitsMaxWidth:contentMaxWidth andFont:font];
        
        _tipLabelF = CGRectMake((SCREEN_WIDTH - size.width - contentEdge * 2) / 2, paddingTop, size.width + contentEdge * 2, size.height + contentEdge * 2);
        _activityF = CGRectZero;
        _cellHight = CGRectGetMaxY(_tipLabelF) + paddingTop;
    } else if (msg.msgType == ATMessageType_Custom) {
        NSLog(@"ATMessageType_Custom:%@", msg);
    }
}

// 缩放，临时的方法 
- (CGSize)handleScaleImage:(CGSize)retSize
{
    CGFloat scaleH = 0.22;
    CGFloat scaleW = 0.38;
    CGFloat height = 0;
    CGFloat width = 0;
    if (retSize.height / SCREEN_HEIGHT + 0.16 > retSize.width / SCREEN_WIDTH) {
        height = SCREEN_HEIGHT * scaleH;
        width = retSize.width / retSize.height * height;
    } else {
        width = SCREEN_WIDTH * scaleW;
        height = retSize.height / retSize.width * width;
    }
    return CGSizeMake(width, height);
}


- (ATChatBaseCell *)tableView:(UITableView *)tableView type:(int)type
{
    NSString *reuseid = [NSString stringWithFormat:@"ATChatCell_%d", (int)self.msg.msgType];
    ATChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        if (type == ATConversationType_C2C) {
            cell = [[self.msg.cellClass alloc] initWithType:ATChatCellType_C2C reuseIdentifier:reuseid];
        } else if (type == ATConversationType_Group) {
            cell = [[self.msg.cellClass alloc] initWithType:ATChatCellType_Group reuseIdentifier:reuseid];
        } else {
            cell = [[self.msg.cellClass alloc] initWithType:ATChatCellType_System reuseIdentifier:reuseid];
//            NSLog(@"不支持该类型的Cell，请检查代码逻辑");
//            NSException *e = [NSException exceptionWithName:@"不支持该类型的Cell" reason:@"不支持该类型的Cell" userInfo:nil];
//            @throw e;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

@end
