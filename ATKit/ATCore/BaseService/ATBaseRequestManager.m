//
//  ATBaseRequestManager.m
//  MiLin
//
//  Created by AdminTest on 2017/9/12.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATBaseRequestManager.h"
#import <objc/runtime.h>


static const NSString *ATRequestSuccessBlockKey = @"ATRequestSuccessBlockKey";
static const NSString *ATRequestFailedBlockKey = @"ATRequestFailedBlockKey";


@implementation ATBaseRequestManager

- (void)bindCallBackWithSuccess:(id)successBlock withFailed:(id)failedBlock toTarget:(id)target
{
    objc_setAssociatedObject(target, &ATRequestSuccessBlockKey, successBlock, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(target, &ATRequestFailedBlockKey, failedBlock, OBJC_ASSOCIATION_COPY);
}

- (id)getBindSuccessBlock:(id)target
{
    return objc_getAssociatedObject(target, &ATRequestSuccessBlockKey);
}

- (id)getBindFailedBlock:(id)target
{
    return objc_getAssociatedObject(target, &ATRequestFailedBlockKey);
}


@end
