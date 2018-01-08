//
//  ATCalendarDate.m
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCalendarDate.h"

@implementation ATCalendarDate

+ (instancetype)lastMonthDateWith:(NSString *)dateStr
{
    ATCalendarDate *date = [[ATCalendarDate alloc] init];
    date.date            = dateStr;
    date.isLastMonth     = YES;
    date.notThisMonth    = YES;
    return date;
}

+ (instancetype)nextMonthDateWith:(NSString *)dateStr
{
    ATCalendarDate *date = [[ATCalendarDate alloc] init];
    date.date            = dateStr;
    date.isNextMonth     = YES;
    date.notThisMonth    = YES;
    return date;
}

@end
