//
//  ATBeanDefinition.h
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATBeanDefinition : NSObject

/**
 *  获取一个类的构造定义
 *
 *  @param clazz 需要初始化的类型
 *
 *  @return 返回定义
 */
+ (instancetype)withClass:(Class)clazz ofProtocol:(Protocol *)protocol;

/**
 *  初始化构造函数
 *
 *  @param selector init 函数
 */
- (void)useInitializer:(SEL)selector;

/**
 *  调用带参数初始化构造函数
 *
 *  @param selector init 函数
 *  @param params   输入参数
 */
- (void)useInitializer:(SEL)selector parameters:(NSArray*)params;

/**
 *  调用构造对象实力
 *
 *  @return 要构造的对象实例
 */
- (id)construct;

- (Protocol *)protocol;

- (Class)clazz;


@end
