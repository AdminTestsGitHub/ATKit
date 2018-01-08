//
//  ATScrollTopBar.m
//  MiLin
//
//  Created by AdminTest on 2017/9/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATScrollTopBar.h"
#import "ATScrollTopBarItem.h"

static CGFloat kTabPadding = 8;

@interface ATScrollTopBar () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *topBarContainer;
@property (nonatomic, strong) ATScrollTopBarItem *selectedBtn;
@property (nonatomic, assign) CGFloat sumWidth;
@property (nonatomic, strong) UIButton * extraBtn;

@end


@implementation ATScrollTopBar

- (instancetype)initWithTitles:(NSArray *)titles andExtraBtn:(UIButton *)extraBtn;
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self loadWithTitles:titles];
        if (extraBtn) {
            self.extraBtn = extraBtn;
            [self addSubview:extraBtn];
            CGSize size = extraBtn.size;
            
            if (CGSizeEqualToSize(size, CGSizeZero)) {
                size = CGSizeMake(34, 34);
            }
            self.extraBtn.size = size;
        }
        NSString *name = [NSString stringWithFormat:@"scrollViewDidFinished"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(move:) name:name object:nil];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.extraBtn.x = self.width - self.extraBtn.width;
    self.extraBtn.y = (self.height -self.extraBtn.height ) * 0.5;
    
    ATScrollTopBarItem *btn = nil;
    ATScrollTopBarItem *btn1 = nil;
    self.sumWidth = 0;
    
    for (int i = 0; i < self.topBarContainer.subviews.count; i++){
        btn = self.topBarContainer.subviews[i];
        if (i >= 1) {
            btn1 = self.topBarContainer.subviews[i - 1];
        }
        UIFont *titleFont = btn.titleLabel.font;
        CGSize titleS = [btn.titleLabel.text sizeThatFitsMaxWidth:CGFLOAT_MAX andFont:titleFont];
        btn.width = titleS.width + 2 *kTabPadding;
        btn.x = btn1.x + btn1.width + kTabPadding;
        btn.y = 0;
        btn.height = self.height - 2;
        self.sumWidth += btn.width;
        if (btn == [self.topBarContainer.subviews lastObject]) {
            CGFloat width  = self.bounds.size.width;
            CGFloat contentWidth = btn.x + btn.width+ kTabPadding;
            if (self.extraBtn) {
                width = self.bounds.size.width - self.extraBtn.width;
                contentWidth = contentWidth + self.extraBtn.width;
            }
            
            CGFloat height = self.bounds.size.height;
            self.topBarContainer.size = CGSizeMake(width, height);
            
            self.topBarContainer.contentSize = CGSizeMake(contentWidth, 0);
            self.topBarContainer.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        btn = nil;
        btn1 = nil;
    }
    if (self.topBarContainer.contentSize.width < self.width) {
        CGFloat margin = (SCREEN_WIDTH - self.sumWidth)/(self.topBarContainer.subviews.count + 1);
        for (int i = 0; i < self.topBarContainer.subviews.count; i++){
            btn= self.topBarContainer.subviews[i];
            if (i>=1) {
                btn1 = self.topBarContainer.subviews[i-1];
            }
            btn.x = btn1.x + btn1.width + margin;
            
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    ATScrollTopBarItem *btn = [self.topBarContainer.subviews firstObject];
    [btn ChangSelectedColorAndScalWithRate:0.1];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -- public Method

- (void)setCurrentPage:(NSInteger)index withRate:(CGFloat)aRate
{
    int page  = (int)(aRate +0.5);
    CGFloat rate = aRate - index;
    int count = (int)self.topBarContainer.subviews.count;
    
    if (aRate < 0) return;
    if (index == count-1 || index >= count -1) return;
    if ( rate == 0)    return;
    
    self.selectedBtn.selected = NO;
    ATScrollTopBarItem *currentbtn = self.topBarContainer.subviews[index];
    ATScrollTopBarItem *nextBtn = self.topBarContainer.subviews[index + 1];
    
    [currentbtn ChangSelectedColorAndScalWithRate:rate];
    [nextBtn ChangSelectedColorAndScalWithRate:1-rate];
    
    self.selectedBtn = self.topBarContainer.subviews[page];
    self.selectedBtn.selected = YES;
}

- (void)selectWithIndex:(int)index otherIndex:(int)tag
{
    self.selectedBtn = self.topBarContainer.subviews[index];
    ATScrollTopBarItem *otherbtn = self.topBarContainer.subviews[tag];
    
    self.selectedBtn.selected = YES;
    otherbtn.selected = NO;
    
    [self MoveCodeWithIndex:(int)self.selectedBtn.tag];
}

- (void)loadWithTitles:(NSArray *)titles {
    
    UIScrollView *topBarContainer = [[UIScrollView alloc]init];
    topBarContainer.showsVerticalScrollIndicator = NO;
    topBarContainer.showsHorizontalScrollIndicator = NO;
    topBarContainer.backgroundColor = [UIColor whiteColor];
    topBarContainer.delegate = self;
    self.topBarContainer= topBarContainer;
    [self addSubview:self.topBarContainer];
    //btn创建
    
    for (int i = 0; i < titles.count; i++) {
        ATScrollTopBarItem *btn = [[ATScrollTopBarItem alloc ] initWithTitles:titles AndIndex:i];
        btn.tag = i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textColor = UIColorMakeWithHex(@"666666");
        [self.topBarContainer addSubview:btn];
    }
}

#pragma mark -- private Method

- (void)click:(ATScrollTopBarItem *)btn
{
    if (self.selectedBtn == btn) return;
    if ([self.delegate respondsToSelector:@selector(ATScrollTopBar:withIndex:)]) {
        [self.delegate ATScrollTopBar:self withIndex:(int)btn.tag];
    }
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    [self MoveCodeWithIndex:(int)btn.tag];
    
    [btn selectedItemWithoutAnimation];
    [self.selectedBtn deselectedItemWithoutAnimation];
    
    self.selectedBtn = btn;
}

/**
 *  使选中的按钮位移到scollview的中间
 */
- (void)MoveCodeWithIndex:(int )index
{
    ATScrollTopBarItem *btn = self.topBarContainer.subviews[index];
    CGRect newframe = [btn convertRect:self.bounds toView:nil];
    CGFloat distance = newframe.origin.x  - self.width / 2;
    CGFloat contenoffsetX = self.topBarContainer.contentOffset.x;
    int count = (int)self.topBarContainer.subviews.count;
    if (index > count - 1) return;
    
    if ( self.topBarContainer.contentOffset.x + btn.x  > self.width / 2 ) {
        
        [self.topBarContainer setContentOffset:CGPointMake(contenoffsetX + distance + btn.width, 0) animated:YES];
    }else{
        
        [self.topBarContainer setContentOffset:CGPointMake(0 , 0) animated:YES];
    }
}

- (void)move:(NSNotification *)info
{
    NSNumber *index =  info.userInfo[@"index"];
    int tag = [index intValue];
    [self MoveCodeWithIndex:tag];
}

#pragma mark -- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0) {
        
        [scrollView setContentOffset:CGPointMake(0 , 0)];
    }else if(scrollView.contentOffset.x + self.width >= scrollView.contentSize.width){
        
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - self.width, 0)];
    }
}



@end
