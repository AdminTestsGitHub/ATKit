//
//  ATCalendarCell.h
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATCalendarDate;

@interface ATCalendarCell : UICollectionViewCell

@property (nonatomic, strong) ATCalendarDate *date;

/** 星期 */
@property (nonatomic, copy) NSString *weekDay;

@property (nonatomic, strong, readonly) UILabel *dateLabel;

@end
