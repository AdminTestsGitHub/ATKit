//
//  NSString+ATExtension.m
//  MiLin
//
//  Created by AdminTest on 2017/9/22.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "NSString+ATExtension.h"

@implementation NSString (ATExtension)

- (NSString *)URLEncodeString
{
    if ([self includeChinese]) {
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:set];
        return encodedString;
    }
    
    return self;
}

- (BOOL)includeChinese
{
    for (int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (CGSize)sizeThatFitsMaxWidth:(CGFloat)width andFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (BOOL)isEmpty
{
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isContainsString:(NSString *)str
{
    if ([self isEmpty])
    {
        return NO;
    }
    
    if ([self respondsToSelector:@selector(containsString:)])
    {
        return [self containsString:str];
    }
    
    return [self rangeOfString:str].location != NSNotFound;
}

@end
