//
//  ATSegmentedSectionView.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATSectionView.h"

@interface ATSegmentedSectionView : ATSectionView

@property (nonatomic, strong) id configModel;

- (instancetype)initWithConfigModel:(id)configModel;

@end



@protocol ATSegmentedSectionHeaderViewDelegate;

@interface ATSegmentedSectionHeaderView : ATSegmentedSectionView

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, weak) id<ATSegmentedSectionHeaderViewDelegate> delegate;

@end

@protocol ATSegmentedSectionHeaderViewDelegate <NSObject>

@optional
- (void)ATSegmentedSectionHeaderView:(ATSegmentedSectionHeaderView *)view didClickBtnWithData:(id)data;

@end



@protocol ATSegmentedSectionFooterViewDelegate;

@interface ATSegmentedSectionFooterView : ATSegmentedSectionView

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, weak) id<ATSegmentedSectionFooterViewDelegate> delegate;

@end

@protocol ATSegmentedSectionFooterViewDelegate <NSObject>

@optional
- (void)ATSegmentedSectionFooterView:(ATSegmentedSectionFooterView *)view didClickBtnWithIndexPathSection:(NSInteger)section btnTitle:(NSString *)title index:(NSInteger)idx;

@end
