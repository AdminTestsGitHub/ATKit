//
//  ATSegmentedHeaderView.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATSegmentedHeaderViewDelegate;

@interface ATSegmentedHeaderView : UIView

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) id<ATSegmentedHeaderViewDelegate> delegate;


- (instancetype)initWithTitles:(NSArray *)titles;

- (void)setDefaultIndex:(int)idx;
- (NSArray *)getAllTitleBtns;
- (void)scrollItemToIndex:(int)idx;
- (void)setRedInIdex:(NSArray *)idxs;

@end

@protocol ATSegmentedHeaderViewDelegate <NSObject>

@optional
- (void)ATSegmentedView:(ATSegmentedHeaderView *)view didSelectItemWithTitle:(NSString *)title index:(int)idx;

@end
