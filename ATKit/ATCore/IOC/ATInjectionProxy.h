//
//  ATInjectionProxy.h
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATInjectionProxy : NSObject

+(instancetype)instanceWithProtocol:(Protocol*)protocol;

-(void)preInject;


@end
