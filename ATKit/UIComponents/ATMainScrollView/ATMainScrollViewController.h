//
//  ATMainScrollViewController.h
//  MiLin
//
//  Created by AdminTest on 2017/9/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATScrollTopBar.h"

@interface ATMainScrollViewController : UIViewController

@property (nonatomic, strong) ATScrollTopBar *topBar;

@property (nonatomic, strong) UIScrollView *mainScrollView;

- (instancetype)initWithScrollTopBarAdd:(BOOL)isAdd;

//加载控制器的类
- (void)loadVC:(NSArray *)viewcontrollerClass AndTitle:(NSArray *)titles;

/**
 子类重写
 
 @return 控制器和title数组
 */
- (NSArray *)getViewControllerClass;
- (NSArray *)getViewControllerTitles;


@end
