//
//  ATSegmentedViewController.m
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATSegmentedViewController.h"
#import "ATSegmentedSectionView.h"

@interface ATSegmentedViewController () <ATSegmentedHeaderViewDelegate, ATSegmentedBottomScrollViewDelegate, ATSegmentedSectionHeaderViewDelegate>

@end

@implementation ATSegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.segmentedView];
    [self.view addSubview:self.bottomScrollView];
}

#pragma mark - Private Methods
- (void)loadData
{
    //子类实现
}

- (void)loadMoreData
{
    //子类实现
}

- (void)cellDidSelectWithCellData:(id)data
{
    //子类实现
}

- (void)cellDidClickWithPersonData:(id)data
{
    //子类实现
}

- (void)postDataWithInfo:(id)info
{
    //子类实现
}

- (void)loadCurrentPageDataWithIndex:(int)idx
{
    if (!self.currentVC.hasLoadData) {
        [self loadData];
        self.currentVC.hasLoadData = YES;
    }
}

#pragma mark - UITableViewDataSource


#pragma mark - UITableViewDelegate


#pragma mark - CustomDelegate
#pragma mark - ATSegmentedHeaderViewDelegate
- (void)ATSegmentedView:(ATSegmentedHeaderView *)view didSelectItemWithTitle:(NSString *)title index:(int)idx
{
    [self.bottomScrollView scrollTableViewToIndex:idx animated:YES];
    [self loadCurrentPageDataWithIndex:idx];
}

#pragma mark - ATSegmentedBottomScrollViewDelegate
- (void)ATSegmentedBottomScrollView:(ATSegmentedBottomScrollView *)view currentTableView:(UITableView *)currentTableView indexDidChange:(int)idx
{
    [self.segmentedView scrollItemToIndex:idx];
    [self loadCurrentPageDataWithIndex:idx];
}

#pragma mark - ATSegmentedSectionHeaderViewDelegate
- (void)ATSegmentedSectionHeaderView:(ATSegmentedSectionHeaderView *)view didClickBtnWithData:(id)data
{

}

#pragma mark - Event Response


#pragma mark - Getters And Setters
- (ATSegmentedHeaderView *)segmentedView
{
    if (!_headerView) {
        _headerView = ({
            ATSegmentedHeaderView *view = [[ATSegmentedHeaderView alloc] initWithTitles:self.titles];
            [view setRedInIdex:@[@(0), @(1), @(1), @(1), @(0)]];
            view.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 44);
            view.delegate = self;
            view;
        });
    }
    return _headerView;
}

- (ATSegmentedBottomScrollView *)bottomScrollView
{
    if (!_bottomScrollView) {
        _bottomScrollView = ({
            ATSegmentedBottomScrollView *view = [[ATSegmentedBottomScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - self.headerView.maxY) delegate:self count:self.titles.count  subVCClassStr:self.subVCClassName ? : @"ATSegmentedSubViewController"];
            view;
        });
    }
    return _bottomScrollView;
}

- (UITableView *)currentTableView
{
    return self.bottomScrollView.currentTableView;
}

- (int)currentIndex
{
    return self.bottomScrollView.currentTableViewIndex;
}

- (UIViewController<ATSubViewControllerProtocol> *)currentVC
{
    return self.bottomScrollView.currentVC;
}


@end
