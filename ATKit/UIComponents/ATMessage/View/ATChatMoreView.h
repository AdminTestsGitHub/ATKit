//
//  ATChatMoreView.h
//  MiLin
//
//  Created by AdminTest on 2017/8/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATChatMoreViewDelegate;


@interface ATChatMoreView : UIView

@property (nonatomic, weak) id<ATChatMoreViewDelegate> delegate;
@property (nonatomic, strong) NSArray *items;

@end


@protocol ATChatMoreViewDelegate <NSObject>

@optional
- (void)ATChatMoreView:(ATChatMoreView *)moreView didSelectItem:(ATChatMoreViewItemType)itemType;

@end
