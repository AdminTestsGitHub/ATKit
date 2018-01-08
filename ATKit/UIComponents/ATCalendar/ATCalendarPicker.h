//
//  ATCalendarPicker.m
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

// 当宽度为屏幕宽度时,自动计算高度
#define ALPickerHeight 45 + (([UIScreen mainScreen].bounds.size.width / 10) * 7) + ((([UIScreen mainScreen].bounds.size.width - 40) - (7 * [UIScreen mainScreen].bounds.size.width / 10)) / 7) * 8

@class ATCalendarPicker,ATCalendarDate;

@protocol ATCalendarPickerDelegate <NSObject>

/**
 选择某个日期
 */
- (void)calendarPicker:(ATCalendarPicker *)picker didSelectItem:(ATCalendarDate *)date date:(NSDate *)dateObj dateString:(NSString *)dateStr;

@end

@interface ATCalendarPicker : UIView

/** 起始年月 yyyy-MM */
@property (nonatomic, copy) NSString *beginYearMonth;

/** 结束年月 yyyy-MM */
@property (nonatomic, copy) NSString *endYearMonth;

/** 代理 */
@property (nonatomic, assign) id<ATCalendarPickerDelegate> delegate;

/** 高亮日期 yyyy-MM-dd 格式 */
@property (nonatomic, assign) NSArray<NSString *> *hightLightItems;

/** 选择日期 yyyy-MM-dd 格式 */
@property (nonatomic, assign) NSArray<NSString *> *selectedItems;

/** 高亮日期优先 当高亮日期与当日日期的重叠的时候优先使用高亮日期的样式 */
@property (nonatomic, assign) BOOL hightlightPriority;

/** 重新加载选择器 */
- (void)reloadPicker;

/** 高亮的日期的样式 */
- (void)setupHightLightItemStyle:(void(^)(UIColor **backgroundColor,NSNumber **backgroundCornerRadius,UIColor **titleColor))style;

/** 当日日期的样式 */
- (void)setupTodayItemStyle:(void(^)(UIColor **backgroundColor,NSNumber **backgroundCornerRadius,UIColor **titleColor))style;

/** 选择日期的样式 */
- (void)setupSelectedItemStyle:(void(^)(UIColor **backgroundColor,NSNumber **backgroundCornerRadius,UIColor **titleColor))style;

@end
