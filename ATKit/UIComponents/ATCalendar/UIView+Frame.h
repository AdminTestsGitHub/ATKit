//
//  UIView+Frame.h
//  Demo
//
//  Created by AdminTest on 2018/1/8.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// 分类不能添加成员属性
// @property如果在分类里面，只会自动生成get,set方法的声明，不会生成带有下划线的成员属性，和方法的实现

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@end
