//
//  ATSegmentedSubViewController.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCommonTableViewController.h"
#import "ATSubViewControllerProtocol.h"

@interface ATSegmentedSubViewController : ATCommonTableViewController <ATSubViewControllerProtocol>

@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL hasLoadData;

@end
