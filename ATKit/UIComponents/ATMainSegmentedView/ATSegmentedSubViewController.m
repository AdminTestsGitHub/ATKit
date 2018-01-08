//
//  ATSegmentedSubViewController.m
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATSegmentedSubViewController.h"
#import "ATSegmentedViewController.h"
#import "ATSegmentedSectionView.h"

static NSString *const kCellIdentifier = @"ATSegmentedSubViewControllerID";


@interface ATSegmentedSubViewController () <ATSegmentedSectionFooterViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) ATSegmentedViewController<ATSegmentedSectionHeaderViewDelegate> *fatherVC;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ATSegmentedSubViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMakeWithHex(@"f0f0f0");
    ATWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.fatherVC loadData];
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - Private Methods
- (void)goToSquare
{
//    ATShareSquareViewController *vc = [[ATShareSquareViewController alloc] init];
//    [self.fatherVC.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
//    ATSegmentedCellHandlerModel *model = self.datas[indexPath.section];
//    [cell configWithModel:model.dataSource];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ATSegmentedSectionHeaderView *header = [[ATSegmentedSectionHeaderView alloc] initWithConfigModel:self.datas[section]];
    header.tableView = tableView;
    header.section = section;
    header.type = SectionViewTypeHeader;
    header.delegate = self.fatherVC;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ATSegmentedSectionFooterView *footer = nil;
//    ATSegmentedCellHandlerModel *model = self.datas[section];
//
//    if (model.hasAction) {
//        footer = [[ATSegmentedSectionFooterView alloc] initWithConfigModel:self.datas[section]];
//        footer.tableView = tableView;
//        footer.section = section;
//        footer.type = SectionViewTypeFooter;
//        footer.delegate = self;
//    }
    
    return footer;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CustomDelegate
- (UITableView *)innerTableView
{
    return self.tableView;
}

- (void)setCurrentDatas:(NSMutableArray *)data
{
    self.datas = data;
    
    if (ATArrayIsEmpty(self.datas)) {
        
    }else{
        [self hideEmptyView];
    }
}

- (NSMutableArray *)currentDatas
{
    return self.datas;
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    self.index = [userInfo[@"index"] integerValue];
    self.fatherVC = userInfo[@"fatherVC"];
}

#pragma mark - ATSegmentedSectionHeaderViewDelegate
- (void)ATSegmentedSectionHeaderView:(ATSegmentedSectionHeaderView *)view didClickBtnWithData:(id)data
{

}

#pragma mark - ATSegmentedSectionFooterViewDelegate
- (void)ATSegmentedSectionFooterView:(ATSegmentedSectionFooterView *)view didClickBtnWithIndexPathSection:(NSInteger)section btnTitle:(NSString *)title index:(NSInteger)idx
{
    
}

#pragma mark - Event Response


#pragma mark - Getters And Setters

- (void)setHasMoreData:(BOOL)hasMoreData
{
    _hasMoreData = hasMoreData;
    if (hasMoreData) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self.fatherVC loadMoreData];
        }];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

@end
