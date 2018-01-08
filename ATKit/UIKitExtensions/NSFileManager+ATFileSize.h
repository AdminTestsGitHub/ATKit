//
//  NSFileManager+ATFileSize.h
//  MiLin
//
//  Created by AdminTest on 2017/9/19.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ATFileSize)

/**
 计算路径下的文件内存大小，完全使用 unix c 函数 性能最好
 
 @param filePath 文件路径
 @return 文件内存大小
 */
+ (int64_t)calculateFileSizeWithFilePath:(NSString *)filePath;


@end
