//
//  ATSubViewControllerProtocol.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATSubViewControllerProtocol <NSObject>

@required
- (UITableView *)innerTableView;
@property (nonatomic, strong) NSMutableArray *currentDatas;

@optional
@property (nonatomic, strong) NSMutableArray *userInfo;


@end
