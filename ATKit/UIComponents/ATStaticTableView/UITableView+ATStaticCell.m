//
//  UITableView+ATStaticCell.m
//  DPCA
//
//  Created by AdminTest on 2017/12/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "UITableView+ATStaticCell.h"
#import "ATStaticTableViewCellDataSource.h"
#import <objc/runtime.h>
#import "ATStaticTableViewCell.h"

@interface ATStaticTableViewCellDataSource ()

@property(nonatomic, weak, readwrite) UITableView *tableView;

@end


@implementation UITableView (ATStaticCell)

#pragma mark - 方法-C对象、结构操作

+ (void)load {
    ReplaceMethod([UITableView class], @selector(setDataSource:), @selector(at_setDataSource:));
    ReplaceMethod([UITableView class], @selector(setDelegate:), @selector(at_setDelegate:));
}

static char kAssociatedObjectKey_staticCellDataSource;
- (void)setAt_staticCellDataSource:(ATStaticTableViewCellDataSource *)at_staticCellDataSource {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_staticCellDataSource, at_staticCellDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    at_staticCellDataSource.tableView = self;
}

- (ATStaticTableViewCellDataSource *)at_staticCellDataSource {
    return (ATStaticTableViewCellDataSource *)objc_getAssociatedObject(self, &kAssociatedObjectKey_staticCellDataSource);
}

static char kAssociatedObjectKey_staticCellDelegate;
- (void)setAt_staticCellDelegate:(id)at_staticCellDelegate {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_staticCellDelegate, at_staticCellDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = at_staticCellDelegate;
    self.dataSource = at_staticCellDelegate;
    [self reloadData];
}

- (id)at_staticCellDelegate {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_staticCellDelegate);
}

// 把那些已经手动 addMethod 过的 class 存起来，避免每次都触发 ATLog，打了一堆重复的信息
static NSMutableSet<NSString *> *at_staticTableViewAddedClass;

- (void)addSelector:(SEL)selector withImplementation:(IMP)implementation types:(const char *)types forObject:(NSObject *)object {
    if (!class_addMethod(object.class, selector, implementation, types)) {
        if (!at_staticTableViewAddedClass) {
            at_staticTableViewAddedClass = [[NSMutableSet alloc] init];
        }
        NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass(object.class), NSStringFromSelector(selector)];
        if (![at_staticTableViewAddedClass containsObject:identifier]) {
            ATLogInfo(@"%@, 尝试为 %@ 添加方法 %@ 失败，可能该类里已经实现了这个方法", NSStringFromClass(self.class), NSStringFromClass(object.class), NSStringFromSelector(selector));
            [at_staticTableViewAddedClass addObject:identifier];
        }
    }
}

#pragma mark - DataSource

NSInteger at_numberOfSections (id current_self, SEL current_cmd, UITableView *tableView) {
    return tableView.at_staticCellDataSource.cellDataSections.count;
}

NSInteger at_numberOfRows (id current_self, SEL current_cmd, UITableView *tableView, NSInteger section) {
    return tableView.at_staticCellDataSource.cellDataSections[section].count;
}

id at_cellForRow (id current_self, SEL current_cmd, UITableView *tableView, NSIndexPath *indexPath) {
    ATStaticTableViewCell *cell = [tableView.at_staticCellDataSource cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)at_setDataSource:(id<UITableViewDataSource>)dataSource {
    if (dataSource && self.at_staticCellDataSource) {
        // 这些 addMethod 的操作必须要在系统的 setDataSource 执行前就执行，否则 tableView 可能会认为不存在这些 method
        // 并且 addMethod 操作执行一次之后，直到 App 进程被杀死前都会生效，所以多次进入这段代码可能就会提示添加方法失败，请不用在意
        [self addSelector:@selector(numberOfSectionsInTableView:) withImplementation:(IMP)at_numberOfSections types:"l@:@" forObject:dataSource];
        [self addSelector:@selector(tableView:numberOfRowsInSection:) withImplementation:(IMP)at_numberOfRows types:"l@:@l" forObject:dataSource];
        [self addSelector:@selector(tableView:cellForRowAtIndexPath:) withImplementation:(IMP)at_cellForRow types:"@@:@@" forObject:dataSource];
    }
    
    [self at_setDataSource:dataSource];
}

#pragma mark - Delegate

CGFloat at_heightForRow (id current_self, SEL current_cmd, UITableView *tableView, NSIndexPath *indexPath) {
    return [tableView.at_staticCellDataSource heightForRowAtIndexPath:indexPath];
}

void at_didSelectRow (id current_self, SEL current_cmd, UITableView *tableView, NSIndexPath *indexPath) {
    [tableView.at_staticCellDataSource didSelectRowAtIndexPath:indexPath];
}

void at_accessoryButtonTapped (id current_self, SEL current_cmd, UITableView *tableView, NSIndexPath *indexPath) {
    [tableView.at_staticCellDataSource accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)at_setDelegate:(id<UITableViewDelegate>)delegate {
    if (delegate && self.at_staticCellDataSource) {
        // 这些 addMethod 的操作必须要在系统的 setDataSource 执行前就执行，否则 tableView 可能会认为不存在这些 method
        // 并且 addMethod 操作执行一次之后，直到 App 进程被杀死前都会生效，所以多次进入这段代码可能就会提示添加方法失败，请不用在意
        [self addSelector:@selector(tableView:heightForRowAtIndexPath:) withImplementation:(IMP)at_heightForRow types:"d@:@@" forObject:delegate];
        [self addSelector:@selector(tableView:didSelectRowAtIndexPath:) withImplementation:(IMP)at_didSelectRow types:"v@:@@" forObject:delegate];
        [self addSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:) withImplementation:(IMP)at_accessoryButtonTapped types:"v@:@@" forObject:delegate];
    }
    
    [self at_setDelegate:delegate];
}

@end
