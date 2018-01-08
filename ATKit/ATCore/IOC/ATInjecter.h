//
//  ATInjecter.h
//  MiLin
//
//  Created by AdminTest on 2017/9/13.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyItem : NSObject

@property (nonatomic) NSString* propertyType;
@property (nonatomic) NSString* propertyName;
+(instancetype)instanceWithType:(NSString*)propertyType name:(NSString*)propertyName;
-(instancetype)initWithType:(NSString*)propertyType name:(NSString*)propertyName;

@end

@interface ATInjecter : NSObject

+ (void)doInjectWithTarget:(__kindof id)target;

+ (NSString*)getProperType:(const char *)typeCStr;

+ (void)InjectContainerWithConfigs:(NSArray*)configs;

@end
