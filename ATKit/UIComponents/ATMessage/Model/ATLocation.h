//
//  ATLocation.h
//  MiLin
//
//  Created by AdminTest on 2017/8/9.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATLocation : NSObject

/** 描述 */
@property (nonatomic, copy) NSString *desc;

/** 纬度 */
@property (nonatomic, assign) CGFloat latitude;

/** 经度 */
@property (nonatomic, assign) CGFloat longitude;

/** cover */
@property (nonatomic, copy) NSString *coverPath;

+ (instancetype)locationWithDesc:(NSString *)desc lat:(CGFloat)lat lon:(CGFloat)lon;

@end
