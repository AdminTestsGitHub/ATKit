//
//  ATChatTextCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/2.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatTextCell.h"
#import "YYLabel.h"

@implementation ATChatTextCell

- (void)addSubviews
{
    [super addSubviews];
    [self.contentView addSubview:self.chatLabel];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    [super configWithModel:vm];
    
    self.chatLabel.frame = vm.chatLabelF;
    
    NSAttributedString *text = [ATFaceManager transferMessageString:vm.msg.content color:nil font:ATChatMessageFont];
    
    [self.chatLabel setAttributedText:text];
    /* 超链样式 匹配url逻辑待补充
    NSMutableAttributedString * one = vm.msg.attributedText.mutableCopy;
    one.yy_underlineStyle = NSUnderlineStyleSingle;

    [one yy_setTextHighlightRange:one.yy_rangeOfAll
                            color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                  backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                        tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                            [ATTips tipsWithMessage:@"点击了"];
                        }];
    [self.chatLabel setAttributedText:one];
     */
}

#pragma mark - Private Method
- (void)attemptOpenURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警示" message:@"您的链接无效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Getter and Setter
- (YYLabel *)chatLabel
{
    if (nil == _chatLabel) {
        _chatLabel = [[YYLabel alloc] init];
        _chatLabel.numberOfLines = 0;
        _chatLabel.font = ATChatMessageFont;
        _chatLabel.textColor = UIColorMakeWithHex(@"282724");
    }
    return _chatLabel;
}


@end
