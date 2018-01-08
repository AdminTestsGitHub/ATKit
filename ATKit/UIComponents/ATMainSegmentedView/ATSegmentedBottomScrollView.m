//
//  ATSegmentedBottomScrollView.m
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATSegmentedBottomScrollView.h"

@interface ATSegmentedBottomScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation ATSegmentedBottomScrollView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<ATSegmentedBottomScrollViewDelegate>)delegate count:(NSInteger)count subVCClassStr:(NSString *)clsStr;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.count = count;
        self.delegate = delegate;
        self.currentVCClass = clsStr;

        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < self.count; i++) {
        UIViewController<ATSubViewControllerProtocol> *subViewController;
        Class cls = NSClassFromString(self.currentVCClass);
        subViewController = [[cls alloc] init];
        
        subViewController.innerTableView.backgroundColor = [UIColor qmui_randomColor];
        [subViewController setUserInfo:@{@"index" : @(i), @"fatherVC" : self.delegate}.mutableCopy];
        subViewController.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.height);
        
        [self.scrollView addSubview:subViewController.view];
        
        [self.controlleres addObject:subViewController];
        [self.tableViews addObject:subViewController.innerTableView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.controlleres.count * SCREEN_WIDTH, 0);
    [self scrollTableViewToIndex:0 animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat tableViewContentOffsetX = scrollView.contentOffset.x;
    self.currentTableViewIndex = tableViewContentOffsetX / SCREEN_WIDTH;
    self.currentTableView = self.tableViews[self.currentTableViewIndex];
    self.currentVC = self.controlleres[self.currentTableViewIndex];
    
    if (self.currentTableViewIndex != self.previousTableViewIndex) {
        self.previousTableViewIndex = self.currentTableViewIndex;
        if (self.delegate && [self.delegate respondsToSelector:@selector(ATSegmentedBottomScrollView:currentTableView:indexDidChange:)]) {
            [self.delegate ATSegmentedBottomScrollView:self currentTableView:self.currentTableView indexDidChange:self.currentTableViewIndex];
        }
    }
}

- (void)scrollTableViewToIndex:(int)idx animated:(BOOL)animated
{
    self.currentTableView = self.tableViews[idx];
    self.currentVC = self.controlleres[idx];
    self.currentTableViewIndex = idx;
    self.previousTableViewIndex = idx;
    
    if (animated) {
        ATWeak;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * idx, 0);
        }];
    } else {
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * idx, 0);
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.bounds];
            view.backgroundColor = UIColorMakeWithHex(@"f0f0f0");
            view.pagingEnabled = YES;
            view.showsHorizontalScrollIndicator = NO;
            view.showsVerticalScrollIndicator = NO;
            view.delegate = self;
            view;
        });
    }
    return _scrollView;
}

- (NSMutableArray *)controlleres
{
    if (!_controlleres) {
        _controlleres = [[NSMutableArray alloc] init];
    }
    return _controlleres;
}

- (NSMutableArray *)tableViews
{
    if (!_tableViews) {
        _tableViews = [[NSMutableArray alloc] init];
    }
    return _tableViews;
}


@end
