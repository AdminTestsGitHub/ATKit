//
//  ATCalendarCollectionView.h
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATCalendarDate,ATCalendarCollectionView,ATCalendarConfig;

@protocol ATCalendarCollectionViewDelegate <NSObject>

/** 
 * 点击了某个日期
 */
- (void)calendarView:(ATCalendarCollectionView *)calendarCollectionView didSelectItem:(ATCalendarDate *)date date:(NSDate *)dateObj dateString:(NSString *)dateString;

@end

@interface ATCalendarCollectionView : UICollectionView

/** 当前的年份和月份 yyyy-MM */
@property (nonatomic, copy) NSString *yearAndMonth;

/** 代理 */
@property (nonatomic, assign) id<ATCalendarCollectionViewDelegate> collectionViewDelegate;

/** 配置 */
@property (nonatomic, strong) ATCalendarConfig *config;

@end
