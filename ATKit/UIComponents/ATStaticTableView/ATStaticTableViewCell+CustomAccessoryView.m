//
//  ATStaticTableViewCell+CustomAccessoryView.m
//  DPCA
//
//  Created by AdminTest on 2017/12/27.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATStaticTableViewCell+CustomAccessoryView.h"

@implementation ATStaticTableViewCell (CustomAccessoryView)

- (void)configCustomAccessoryViewCellWithCellData:(ATStaticTableViewCellData *)data
{
    if (data.customAccessoryView) {
        self.accessoryView = data.customAccessoryView;
    }
    
}

@end
