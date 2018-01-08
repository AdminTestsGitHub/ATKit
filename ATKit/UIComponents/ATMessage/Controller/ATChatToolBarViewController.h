//
//  ATChatToolBarViewController.h
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATCommonViewController.h"
#import "ATChatToolBar.h"
#import "ATChatBaseCell.h"

@interface ATChatToolBarViewController : ATCommonViewController

@property (nonatomic, strong) ATChatToolBar *toolBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *longIndexPath;

- (void)ATResignFirstResponder;

- (void)sendTextMessage:(NSString *)messageStr;

- (void)sendImageMessage:(NSArray <NSString *> *)imgPaths;

- (void)sendVoiceMessage:(NSString *)voicePath second:(int)sec;

- (void)sendVideoMessage:(NSString *)videoPath;

- (void)sendLocationMessage:(ATLocation *)location;

- (void)sendFileMessage:(NSString *)filePath;



@end
