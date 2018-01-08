//
//  ATLocation.m
//  MiLin
//
//  Created by AdminTest on 2017/8/9.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATLocation.h"

@implementation ATLocation

+ (instancetype)locationWithDesc:(NSString *)desc lat:(CGFloat)lat lon:(CGFloat)lon
{
    return [[ATLocation alloc] initWithDesc:desc lat:lat lon:lon];
}

- (instancetype)initWithDesc:(NSString *)desc lat:(CGFloat)lat lon:(CGFloat)lon
{
    self = [super init];
    if (self) {
        self.desc = desc;
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}

@end
