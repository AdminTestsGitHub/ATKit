//
//  ATInjecter.m
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATInjecter.h"
#import "ATContainer.h"

static NSString* const KEY_INJECT_CACHE = @"IOCInjectCache";


@implementation PropertyItem

+(instancetype)instanceWithType:(NSString*)propertyType name:(NSString*)propertyName
{
    PropertyItem* instance = [[PropertyItem alloc] initWithType:propertyType name:propertyName];
    return instance;
}

-(instancetype)initWithType:(NSString*)propertyType name:(NSString*)propertyName
{
    self = [super init];
    if (self) {
        self.propertyName = propertyName;
        self.propertyType = propertyType;
    }
    return self;
}

@end

@implementation ATInjecter

#pragma mark -- public Method

+ (void)doInjectWithTarget:(__kindof id)target
{
    [[self class] doInject:target withClassType:[target class] withContext:[[NSMutableArray alloc] init]];
}

+ (NSString*)getProperType:(const char *)typeCStr
{
    return [NSString stringWithCString:typeCStr
                              encoding:[NSString defaultCStringEncoding]];
}

+ (void)InjectContainerWithConfigs:(NSArray*)configs
{
    [[ATContainer sharedInstance] loadInstanceByFactoryWithConfig:configs];
}

#pragma mark -- private Method

+(void)doInject:(id)target withClassType:(Class)clazz withContext:(NSMutableArray*)context
{
    
    NSParameterAssert(target);
    NSParameterAssert(clazz);
    
    NSString* className = [NSString stringWithCString:class_getName(clazz) encoding:NSUTF8StringEncoding];
    
    if (!clazz || clazz == [NSObject class] || [context containsObject:clazz]) {
        return;
    }
    
    if ([[ATContainer sharedInstance] isClassInBlackList:className]) {
        return;
    }
    
    [context addObject:clazz];
    
    unsigned int outCount, i;
    NSMutableArray<PropertyItem*>* injectCache = [[ATContainer sharedInstance] injectPropertysForClass:className];
    
    @synchronized (injectCache) {
        if (injectCache && [injectCache respondsToSelector:@selector(count)] && [injectCache count] > 0) {
            
            [injectCache enumerateObjectsUsingBlock:^(PropertyItem * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([property isKindOfClass:[PropertyItem class]]) {
                    id obj = [[ATContainer sharedInstance] retrieveProxyInstance:property.propertyType];
                    if (obj != nil) {
                        [target setValue:obj forKey:property.propertyName];
                    }
                } else {
                    NSAssert(NO, @"property 不合法");
                }
            }];
            
        } else {
            
            injectCache = [[NSMutableArray alloc] init];
            objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
            @try {
                for(i = 0; i < outCount; i++) {
                    objc_property_t property = properties[i];
                    const char *propName = property_getName(property);
                    if (propName) {
                        const char *propType = getPropertyType(property);
                        if (propName && propName != NULL && propType && propType != NULL) {
                            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
                            NSString *propertyType = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
                            
                            id obj = [[ATContainer sharedInstance] retrieveProxyInstance:propertyType];
                            if (obj != nil) {
                                [injectCache addObject:[PropertyItem instanceWithType:propertyType name:propertyName]];
                                [target setValue:obj forKey:propertyName];
                            }
                        }
                    } else {
                        //NSAssert(propName && propName != NULL && propType && propType != NULL, @"doInject agres null !!!");
                    }
                }
                [[ATContainer sharedInstance] setClassPropertyInjectCache:injectCache forClass:className];
            }
            @catch (NSException *exception) {
                NSAssert1(!exception, @"截获异常%@", exception);
            }
            @finally {
                free(properties);
            }
        }
    }
    
    Class superclass = class_getSuperclass(clazz);
    if (superclass) {
        [[self class] doInject:target withClassType:superclass withContext:context];
    }
}


static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

@end
