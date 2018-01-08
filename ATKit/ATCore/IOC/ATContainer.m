//
//  ATContainer.m
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATContainer.h"
#import "ATBeanDefinition.h"
#import "ATInjectionProxy.h"
#import "ATFactory.h"
#import "ATInjecter.h"

@interface ATContainer ()
{
    NSMutableDictionary* _injectPropertyCache;
    NSArray * _blackClassList;
}

/*! key为协议名称（<xxx protocol>） value为ATBeanDefinition的示例 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, ATBeanDefinition *> *definitionBeansTable;
/*! key为协议名称（<xxx protocol>） value为ATInjectionProxy的示例 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, ATInjectionProxy *> *proxyTable;
@property (nonatomic, assign) BOOL isInit;
@property (nonatomic, strong) NSArray *factorys;


@end

@implementation ATContainer

+ (instancetype)sharedInstance
{
    static ATContainer *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ATContainer alloc] init];
    });
    return instance;
}

#pragma mark -- init

//第一个就是注入工厂的字典
//GIKI_Z  16:45:42
//第2个是消息转发的proxy 的字典
//GIKI_Z  16:45:58
//第三个是已经注入属性缓存的字典
//GIKI_Z  16:46:07
//第四个是  黑名单的字典
//GIKI_Z  16:46:19
//黑名单用来 抛出系统原生类的属性遍历
//GIKI_Z  16:46:28
//节省效率 和时间
- (instancetype)init
{
    if (self = [super init]) {
        _definitionBeansTable = [[NSMutableDictionary alloc] init];
        _proxyTable = [[NSMutableDictionary alloc] init];
        _injectPropertyCache = [[NSMutableDictionary alloc] init];
        _blackClassList = [self blackList];
        self.isInit = NO;
    }
    return self;
}

- (id)retrieveProxyInstance:(NSString*)identity
{
    if ([[_proxyTable allKeys] containsObject:identity]) {
        return _proxyTable[identity];
    }
    return nil;
}

- (void)loadInstanceByFactoryWithConfig:(NSArray*)configs
{
    @synchronized (self) {
        if (!self.isInit) {
            self.factorys = configs;
            [_factorys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                Class aClass = objc_getClass([obj cStringUsingEncoding:NSUTF8StringEncoding]);
                
                id<ATFactory> factory = [[aClass alloc] init];
                
                if ([factory respondsToSelector:@selector(beanDefinitions)]) {
                    NSArray<ATBeanDefinition*> *beans = [factory beanDefinitions];
                    [beans enumerateObjectsUsingBlock:^(ATBeanDefinition * _Nonnull bean, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self addProxyWithBeanDefine:bean];
                    }];
                }
                
            }];
        }
        
        self.isInit = YES;
    }
}

-(void)setClassPropertyInjectCache:(NSMutableArray<PropertyItem*>*)propertys forClass:(NSString*)clazz
{
    NSParameterAssert(propertys);
    NSParameterAssert(clazz);
    _injectPropertyCache[clazz] = propertys;
}


-(NSMutableArray<PropertyItem*>*)injectPropertysForClass:(NSString*)clazz
{
    NSParameterAssert(clazz);
    @synchronized (_injectPropertyCache) {
        @try {
            if ([[_injectPropertyCache allKeys] containsObject:clazz]) {
                return _injectPropertyCache[clazz];
            } else {
                return nil;
            }
        } @catch (NSException *exception) {
            NSAssert1(NO, @"IOC容器注入异常 %@", exception);
        } @finally {
            
        }
        
    }
    
}

-(BOOL)isClassInBlackList:(NSString*)className
{
    return [_blackClassList containsObject:className];
}

#pragma -- mark  IOCContainer+Construction functions

-(id)generateInstanceByProtocol:(Protocol *)protocol
{
    @synchronized (self) {
        NSString* identity = [self instanceProtocol:protocol];
        
        if ([[_definitionBeansTable allKeys] containsObject:identity]){
            id bean = [_definitionBeansTable[identity] construct];
            return bean;
        }
    }
    return nil;
}



#pragma mark -- private Method

-(void)addProxyWithBeanDefine:(ATBeanDefinition*)beanDef
{
    ATInjectionProxy* proxy = [ATInjectionProxy instanceWithProtocol:beanDef.protocol];
    NSString* protocolName = [self instanceProtocol:[beanDef protocol]];
    _definitionBeansTable[protocolName] = beanDef;
    _proxyTable[protocolName] = proxy;
}

-(NSString*)instanceProtocol:(Protocol *)proc
{
    const char *propType = protocol_getName(proc);
    NSString *propertyType = [NSString stringWithCString:propType
                                                encoding:[NSString defaultCStringEncoding]];
    NSString *identity = [NSString stringWithFormat:@"<%@>", propertyType];
    return identity;
}

#pragma mark - black list

-(NSArray<NSString*>*)blackList
{
    return @[@"UIView",
             @"UIResponder",
             @"UIViewController",
             @"UICollectionViewCell",
             @"UICollectionReusableView"];
}


@end
