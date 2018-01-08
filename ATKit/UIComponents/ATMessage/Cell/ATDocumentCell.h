//
//  ATDocumentCell.h
//  MiLin
//
//  Created by AdminTest on 2017/8/15.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatBaseCell.h"

@protocol ATDocumentCellDelegate <NSObject>

- (void)selectBtnClicked:(id)sender;

@end

@interface ATDocumentCell : ATChatBaseCell

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filePath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton *selectBtn;

@end
