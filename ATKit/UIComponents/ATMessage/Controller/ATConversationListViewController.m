//
//  ATConversationListViewController.m
//  MiLin
//
//  Created by AdminTest on 2017/7/25.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATConversationListViewController.h"
#import "ATConversationListCell.h"
#import "ATChatViewController.h"
#import "ATContactViewController.h"

@interface ATConversationListViewController ()

@property (nonatomic, strong) NSMutableArray *conversationList;

@end


@implementation ATConversationListViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ATInjecter doInjectWithTarget:self];
    
    self.title = @"消息";
    
    [self setShouldShowSearchBar:YES];
    
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton  barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"刷新列表" position:QMUINavigationButtonPositionRight target:self action:@selector(handleAboutItemEvent)];
    
    
    self.navigationItem.leftBarButtonItem = [QMUINavigationButton  barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"通讯录" position:QMUINavigationButtonPositionLeft target:self action:@selector(handleLeftItemEvent)];
    
    [self registerNotification];
    
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Private Methods
- (void)registerNotification
{
    //ATTIMConversationManager同步对话列表 通知对话列表刷新 被动刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource:) name:kATNotificationReloadConversationList object:nil];
    
    //监听有新消息进来的通知  通知列表刷新 被动触发刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource:) name:kATNotificationOnNewMessage object:nil];
    
    //监听成功发送一条新消息  通知列表刷新 主动触发刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource:) name:kATNotificationSendNewMessage object:nil];
    
    //监听成功撤销一条新消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource:) name:kATNotificationRevokeMessage object:nil];
}

- (void)reloadDataSource:(NSNotification *)notify
{
    self.conversationList = nil;
    [self.tableView reloadData];
}

- (void)loadDataSource
{
    self.conversationList = nil;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATConversationListCell *cell = [ATConversationListCell cellWithTableView:tableView];
    if (indexPath.row == self.conversationList.count - 1) {
    
    } else {

    }
    [cell configWithConversation:self.conversationList[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversationList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    //设置删除按钮
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //        [self deleteLocalGroup:indexPath];
    }];
    //置顶
    UITableViewRowAction * topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //        [self setTopCellWithIndexPath:indexPath currentTop:group.isTop];
    }];
    //标记已读
    UITableViewRowAction * collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"标记已读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //        [self markerReadWithIndexPath:indexPath currentUnReadCount:group.unReadCount];
    }];
    collectRowAction.backgroundColor = [UIColor grayColor];
    topRowAction.backgroundColor     = [UIColor orangeColor];
    return  @[deleteRowAction,topRowAction,collectRowAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    
}
#pragma mark - Event Response
- (void)handleAboutItemEvent
{
    [self loadDataSource];
}

- (void)handleLeftItemEvent
{
    ATContactViewController *contact = [[ATContactViewController alloc] init];
    [self.navigationController pushViewController:contact animated:YES];
}

#pragma mark - setter and getter

- (NSMutableArray *)conversationList
{
    if (!_conversationList) {
        _conversationList = [NSMutableArray array];
    }
    return  _conversationList;
}

@end
