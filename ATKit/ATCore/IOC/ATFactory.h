//
//  ATFactory.h
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATBeanDefinition;

@protocol ATFactory <NSObject>

- (NSArray<ATBeanDefinition *> *)beanDefinitions;


@end
