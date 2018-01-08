//
//  ATConversationListCell.h
//  MiLin
//
//  Created by AdminTest on 2017/7/26.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

@class ATConversationListModel;

@interface ATConversationListCell : QMUITableViewCell

@property (nonatomic, strong) ATConversationListModel *model;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configWithConversation:(ATConversation *)conv;

@end
