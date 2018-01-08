//
//  ATSegmentedBottomScrollView.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATSubViewControllerProtocol.h"

@protocol ATSegmentedBottomScrollViewDelegate;

@interface ATSegmentedBottomScrollView : UIView

@property (nonatomic, copy) NSString *currentVCClass;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *controlleres;
@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, strong) UIViewController<ATSubViewControllerProtocol> *currentVC;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) int currentTableViewIndex;
@property (nonatomic, assign) int previousTableViewIndex;//是否翻页

@property (nonatomic, weak) id<ATSegmentedBottomScrollViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<ATSegmentedBottomScrollViewDelegate>)delegate count:(NSInteger)count subVCClassStr:(NSString *)clsStr;

- (void)scrollTableViewToIndex:(int)idx animated:(BOOL)animated;

@end

@protocol ATSegmentedBottomScrollViewDelegate <NSObject>

@optional
- (void)ATSegmentedBottomScrollView:(ATSegmentedBottomScrollView *)view currentTableView:(UITableView *)currentTableView indexDidChange:(int)idx;

@end
