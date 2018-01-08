//
//  ATContainer.h
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PropertyItem;

@interface ATContainer : NSObject

+ (instancetype)sharedInstance;

- (id)retrieveProxyInstance:(NSString*)identity;

- (void)loadInstanceByFactoryWithConfig:(NSArray*)configs;

- (id)generateInstanceByProtocol:(Protocol *)protocol;

- (NSMutableArray<PropertyItem*>*)injectPropertysForClass:(NSString*)clazz;

- (void)setClassPropertyInjectCache:(NSMutableArray<PropertyItem*>*)propertys forClass:(NSString*)clazz;

- (BOOL)isClassInBlackList:(NSString*)className;

@end
