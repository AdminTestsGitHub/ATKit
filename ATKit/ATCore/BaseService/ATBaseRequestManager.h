//
//  ATBaseRequestManager.h
//  MiLin
//
//  Created by AdminTest on 2017/9/12.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATBaseRequestManager : NSObject

- (void)bindCallBackWithSuccess:(id)successBlock withFailed:(id)failedBlock toTarget:(id)target;
- (id)getBindSuccessBlock:(id)target;
- (id)getBindFailedBlock:(id)target;


@end
