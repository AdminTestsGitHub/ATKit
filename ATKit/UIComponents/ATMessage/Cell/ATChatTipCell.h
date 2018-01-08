//
//  ATChatTipCell.h
//  MiLin
//
//  Created by AdminTest on 2017/8/9.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatBaseCell.h"

@class YYLabel;

@interface ATChatTipCell : ATChatBaseCell

@property (nonatomic, strong) YYLabel *tipLabel;

@end


@interface ATChatTimeTipCell : ATChatTipCell

@end

@interface ATChatRevokeTipCell : ATChatTipCell

@end


@interface ATChatGroupTipCell : ATChatTipCell

@end


@interface ATChatSaftyTipCell : ATChatTipCell

@end

