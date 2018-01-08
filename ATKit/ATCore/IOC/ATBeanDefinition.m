//
//  ATBeanDefinition.m
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATBeanDefinition.h"

@interface ATBeanDefinition ()
{
    Class _clazz;
    Protocol *_protocol;
}
@end

@implementation ATBeanDefinition

+ (instancetype)withClass:(Class)clazz ofProtocol:(Protocol*)protocol
{
    return [[ATBeanDefinition alloc] initWithClass:clazz ofProtocol:protocol];
}

- (instancetype)initWithClass:(Class)clazz ofProtocol:(Protocol*)protocol
{
    self = [super init];
    if (self) {
        _clazz = clazz;
        _protocol = protocol;
    }
    return self;
}

- (void)useInitializer:(SEL)selector
{
    
}

- (void)useInitializer:(SEL)selector parameters:(NSArray *)params
{
    
}

- (id)construct
{
    return [[_clazz alloc] init];
}

- (Protocol *)protocol
{
    return _protocol;
}

- (Class)clazz
{
    return _clazz;
}

@end

