//
//  ATScrollTopBar.h
//  MiLin
//
//  Created by AdminTest on 2017/9/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATScrollTopBarDelegate;

@interface ATScrollTopBar : UIView

@property (nonatomic, weak) id<ATScrollTopBarDelegate> delegate;

- (instancetype)initWithTitles:(NSArray *)titles andExtraBtn:(UIButton *)extraBtn;

- (void)setCurrentPage:(NSInteger)index withRate:(CGFloat)rate;
- (void)selectWithIndex:(int)index otherIndex:(int)tag;

@end


@protocol ATScrollTopBarDelegate <NSObject>

- (void)ATScrollTopBar:(ATScrollTopBar *)topBar withIndex:(int)index;

@end
