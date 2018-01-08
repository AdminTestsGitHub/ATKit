//
//  ATChatSystemCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/29.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatSystemCell.h"

@implementation ATChatSystemCell

- (void)addSubviews
{
    [super addSubviews];
    [self.contentView addSubview:self.systemLabel];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    [super configWithModel:vm];
    
    self.systemLabel.frame = vm.chatLabelF;
    
    NSDictionary *attributes = @{NSFontAttributeName : ATChatMessageFont};
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:vm.msg.content attributes:attributes];
    
    [self.systemLabel setAttributedText:text];
}

- (UILabel *)systemLabel
{
    if (nil == _systemLabel) {
        _systemLabel = [[UILabel alloc] init];
        _systemLabel.numberOfLines = 0;
        _systemLabel.font = ATChatMessageFont;
        _systemLabel.textColor = UIColorMakeWithHex(@"282724");
    }
    return _systemLabel;
}
@end
