//
//  ATStarView.h
//  DPCA
//
//  Created by AdminTest on 2018/1/5.
//  Copyright © 2018年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATStarView : UIView

/*! 星星数量 默认5 */
@property (nonatomic, assign) NSInteger numberOfStars;
/*! 评分的总分值，默认跟星星数量相等 */
@property (nonatomic, assign) CGFloat totalScore;
/*! 评分的当前分数，默认为0 */
@property (nonatomic, assign) CGFloat currentScore;
/*! 是否限制只能有整颗星，默认为YES */
@property (nonatomic, assign) BOOL isFullStarLimited;
/*! 是否可以点击 默认为YES */
@property (nonatomic, assign) BOOL isTouchable;
/*! 回调 */
@property (nonatomic, copy) void(^valueChangedBlock)(CGFloat score);


- (instancetype)initWithFrame:(CGRect)frame valueChangedBlock:(void(^)(CGFloat score))valueChangedBlock;
@end
