//
//  ATRequestParameter.h
//  MiLin
//
//  Created by AdminTest on 2017/10/12.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATRequestParameter : NSObject

@property (nonatomic, strong) NSMutableDictionary *dict;

+ (instancetype)commonConfig;

- (void)setObject:(id)value forKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey;

@end
