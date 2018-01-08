//
//  ATStaticTableViewCellDataSource.m
//  DPCA
//
//  Created by AdminTest on 2017/12/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATStaticTableViewCellDataSource.h"
#import "ATStaticTableViewCellData.h"
#import "ATStaticTableViewCell.h"
#import "UITableView+ATStaticCell.h"

@implementation ATStaticTableViewCellDataSource

- (instancetype)initWithCellDataSections:(NSArray<NSArray<ATStaticTableViewCellData *> *> *)cellDataSections configuration:(ATStaticTableViewCellConfigurationBlock)configuration {
    if (self = [super init]) {
        self.cellDataSections = cellDataSections;
        self.configuration = configuration;
    }
    return self;
}

- (void)setCellDataSections:(NSArray<NSArray<ATStaticTableViewCellData *> *> *)cellDataSections {
    _cellDataSections = cellDataSections;
    [self.tableView reloadData];
}

// 在 UITableView (AT_StaticCell) 那边会把 tableView 的 property 改为 readwrite，所以这里补上 setter
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    // 触发 UITableView (AT_StaticCell) 里重写的 setter 里的逻辑
//    tableView.delegate = tableView.at_staticCellDelegate;
//    tableView.dataSource = tableView.at_staticCellDelegate;
}

@end


@interface ATStaticTableViewCellData (Manual)

@property(nonatomic, strong, readwrite) NSIndexPath *indexPath;
@end

@implementation ATStaticTableViewCellDataSource (Manual)

- (ATStaticTableViewCellData *)cellDataAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.cellDataSections.count) {
        ATLogInfo(@"cellDataWithIndexPath:%@, data not exist in section!", indexPath);
        return nil;
    }
    
    NSArray<ATStaticTableViewCellData *> *rowDatas = [self.cellDataSections objectAtIndex:indexPath.section];
    if (indexPath.row >= rowDatas.count) {
        ATLogInfo(@"cellDataWithIndexPath:%@, data not exist in row!", indexPath);
        return nil;
    }
    
    ATStaticTableViewCellData *cellData = [rowDatas objectAtIndex:indexPath.row];
    [cellData setIndexPath:indexPath];// 在这里才为 cellData.indexPath 赋值
    return cellData;
}

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    ATStaticTableViewCellData *data = [self cellDataAtIndexPath:indexPath];
    return [NSString stringWithFormat:@"cell_%@", @(data.identifier)];
}

- (ATStaticTableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ATStaticTableViewCellData *data = [self cellDataAtIndexPath:indexPath];
    if (!data) {
        return nil;
    }
    
    NSString *identifier = [self reuseIdentifierForCellAtIndexPath:indexPath];
    
    ATStaticTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ATStaticTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.data = data;
    cell.iconImageView.image = data.iconImage;
    cell.titleLabel.text = data.title;
    cell.subTitleLabel.text = data.subTitle;
    
    // 配置accessoryView
    if (data.type < 5) {//系统样式
        cell.accessoryType = [ATStaticTableViewCellData systemTableViewCellAccessoryTypeWithATStaticTableViewCellType:data.type];
    } else {//自定义的
        self.configuration(cell, data);
    }
    
    return cell;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATStaticTableViewCellData *cellData = [self cellDataAtIndexPath:indexPath];
    return cellData.height;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ATStaticTableViewCellData *cellData = [self cellDataAtIndexPath:indexPath];
    
    // 1、分发选中事件（UISwitch 类型不支持 didSelect）
    if ([cellData.didSelectTarget respondsToSelector:cellData.didSelectAction] && cellData.type != ATStaticTableViewCellTypeSwitch) {
        BeginIgnorePerformSelectorLeaksWarning
        [cellData.didSelectTarget performSelector:cellData.didSelectAction withObject:cellData];
        EndIgnorePerformSelectorLeaksWarning
    }
    
    // 2、处理点击状态（对checkmark类型的cell，选中后自动反选）
    if (cellData.type == ATStaticTableViewCellTypeCheckmark) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    ATStaticTableViewCellData *cellData = [self cellDataAtIndexPath:indexPath];
    if ([cellData.Target respondsToSelector:cellData.Action]) {
        BeginIgnorePerformSelectorLeaksWarning
        [cellData.Target performSelector:cellData.Action withObject:cellData];
        EndIgnorePerformSelectorLeaksWarning
    }
}

@end

