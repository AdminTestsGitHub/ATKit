//
//  ATInjectionProxy.m
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATInjectionProxy.h"
#import "ATContainer.h"
#import "ATInjecter.h"

@interface ATInjectionProxy ()
{
    Protocol* _protocol;
    id _beanRef;
    NSMutableArray<ATInjectionProxy*>* refObject;
}
@end

@implementation ATInjectionProxy

+(instancetype)instanceWithProtocol:(Protocol*)protocol
{
    ATInjectionProxy *proxy = [[ATInjectionProxy alloc] initWithProtocol:protocol];
    return proxy;
}

-(instancetype)initWithProtocol:(Protocol*)protocol
{
    _protocol = protocol;
    return self;
}

-(void)preInject
{
    @synchronized (self) {
        if (_beanRef) {
            [ATInjecter doInjectWithTarget:_beanRef];
        }
    }
}

-(id)referenceInst
{
    @synchronized (self) {
        if (!_beanRef) {
            _beanRef = [[ATContainer sharedInstance] generateInstanceByProtocol:_protocol];
            [ATInjecter doInjectWithTarget:_beanRef];
        }
        return _beanRef;
    }
}

/******************      Message forward        *********************/
//方案一：
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    return [super resolveClassMethod:sel];
}

//方案二：
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

/*
* 方案三：
* NSInvocation;用来包装方法和对应的对象，它可以存储方法的名称，对应的对象，对应的参数,
* NSMethodSignature：签名：再创建NSMethodSignature的时候，必须传递一个签名对象，签名对象的作用：用于获取参数的个数和方法的返回值
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig;
    sig = [[self referenceInst] methodSignatureForSelector:aSelector];
    return sig;
}

// Invoke the invocation on whichever real object had a signature for it.
- (void)forwardInvocation:(NSInvocation *)invocation {
    id target = [[self referenceInst] methodSignatureForSelector:[invocation selector]] ? [self referenceInst] : nil;
    [invocation invokeWithTarget:target];//调用
}

// Override some of NSProxy's implementations to forward them...
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([[self referenceInst] respondsToSelector:aSelector]) return YES;
    return NO;
}

@end
