//
//  ATRequestParameter.m
//  MiLin
//
//  Created by AdminTest on 2017/10/12.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATRequestParameter.h"

@implementation ATRequestParameter


+ (instancetype)commonConfig
{
    //做一些统一设置
    ATRequestParameter *paras = [[ATRequestParameter alloc] init];
//    [paras setObject:[ATClient sharedInstance].mobile forKey:@"mobile"];
//    [paras setObject:[ATClient sharedInstance].token forKey:@"token"];
    
    return paras;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setObject:(id)value forKey:(NSString *)aKey
{
    [self.dict setObject:value forKey:aKey];
}

- (void)removeObjectForKey:(NSString *)aKey
{
    [self.dict removeObjectForKey:aKey];
}

@end
