//
//  ATChatMoreView.m
//  MiLin
//
//  Created by AdminTest on 2017/8/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatMoreView.h"
#import "ATChatMoreViewItem.h"

static CGFloat topLineH = 0.5;
static CGFloat bottomH = 18;

@interface ATChatMoreView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation ATChatMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self configWithItems];
    }
    return self;
}

- (void)addSubviews
{
    self.backgroundColor = UIColorMake(237, 237, 246);
    [self addSubview:self.topLine];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

- (void)configWithItems
{
    // 创建Item
    ATChatMoreViewItem *photosItem = [ATChatMoreViewItem createChatBoxMoreItemWithTitle:@"照片" imageName:@"sharemore_pic"];
    ATChatMoreViewItem *takePictureItem = [ATChatMoreViewItem createChatBoxMoreItemWithTitle:@"拍摄" imageName:@"sharemore_video"];
//    ATChatMoreViewItem *videoItem = [ATChatMoreViewItem createChatBoxMoreItemWithTitle:@"小视频" imageName:@"sharemore_sight"];
    ATChatMoreViewItem *locationItem = [ATChatMoreViewItem createChatBoxMoreItemWithTitle:@"位置" imageName:@"sharemore_location"];
    
    ATChatMoreViewItem *cardItem   = [ATChatMoreViewItem createChatBoxMoreItemWithTitle:@"名片" imageName:@"sharemore_friendcard"];
    
    ATChatMoreViewItem *redItem   = [ATChatMoreViewItem createChatBoxMoreItemWithTitle:@"红包" imageName:@"sharemore_wallet"];
    
    ATChatMoreViewItem *docItem   = [ATChatMoreViewItem createChatBoxMoreItemWithTitle:@"文件" imageName:@"sharemore_wallet"];

    self.items = @[photosItem, takePictureItem, locationItem, docItem, cardItem, redItem];
    
    self.pageControl.numberOfPages = self.items.count / 8 + 1;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * (self.items.count / 8 + 1), _scrollView.height);
    
    int i = 0;
    for (ATChatMoreViewItem *item in self.items) {
        [self.scrollView addSubview:item];
        [item setTag:i];
        [item addTarget:self action:@selector(didSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
        i ++;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    float w = self.width * 20 / 21 / 4 * 0.8;
    float space = w / 4;
    float h = (self.height - 20 - space * 2) / 2;
    float x = space, y = space;
    int i = 0, page = 0;
    for (ATChatMoreViewItem *item in _items) {
        [item setFrame:CGRectMake(x, y, w, h)];
        i ++;
        page = i % 8 == 0 ? page + 1 : page;
        x = (i % 4 ? x + w : page * self.width) + space;
        y = (i % 8 < 4 ? space : h + space * 1.5);
    }

}

#pragma mark - Public Methods

// 点击了某个Item
- (void) didSelectedItem:(ATChatMoreViewItem *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(ATChatMoreView:didSelectItem:)]) {
        [_delegate ATChatMoreView:self didSelectItem:sender.tag];
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / self.width;
    [_pageControl setCurrentPage:page];
}


#pragma mark - Getter and Setter
- (UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setFrame:CGRectMake(0, topLineH, SCREEN_WIDTH, SCREEN_HEIGHT - bottomH)];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setPagingEnabled:YES];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (nil == _pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        _pageControl.frame = CGRectMake(0, SCREEN_HEIGHT - bottomH, SCREEN_WIDTH, 8);
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIView *)topLine
{
    if (nil == _topLine) {
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,topLineH)];
        [self addSubview:topLine];
        topLine.backgroundColor = UIColorMake(188.0, 188.0, 188.0);
        _topLine = topLine;
    }
    return _topLine;
}


#pragma mark - Privite Method

- (void)pageControlClicked:(UIPageControl *)pageControl
{
    [self.scrollView scrollRectToVisible:CGRectMake(pageControl.currentPage * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height) animated:YES];
}

@end
