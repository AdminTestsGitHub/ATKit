//
//  ATChatViewController.m
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatViewController.h"
#import "ATChatViewModel.h"
#import "ATChatVideoCell.h"
#import "ATChatToolBar.h"
#import "ATChatVoiceCell.h"
#import "ATMessageManager.h"

@interface ATChatViewController ()  <ATChatBaseCellDelegate, UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ATUser *receiver;
@property (nonatomic, strong) ATConversation *conv;

@property (nonatomic, strong) UITextView *textView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) ATChatVoiceCell *playingVoiceCell;


@end


@implementation ATChatViewController

- (instancetype)initWithConversation:(ATConversation *)conv
{
    if (self = [super init]) {
        self.conv = conv;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self registerNotification];
    
    [self releaseConversation];
    
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI
{

    self.title = @"chat";

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    ATWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader chatHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf loadMoreDataSource];
    }];
}

- (void)registerNotification
{
    //监听有新消息进来的通知  通知列表刷新 被动触发刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource:) name:kATNotificationOnNewMessage object:nil];
    
    //监听成功发送一条新消息  通知列表刷新 主动触发刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessageSendSucceed) name:kATNotificationSendNewMessage object:nil];
}

- (void)releaseConversation
{
//    [self.conv releaseMsgList];
}

- (void)reloadDataSource:(NSNotification *)notify
{
    ATMessage *msg = notify.object;
    if (!msg.isSender && msg) {//自己发的信息 数据源先插入 所以发送成功就不需要再次插入
        [self.dataSource addObject:[ATChatViewModel modelWithMessage:msg]];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

// 加载数据
- (void)loadDataSource
{
    [self.dataSource removeAllObjects];
    /*
    [self.conv getLatestLocalMessageSucc:^(NSArray<ATMessage *> *list, BOOL hasMore) {
        self.hasMore = hasMore;
        for (ATMessage *msg in list) {
            [self.dataSource addObject:[ATChatViewModel modelWithMessage:msg]];
        }
        //倒置
        self.dataSource = [[self.dataSource reverseObjectEnumerator] allObjects].mutableCopy;
        
        [self.tableView reloadData];
        [self scrollToBottom];
    } fail:^(int code, NSString *msg) {
        
    }];
     */
}

- (void)loadMoreDataSource
{
    /*
    __block NSMutableArray *temp = [NSMutableArray array];
    [self.conv getLatestLocalMessageSucc:^(NSArray<ATMessage *> *list, BOOL hasMore) {
        self.hasMore = hasMore;
        for (ATMessage *msg in list) {
            [temp addObject:[ATChatViewModel modelWithMessage:msg]];
        }
        // 先倒置 在加入数据源最前面
        temp = [[temp reverseObjectEnumerator] allObjects].mutableCopy;
        
        NSRange range = NSMakeRange(0, [temp count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        
        [self.dataSource insertObjects:temp atIndexes:indexSet];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[temp count] inSection:0];
        
        dispatch_after(dispatch_e(DISPATCH_E_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
        
    } fail:^(int code, NSString *msg) {
        
    }];
     */
}

//综合发送
- (void)doSendWithATMessage:(ATMessage *)message
{
    /*
    ATWeak;
    [ATMessageManager sendMsg:message inConversation:self.conv success:^{
        weakSelf.conv.lastMsg = message;
        [[NSNotificationCenter defaultCenter] postNotificationName:kATNotificationSendNewMessage object:message];
    } failed:^(int code, NSString *msg) {
        ATMessage *failedMsg = [ATMessage failedMsgWithMessage:[message getMessage]];
        weakSelf.conv.lastMsg = failedMsg;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kATNotificationSendNewMessage object:failedMsg];
        
    }];
    
    ATChatViewModel *vm = [ATChatViewModel modelWithMessage:message];
    //添加本地数据源
    [self addObject:vm isSender:YES];
     */

}

// 增加数据源并刷新菊花loading
- (void)addObject:(ATChatViewModel *)vm isSender:(BOOL)isSender
{
    [self.dataSource addObject:vm];
    [self.tableView reloadData];
    if (isSender) {
        [self scrollToBottom];
    }
}

//更新状态隐藏菊花loading
- (void)reloadMessageSendSucceed
{
    ATWeak;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    });
}

#pragma mark - Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATChatViewModel *vm     = self.dataSource[indexPath.row];
    ATChatBaseCell *cell  = [vm tableView:tableView type:self.conv.conversationType];
    cell.delegate  = self;
    
    [cell configWithModel:vm];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATChatViewModel *vm = [self.dataSource objectAtIndex:indexPath.row];
    return vm.cellHight;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[ATChatVideoCell class]] && self) {
        ATChatVideoCell *videoCell = (ATChatVideoCell *)cell;
        [videoCell stopVideo];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self ATResignFirstResponder];
}

#pragma mark - overwrite
// send text message
- (void)sendTextMessage:(NSString *)messageStr
{
    if (messageStr && messageStr.length > 0) {
        ATMessage *message = [ATMessageManager createATMessageWithContent:messageStr];
        [self doSendWithATMessage:message];
    }
}

// send image message
- (void)sendImageMessage:(NSArray<NSString *> *)imgPaths
{
    if (!ATArrayIsEmpty(imgPaths)) {
        for (NSString *obj in imgPaths) {
            ATMessage *msg = [ATMessageManager createATMessageWithImagePath:obj];
            [self doSendWithATMessage:msg];
        }
    }
}

// send voice message
- (void)sendVoiceMessage:(NSString *)voicePath second:(int)sec
{
    if (voicePath) {
        ATMessage *msg = [ATMessageManager createATMessageWithVoicePath:voicePath sec:sec];
        [self doSendWithATMessage:msg];
    }
}

// send video message
- (void)sendVideoMessage:(NSString *)videoPath
{
    if (videoPath && videoPath.length > 0) {
        ATMessage *message = [ATMessageManager createATMessageWithVideoPath:videoPath];
        [self doSendWithATMessage:message];
    }
}

// send location message
- (void)sendLocationMessage:(ATLocation *)location
{
    ATMessage *message = [ATMessageManager createATMessageWithLocation:location];
    [self doSendWithATMessage:message];
}

// send file message
- (void)sendFileMessage:(NSString *)filePath
{
    /*
     NSString *lastName = [fileName originName];
     NSString *fileKey   = [fileName firstStringSeparatedByString:@"_"];
     NSString *content = [NSString stringWithFormat:@"[文件]%@",lastName];
     ICMessageFrame *messageFrame = [ICMessageHelper createMessageFrame:TypeFile content:content path:fileName from:@"gxz" to:self.conv.conversationID fileKey:nil isSender:YES receivedSenderByYourself:NO];
     NSString *path = [[ICFileTool fileMainPath] stringByAppendingPathComponent:fileName];
     double s = [ICFileTool fileSizeWithPath:path];
     NSNumber *x = [ICMessageHelper fileType:[fileName pathExtension]];
     if (!x) {
     x = @0;
     }
     NSDictionary *lnk = @{@"s":@((long)s),@"x":x,@"n":lastName};
     messageFrame.model.message.lnk = [lnk jsonString];
     messageFrame.model.message.fileKey = fileKey;
     [self addObject:messageFrame isSender:YES];
     */
}

- (void)otherSendTextMessageWithContent:(NSString *)messageStr
{
    if (messageStr && messageStr.length > 0) {
        ATMessage *message = [ATMessageManager createATMessageWithContent:messageStr];
        [self doSendWithATMessage:message];
    }
}

#pragma mark - ATChatBaseCellDelegate
- (void)chatCellClicked:(ATChatBaseCell *)cell
{
    if (cell.vm.msg.msgType == ATMessageType_Voice) {
        ATChatVoiceCell *voiceCell = (ATChatVoiceCell *)cell;
        
        if (self.playingVoiceCell) {
            [self.playingVoiceCell stopPlay];
            if ([self.playingVoiceCell isEqual:voiceCell]) {
                self.playingVoiceCell = nil;
            } else {
                self.playingVoiceCell = voiceCell;
                [voiceCell startPaly];
            }
        } else {
            self.playingVoiceCell = voiceCell;
            [voiceCell startPaly];
        }
    }
}

- (void)chatCellHeadImageClicked:(NSString *)userID
{
    
}

- (void)chatCellReSendMessage:(ATChatBaseCell *)baseCell
{
    
}

- (void)chatCellCopyMessage:(ATChatBaseCell *)baseCell
{
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    ATChatViewModel *vm = [self.dataSource objectAtIndex:self.longIndexPath.row];
    pasteboard.string = vm.msg.content;
}

- (void)chatCellDeleteMessage:(ATChatBaseCell *)baseCell
{
    // 这里还应该把本地的消息附件删除
    ATChatViewModel *vm = [self.dataSource objectAtIndex:self.longIndexPath.row];
    [self statusChanged:vm];
}

- (void)chatCellRevokeMessage:(ATChatBaseCell *)baseCell
{
    ATChatViewModel *vm = [self.dataSource objectAtIndex:self.longIndexPath.row];
    ATMessage *message = [ATMessage revokeMsgWithSender:vm.msg.sender];
    ATChatViewModel *newVM = [ATChatViewModel modelWithMessage:message];
    
    //发送撤销的网络请求
    ATWeak;
    [ATMessageManager revokeMsg:vm.msg inConversation:self.conv success:^{
        //当前刷新
        [weakSelf.dataSource replaceObjectAtIndex:self.longIndexPath.row withObject:newVM];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[self.longIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //如果撤回的是最新的一条消息 则对话列表刷新
        if (self.longIndexPath.row == weakSelf.dataSource.count - 1) {
            weakSelf.conv.lastMsg = message;
            [[NSNotificationCenter defaultCenter] postNotificationName:kATNotificationRevokeMessage object:message];
        }
    } failed:^(int code, NSString *msg) {
        
    }];
}

- (void)chatCellTransMessage:(ATChatBaseCell *)baseCell
{
    NSLog(@"需要用到的数据库，等添加了数据库再做转发...");
}


#pragma mark - public method

#pragma mark - private
- (void)scrollToBottom
{
    if (self.dataSource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)statusChanged:(ATChatViewModel *)vm
{
    [self.dataSource removeObject:vm];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[self.longIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setHasMore:(BOOL)hasMore
{
    _hasMore = hasMore;
    if (!hasMore) {
        self.tableView.mj_header = nil;
    }
}


@end
