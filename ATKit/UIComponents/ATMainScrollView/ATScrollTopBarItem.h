//
//  ATScrollTopBarItem.h
//  MiLin
//
//  Created by AdminTest on 2017/9/18.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

@interface ATScrollTopBarItem : UIButton

@property (nonatomic, copy  ) NSString *fontName;
@property (nonatomic, assign) CGFloat  fontSize;
@property (nonatomic, assign) CGFloat  nomrmalSize;
@property (nonatomic, assign) CGFloat  rate;
// normal状态的字体颜色
@property (nonatomic, strong) UIColor  *normalColor;
//selected状态的字体颜色
@property (nonatomic, strong) UIColor  *selectedColor;
@property (nonatomic, strong) UIColor  *titlecolor;

- (instancetype)initWithTitles:(NSArray *)titles AndIndex:(int)index;

- (void)selectedItemWithoutAnimation;
- (void)deselectedItemWithoutAnimation;
- (void)ChangSelectedColorAndScalWithRate:(CGFloat)rate;

@end
