//
//  ATMainScrollViewController.m
//  MiLin
//
//  Created by AdminTest on 2017/9/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATMainScrollViewController.h"


static CGFloat kTopBarHeight = 40;

@interface ATMainScrollViewController () <UIScrollViewDelegate, ATScrollTopBarDelegate, NSCacheDelegate>

@property (nonatomic, strong) NSArray *subViewControllers;
@property (nonatomic, strong) NSMutableArray *controllerFrames;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSMutableDictionary *displayControllers;
@property (nonatomic, assign) int currentPage;
//控制器缓存
@property (nonatomic, strong) NSCache *controllerCache;

@property (nonatomic, assign) BOOL topBarIsAdd;

@end

@implementation ATMainScrollViewController

- (instancetype)initWithScrollTopBarAdd:(BOOL)isAdd
{
    self = [super init];
    if (self) {
        self.topBarIsAdd = isAdd;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    NSArray *titles = [self getViewControllerTitles];
    NSArray *viewClass = [self getViewControllerClass];
    if (titles && viewClass && viewClass.count == titles.count ) {
        self.titles = titles;
        self.subViewControllers = viewClass;
        [self loadMenuViewWithTitles:self.titles];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.topBar.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, kTopBarHeight);
    self.mainScrollView.frame = CGRectMake(0, self.topBar.y+self.topBar.height, SCREEN_WIDTH,SCREEN_HEIGHT - self.mainScrollView.y);
    self.mainScrollView.contentSize = CGSizeMake(self.subViewControllers.count * self.mainScrollView.width, 0);
    
    for (int j = 0; j < self.subViewControllers.count; j++) {
        CGFloat X = j * SCREEN_WIDTH;
        CGFloat Y = 0;
        CGFloat height = self.view.height - self.topBar.maxY;
        CGRect frame = CGRectMake(X, Y, SCREEN_WIDTH, height);
        [self.controllerFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    
    [self addViewControllerViewAtIndex:0];
}

#pragma mark -- publick Method
- (void)loadVC:(NSArray *)viewcontrollerClass AndTitle:(NSArray *)titles
{
    if (viewcontrollerClass && titles && viewcontrollerClass.count == titles.count) {
        self.subViewControllers = viewcontrollerClass;
        self.titles  = titles;
        [self loadMenuViewWithTitles:self.titles];
    } else {
        NSAssert(1, @"titles 与 viewClass 数量不一致!");
    }
}


/**
 子类重写
 
 @return 控制器和title数组
 */
- (NSArray *)getViewControllerClass { return nil;}

- (NSArray *)getViewControllerTitles {return nil;}

#pragma mark -- private Method

- (void)loadMenuViewWithTitles:(NSArray *)titles
{
    UIButton  *btn = nil;
    if (self.topBarIsAdd) {
        btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"titlebar_bt_close01"] forState:UIControlStateNormal];
    }
    
    ATScrollTopBar *topBar = [[ATScrollTopBar alloc] initWithTitles:titles andExtraBtn:btn];
    [self.view addSubview:topBar];
    topBar.delegate = self;
    self.topBar = topBar;
}

- (void)addViewControllerViewAtIndex:(int)index
{
    Class vclass = self.subViewControllers[index];
    UIViewController *vc = [[vclass alloc]init];
    vc.view.frame = [self.controllerFrames[index] CGRectValue];
    [self.displayControllers setObject:vc forKey:@(index)];
    [self addChildViewController:vc];
    [self.mainScrollView addSubview:vc.view];
    self.currentViewController = vc;
}

- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayControllers removeObjectForKey:@(index)];
    
    if ([self.controllerCache objectForKey:@(index)]) return;
    [self.controllerCache setObject:viewController forKey:@(index)];
    
}

- (BOOL)isInScreen:(CGRect)frame
{
    CGFloat x = frame.origin.x;
    CGFloat ScreenWith = self.mainScrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.mainScrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) >contentOffsetX && x - contentOffsetX < ScreenWith ){
        return YES;
    }else{
        return NO;
    }
    
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    
    [self addChildViewController:viewController];
    [self.mainScrollView addSubview:viewController.view];
    [self.displayControllers setObject:viewController forKey:@(index)];
    
    self.currentViewController = viewController;
}

#pragma mark delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int Page = (int)(scrollView.contentOffset.x / self.view.width + 0.5);
    int index = (int)(scrollView.contentOffset.x / self.view.width);
    CGFloat rate = scrollView.contentOffset.x / self.view.width;
    
    for (int i = 0; i < self.subViewControllers.count; i++) {
        
        CGRect frame = [self.controllerFrames[i] CGRectValue];
        // get display controller
        UIViewController *vc = [self.displayControllers objectForKey:@(i)];
        
        if ([self isInScreen:frame]) {
            
            if (vc == nil) {
                vc = [self.controllerCache objectForKey:@(i)];
                if (vc) {
                    [self addCachedViewController:vc atIndex:i];
                } else {//create again
                    [self addViewControllerViewAtIndex:i];
                }
            }
        } else {
            if (vc) {//如果不在屏幕中显示，将其移除
                [self removeViewController:vc atIndex:i];
            }
        }
    }
    self.currentViewController = [self.displayControllers objectForKey:@(Page)];
    
    [self.topBar setCurrentPage:index withRate:rate];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width )return;
    int Page = (int)(scrollView.contentOffset.x / self.view.width);
    
    NSString *name  = [NSString stringWithFormat:@"scrollViewDidFinished"];
    NSDictionary *info = @{@"index" : @(Page)};
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:info];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{    
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width ) return;
    
    if(!decelerate){
        int Page = (int)(scrollView.contentOffset.x/SCREEN_WIDTH);
        
        if (Page == 0) {
            [self.topBar selectWithIndex:Page otherIndex:Page + 1 ];
        } else if (Page == self.subViewControllers.count - 1) {
            [self.topBar selectWithIndex:Page otherIndex:Page - 1];
        } else {
            [self.topBar selectWithIndex:Page otherIndex:Page + 1 ];
            [self.topBar selectWithIndex:Page otherIndex:Page - 1];
        }
    }
}

- (void)ATScrollTopBar:(ATScrollTopBar *)topBar withIndex:(int)index
{
    [self removeViewController:self.currentViewController atIndex:_currentPage];
    
    self.mainScrollView.contentOffset = CGPointMake(index * SCREEN_WIDTH, 0);
    self.currentPage = index;
    
    UIViewController *vc = [self.displayControllers objectForKey:@(index)];
    if (vc == nil) {
        vc = [self.controllerCache objectForKey:@(index)];
        if (vc) {
            [self addCachedViewController:vc atIndex:index];
        } else {
            [self addViewControllerViewAtIndex:index];
        }
    }
}

/**
 NSCache的代理方法，打印当前清除对象
 */
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"清除了-------> %@", obj);
}

#pragma mark - lazy load
- (NSArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableDictionary *)displayControllers
{
    if (!_displayControllers) {
        _displayControllers = [NSMutableDictionary dictionary];
    }
    return _displayControllers;
}

- (NSArray *)subViewControllers
{
    if (!_subViewControllers) {
        _subViewControllers = [NSArray array];
    }
    return _subViewControllers;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (NSMutableArray *)controllerFrames
{
    if (!_controllerFrames) {
        _controllerFrames = [NSMutableArray array];
    }
    return _controllerFrames;
}

- (NSCache *)controllerCache
{
    if (!_controllerCache) {
        _controllerCache = [[NSCache alloc] init];
        _controllerCache.countLimit = 3;
        _controllerCache.delegate = self;
    }
    return _controllerCache;
}


@end
