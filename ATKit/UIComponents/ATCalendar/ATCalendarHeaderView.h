//
//  ATCalendarHeaderView.h
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATCalendarHeaderView;

@protocol ATCalendarHeaderViewDelegate <NSObject>

/**
 点击了左边的按钮
 */
- (void)header:(ATCalendarHeaderView *)header didClickLeftBtn:(UIButton *)button;

/**
 点击了右边的按钮
 */
- (void)header:(ATCalendarHeaderView *)header didClickRightBtn:(UIButton *)button;

@end

@interface ATCalendarHeaderView : UIView

/** 当前年月 yyyy-MM **/
@property (nonatomic, copy) NSString *title;

/** 起始年月 yyyy-MM */
@property (nonatomic, copy) NSString *beginYearMonth;

/** 结束年月 yyyy-MM */
@property (nonatomic, copy) NSString *endYearMonth;

/** 代理 */
@property (nonatomic, assign) id<ATCalendarHeaderViewDelegate> delegate;


@end
