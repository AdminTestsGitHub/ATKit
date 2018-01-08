//
//  ATChatTipCell.m
//  MiLin
//
//  Created by AdminTest on 2017/8/9.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatTipCell.h"
#import "YYLabel.h"

@implementation ATChatTipCell

- (void)addSubviews
{
    self.tipLabel.font = ATChatTipFont;
    self.tipLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [self.contentView addSubview:self.tipLabel];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    self.tipLabel.frame = vm.tipLabelF;
    self.tipLabel.text = vm.msg.content;
}

- (YYLabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = ({
            YYLabel *label = [[YYLabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = UIColorWhite;
            label.backgroundColor = UIColorMake(203, 203, 203);
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 3;
            label.layer.masksToBounds = YES;
            
            label;
        });
    }
    return _tipLabel;
}


@end




@implementation ATChatTimeTipCell


- (void)addSubviews
{
    self.tipLabel.font = ATChatTimeTipFont;
    
    [self.contentView addSubview:self.tipLabel];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    self.tipLabel.frame = vm.tipLabelF;
    self.tipLabel.text = vm.msg.content;
}


@end


@implementation ATChatRevokeTipCell

- (void)addSubviews
{
    [super addSubviews];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    [super configWithModel:vm];
}
@end


@implementation ATChatGroupTipCell

- (void)addSubviews
{
    self.tipLabel.font = ATChatTipFont;
    
    [self.contentView addSubview:self.tipLabel];
}

- (void)configWithModel:(ATChatViewModel *)vm
{
    self.tipLabel.frame = vm.tipLabelF;
    self.tipLabel.text = vm.msg.content;
}

@end




@implementation ATChatSaftyTipCell


@end


