//
//  ATStaticTableViewCellData.m
//  DPCA
//
//  Created by AdminTest on 2017/12/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATStaticTableViewCellData.h"

@implementation ATStaticTableViewCellData

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellClass = [UITableViewCell class];
        self.height = TableViewCellNormalHeight;
    }
    return self;
}

- (void)setCellClass:(Class)cellClass {
    NSAssert([cellClass isSubclassOfClass:[UITableViewCell class]], @"%@.cellClass 必须为 ATTableViewCell 的子类", NSStringFromClass(self.class));
    _cellClass = cellClass;
}

+ (UITableViewCellAccessoryType)systemTableViewCellAccessoryTypeWithATStaticTableViewCellType:(ATStaticTableViewCellType)type {
    switch (type) {
        case ATStaticTableViewCellTypeDisclosureIndicator:
            return UITableViewCellAccessoryDisclosureIndicator;
        case ATStaticTableViewCellTypeDetailDisclosureButton:
            return UITableViewCellAccessoryDetailDisclosureButton;
        case ATStaticTableViewCellTypeCheckmark:
            return UITableViewCellAccessoryCheckmark;
        case ATStaticTableViewCellTypeDetailButton:
            return UITableViewCellAccessoryDetailButton;
        case ATStaticTableViewCellTypeSwitch:
        default:
            return UITableViewCellAccessoryNone;
    }
}


@end
