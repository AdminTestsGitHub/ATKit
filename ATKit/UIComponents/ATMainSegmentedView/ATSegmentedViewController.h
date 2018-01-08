//
//  ATSegmentedViewController.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCommonViewController.h"
#import "ATSegmentedHeaderView.h"
#import "ATSegmentedBottomScrollView.h"
#import "ATSegmentedSubViewController.h"

@interface ATSegmentedViewController : ATCommonViewController

@property (nonatomic, strong) ATSegmentedHeaderView *headerView;
@property (nonatomic, strong) ATSegmentedBottomScrollView *bottomScrollView;

@property (nonatomic, strong) ATSegmentedSubViewController *currentVC;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) int currentIndex;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSDictionary *btnActions;

@property (nonatomic, copy) NSString *subVCClassName;

- (void)loadData;
- (void)loadMoreData;
- (void)cellDidSelectWithCellData:(id)data;
- (void)cellDidClickWithPersonData:(id)data;

- (void)postDataWithInfo:(id)info;

@end
