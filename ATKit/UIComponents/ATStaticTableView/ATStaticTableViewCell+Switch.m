//
//  ATStaticTableViewCell+Switch.m
//  DPCA
//
//  Created by AdminTest on 2017/12/19.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATStaticTableViewCell+Switch.h"

@implementation ATStaticTableViewCell (Switch)

- (void)configSwitchCellWithCellData:(ATStaticTableViewCellData *)data
{
    [self.indicatorSwitch setOn:[((NSNumber *)data.ValueObject) boolValue]];
    [self.indicatorSwitch removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.indicatorSwitch addTarget:data.Target action:data.Action forControlEvents:UIControlEventValueChanged];
    self.accessoryView = self.indicatorSwitch;
}

@end
