//
//  ATScrollPageViewProtocol.h
//  MiLin
//
//  Created by AdminTest on 2017/9/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATScrollPageViewProtocol <NSObject>

@optional
- (void)resetDataSource:(NSDictionary *)userInfo;
- (void)refreshTableWithCacheData:(id)type;
- (void)loadTableData;
- (void)autoLoadTableData;
- (void)setIsCurrentPage:(BOOL)isCurrentPage;
- (BOOL)isCurrentPage;
- (void)frequenceFilteableReload;



@end
