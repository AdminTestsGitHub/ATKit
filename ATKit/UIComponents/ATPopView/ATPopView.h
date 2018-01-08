//
//  ATPopView.h
//  MiLin
//
//  Created by AdminTest on 2017/10/19.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATCustomBtn : UIButton

@end


@interface ATPopMenuItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon;


@end


@interface ATPopView : UIView

+ (instancetype)showInView:(UIView *)view withItems:(NSArray *)items selectBlock:(void (^)(ATPopMenuItem *item))block;


@end
