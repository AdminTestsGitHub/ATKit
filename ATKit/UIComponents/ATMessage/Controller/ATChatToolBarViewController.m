//
//  ATChatToolBarViewController.m
//  DPCA
//
//  Created by AdminTest on 2017/12/11.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATChatToolBarViewController.h"
#import "ATChatToolBar.h"
#import "ATChatMoreView.h"
#import "ATImagePickerPreviewViewController.h"
#import "ATMapViewController.h"
#import "ATDocumentViewController.h"
#import "ATImagePickerManager.h"
#import "ATCameraManager.h"

static CGFloat const kEmotionViewHeight = 232;

@interface ATChatToolBarViewController () <ATChatToolBarDelegate, QMUIKeyboardManagerDelegate, ATChatMoreViewDelegate, ATImagePickerManagerDelegate, ATMapViewControllerDelegate, ATDocumentViewControllerDelegate, ATCameraManagerDelegate>

@property (nonatomic, strong) QMUIKeyboardManager *keyboardManager;
@property (nonatomic, strong) QMUIEmotionInputManager *qqEmotionManager;
@property (nonatomic, strong) ATImagePickerManager *imagePickerManager;
@property (nonatomic, strong) ATCameraManager *cameraManager;

@property (nonatomic, strong) ATChatMoreView *moreView;
@property (nonatomic, strong) QMUIEmotionView *emotionView;

@end

@implementation ATChatToolBarViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    
    self.keyboardManager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
    [self.keyboardManager addTargetResponder:self.toolBar.textView];
    
    self.qqEmotionManager = [[QMUIEmotionInputManager alloc] init];
    self.qqEmotionManager.boundTextView = self.toolBar.textView;
    self.qqEmotionManager.emotionView.qmui_borderPosition = QMUIBorderViewPositionTop;
    
    self.imagePickerManager = [[ATImagePickerManager alloc] initWithDelegate:self];
    
    self.cameraManager = [[ATCameraManager alloc] initWithDelegate:self];
    
    __weak __typeof(self)weakSelf = self;
    self.toolBar.textView.qmui_keyboardWillChangeFrameNotificationBlock = ^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        if (weakSelf.toolBar.status == ATChatToolBarStatus_Input) {
            [weakSelf showToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
        } else {
            [weakSelf hideToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
        }
    };
    
    [self setUpUI];
    
    [self.toolBar addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Private Methods

- (void)setUpUI
{
    self.view.backgroundColor = UIColorMake(240, 237, 237);
    self.tableView.backgroundColor = UIColorMake(240, 237, 237);
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.emotionView];
    [self.view addSubview:self.moreView];
}

- (void)showToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    if (keyboardUserInfo) {
        // 相对于键盘
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:self.view keyboardRect:keyboardUserInfo.endFrame];
            self.emotionView.transform = CGAffineTransformIdentity;
            self.moreView.transform = CGAffineTransformIdentity;
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, -distanceFromBottom);
        } completion:NULL];
    }
}

- (void)hideToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    if (keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            self.toolBar.transform = CGAffineTransformIdentity;
            self.emotionView.transform = CGAffineTransformIdentity;
            self.moreView.transform = CGAffineTransformIdentity;
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            self.toolBar.transform = CGAffineTransformIdentity;
            self.emotionView.transform = CGAffineTransformIdentity;
            self.moreView.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }
}

- (void)showEmotionView {
    [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(self.emotionView.bounds));
        self.emotionView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(self.emotionView.bounds));
        self.moreView.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

- (void)showMoreView
{
    [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(self.moreView.bounds));
        self.moreView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(self.moreView.bounds));
        self.emotionView.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

- (void)touchesTableView:(UITapGestureRecognizer *)gesture
{
    [self ATResignFirstResponder];
}

- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.tableView];
        self.longIndexPath = [self.tableView indexPathForRowAtPoint:point];
        ATChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:self.longIndexPath];
        if ([cell canShowMenuOnTouchOf:sender]) {
            [cell showMenu];
        }
    }
}

- (void)ATResignFirstResponder
{
    if ([UIMenuController sharedMenuController].isMenuVisible) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    if ([self.toolBar.textView isFirstResponder]) {
        [self.toolBar.textView resignFirstResponder];
    }
    
    if (self.toolBar.faceButton.isSelected) {
        self.toolBar.faceButton.selected = NO;
        [self hideToolbarViewWithKeyboardUserInfo:nil];
    }
    
    if (self.toolBar.moreButton.isSelected) {
        self.toolBar.moreButton.selected = NO;
        [self hideToolbarViewWithKeyboardUserInfo:nil];
    }
    self.toolBar.status = ATChatToolBarStatus_Input;
}

#pragma mark - kvo
/*! 监听到toolbar的transform变化 （当前的toolbar已经变化！！ self.toolBar.transform 是已经变化的值 是新值！！） */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGAffineTransform transformNew = [change[NSKeyValueChangeNewKey] CGAffineTransformValue];
    
    if (transformNew.ty == 0) {//变回原始状态 键盘收起的状态
        self.tableView.transform = CGAffineTransformIdentity;
    } else {
        CGFloat distance = [self getDistanceFromLastCellMaxYToToolBarMinYInWindow];
        [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            self.tableView.transform = CGAffineTransformMakeTranslation(0, self.tableView.transform.ty - distance);
        } completion:NULL];
    }
}

/*! 计算toolbar遮挡lastcell的距离 遮挡住（return > 0）就改变tableview的transform */
- (CGFloat)getDistanceFromLastCellMaxYToToolBarMinYInWindow
{
    CGFloat distance = 0;
    NSArray *cells = self.tableView.visibleCells;
    if (!ATArrayIsEmpty(cells)) {
        UITableViewCell *lastCell = cells.lastObject;
        CGRect rect = [lastCell.superview convertRect:lastCell.frame toView:self.view];
        CGFloat lastCellMaxY = round(rect.origin.y + rect.size.height);
        
        if (lastCellMaxY >= self.toolBar.y) {
            distance = lastCellMaxY - self.toolBar.y;
        }
    }
    
    return distance;
}

#pragma mark - send
- (void)sendTextMessage:(NSString *)messageStr
{
    
}

- (void)sendImageMessage:(NSArray <NSString *> *)imgPaths
{
    
}

- (void)sendVoiceMessage:(NSString *)voicePath second:(int)sec
{
    
}

- (void)sendVideoMessage:(NSString *)videoPath
{
    
}

- (void)sendLocationMessage:(ATLocation *)location
{
    
}

- (void)sendFileMessage:(NSString *)filePath
{
    
}

#pragma mark - ATChatToolBarDelegate
- (void)ATChatToolBar:(ATChatToolBar *)toolBar buttonDidClickWithAction:(ATChatToolBarStatus)action
{
    if (action == ATChatToolBarStatus_Face) {
        [self showEmotionView];
    } else if (action == ATChatToolBarStatus_More) {
        [self showMoreView];
    } else if (action == ATChatToolBarStatus_Voice) {
        [self hideToolbarViewWithKeyboardUserInfo:nil];
    }
}

- (void)ATChatToolBar:(ATChatToolBar *)toolBar sendTextMessage:(NSString *)textMessage
{
    [self sendTextMessage:textMessage];
}

- (void)ATChatToolBar:(ATChatToolBar *)toolBar sendAudioMessage:(NSString *)audioPath second:(int)second
{
    [self sendVoiceMessage:audioPath second:second];
}

#pragma mark - ATChatMoreViewDelegate
- (void)ATChatMoreView:(ATChatMoreView *)moreView didSelectItem:(ATChatMoreViewItemType)itemType
{
    if (itemType == ATChatMoreViewItemType_Album) {
        [self.imagePickerManager presentAlbumViewController];
    } else if (itemType == ATChatMoreViewItemType_Camera) {
        [self.cameraManager presentCameraViewController];
    } else if (itemType == ATChatMoreViewItemType_Location) {
        ATMapViewController *map = [[ATMapViewController alloc] init];
        map.delegate = self;
        ATNavigationController *nav = [[ATNavigationController alloc] initWithRootViewController:map];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (itemType == ATChatMoreViewItemType_File) {
        ATDocumentViewController *docVC = [[ATDocumentViewController alloc] init];
        docVC.delegate = self;
        ATNavigationController *nav = [[ATNavigationController alloc] initWithRootViewController:docVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - ATImagePickerManagerDelegate
- (void)didFinishPickingImageWithImagePaths:(NSArray *)imagePaths
{
    [self sendImageMessage:imagePaths];
}

#pragma mark - ATCameraManagerDelegate
- (void)CameraDidFinishWithFilePath:(NSString *)filePath
{
    [self sendVideoMessage:filePath];
}

#pragma mark - ATMapViewControllerDelegate
- (void)ATMapViewController:(ATMapViewController *)vc didSelectPointWithLocation:(ATLocation *)location
{
    [self sendLocationMessage:location];
}

#pragma mark - ATDocumentViewControllerDelegate
- (void)ATDocumentViewController:(ATDocumentViewController *)documentVC selectedFileName:(NSString *)fileName
{
    [self sendFileMessage:fileName];
}

#pragma mark - CustomDelegate

#pragma mark - Event Response
- (void)emotionSendBtnAction
{
    [self.toolBar sendMessage];
}

#pragma mark - Getters And Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - ATChatToolBarHeight) style:UITableViewStylePlain];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesTableView:)];
        [_tableView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longRecognizer.minimumPressDuration = 0.5;
        [_tableView addGestureRecognizer:longRecognizer];
        
        [tap requireGestureRecognizerToFail:longRecognizer];
        
    }
    return _tableView;
}

- (ATChatToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = ({
            ATChatToolBar *bar = [[ATChatToolBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - ATChatToolBarHeight, SCREEN_WIDTH, ATChatToolBarHeight)];
            bar.delegate = self;
            bar;
        });
    }
    return _toolBar;
}

- (QMUIEmotionView *)emotionView
{
    if (!_emotionView) {
        _emotionView = self.qqEmotionManager.emotionView;
        CGRect emotionViewRect = CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(self.view.bounds), kEmotionViewHeight);
        _emotionView.frame = CGRectApplyAffineTransform(emotionViewRect, _emotionView.transform);
        [_emotionView.sendButton addTarget:self action:@selector(emotionSendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emotionView;
}

- (ATChatMoreView *)moreView
{
    if (!_moreView) {
        _moreView = [[ATChatMoreView alloc] init];
        CGRect emotionViewRect = CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(self.view.bounds), kEmotionViewHeight);
        _moreView.frame = CGRectApplyAffineTransform(emotionViewRect, _moreView.transform);
        _moreView.delegate = self;
    }
    return _moreView;
}

@end

