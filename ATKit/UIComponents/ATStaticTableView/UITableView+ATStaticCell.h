//
//  UITableView+ATStaticCell.h
//  DPCA
//
//  Created by AdminTest on 2017/12/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATStaticTableViewCellDataSource;

/**
 *  配合 ATStaticTableViewCellDataSource 使用，主要负责：
 *  1. 提供 property 去绑定一个 static dataSource
 *  2. 提供 property 去绑定一个 static delegate
 *  3. 重写 setDataSource:、setDelegate: 方法，自动实现 UITableViewDataSource、UITableViewDelegate 里一些必要的方法
 *
 *  使用方式：初始化一个 ATStaticTableViewCellDataSource 并将其赋值给 at_staticCellDataSource 属性即可。
 *
 *  @warning 当要动态更新 dataSource 时，可直接修改 self.at_staticCellDataSource.cellDataSections 数组，或者创建一个新的 ATStaticTableViewCellDataSource。不管用哪种方法，都不需要手动调用 reloadData，tableView 会自动刷新的。
 */
@interface UITableView (ATStaticCell)

@property (nonatomic, strong) ATStaticTableViewCellDataSource *at_staticCellDataSource;
@property (nonatomic, strong) id at_staticCellDelegate;

@end
