//
//  ATCalendarDate.h
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCalendarDate : NSObject

/** 日期(号数) */
@property (nonatomic, copy) NSString *date;

/** 是上个月 */
@property (nonatomic, assign) BOOL isLastMonth;

/** 是下个月 */
@property (nonatomic, assign) BOOL isNextMonth;

/** 不是这个月 */
@property (nonatomic, assign) BOOL notThisMonth;

/** 是今天 */
@property (nonatomic, assign) BOOL isToday;

+ (instancetype)lastMonthDateWith:(NSString *)dateStr;

+ (instancetype)nextMonthDateWith:(NSString *)dateStr;

@end
