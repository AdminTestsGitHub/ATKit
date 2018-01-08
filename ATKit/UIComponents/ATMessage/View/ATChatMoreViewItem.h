//
//  ATChatMoreViewItem.h
//  MiLin
//
//  Created by AdminTest on 2017/8/14.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATChatMoreViewItem : UIView


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 *  创建一个ATChatMoreViewItem
 *
 *  @param title     item的标题
 *  @param imageName item的图片
 *
 *  @return item
 */
+ (ATChatMoreViewItem *)createChatBoxMoreItemWithTitle:(NSString *)title
                                                imageName:(NSString *)imageName;


@end
