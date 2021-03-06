//
//  ATWebViewController.m
//  MiLin
//
//  Created by AdminTest on 2017/9/22.
//Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATWebViewController.h"
#import <WebKit/WebKit.h>

@interface ATWebViewController () <UIWebViewDelegate, WKNavigationDelegate>

@property (assign, nonatomic) NSUInteger       loadCount;
@property (strong, nonatomic) UIProgressView  *progressView;
@property (strong, nonatomic) UIWebView       *webView;
@property (strong, nonatomic) WKWebView       *wkWebView;

@end

@implementation ATWebViewController

- (instancetype)initWithURLString:(NSString *)urlString hiddenMenu:(BOOL)hidden
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.hiddenMenu = hidden;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    
    [self configBackItem];
    
    if (!self.hiddenMenu) {
        [self configMenuItem];
    }
}

#pragma mark - ***** 进度条
- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        progressView.tintColor = UIColorRed;
        progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}

#pragma mark - ***** UI创建
- (void)configUI
{
    self.progressView.hidden = NO;
//    self.urlString = @"http://m.jd.com/";
    
    
    /*! 网页 */
    if (IOS8_SDK_ALLOWED) {
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        wkWebView.backgroundColor = [UIColor whiteColor];
        wkWebView.navigationDelegate = self;
        
        /*! 适应屏幕 */
        //        wkWebView.scalesPageToFit = YES;
        /*! 解决iOS9.2以上黑边问题 */
        wkWebView.opaque = NO;
        /*! 关闭多点触控 */
        wkWebView.multipleTouchEnabled = YES;
        /*! 加载网页中的电话号码，单击可以拨打 */
        //        wkWebView.dataDetectorTypes = YES;
        
        [self.view insertSubview:wkWebView belowSubview:_progressView];
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
        [wkWebView loadRequest:request];
        self.wkWebView = wkWebView;
    } else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        /*! 适应屏幕 */
        webView.scalesPageToFit = YES;
        /*! 解决iOS9.2以上黑边问题 */
        webView.opaque = NO;
        /*! 关闭多点触控 */
        webView.multipleTouchEnabled = YES;
        /*! 加载网页中的电话号码，单击可以拨打 */
        webView.dataDetectorTypes = YES;
        
        [self.view insertSubview:webView belowSubview:_progressView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
        [webView loadRequest:request];
        self.webView = webView;
    }
}

#pragma mark 导航栏的菜单按钮
- (void)configMenuItem
{
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"navigationbar_more") position:QMUINavigationButtonPositionRight target:self action:@selector(handleRightButtonEvent:)];
}

#pragma mark 导航栏的返回按钮
- (void)configBackItem
{
    UIBarButtonItem *backItem = [QMUINavigationButton backBarButtonItemWithTarget:self action:@selector(backBtnAction:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark 导航栏的关闭按钮
- (void)configColseItem
{
    UIBarButtonItem *closeItem = [QMUINavigationButton closeBarButtonItemWithTarget:self action:@selector(colseBtnAction:)];
    
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem, closeItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

- (void)backBtnAction:(UIButton *)sender
{
    if (IOS8_SDK_ALLOWED) {
        if (self.wkWebView.canGoBack) {
            [self.wkWebView goBack];
            if (self.navigationItem.leftBarButtonItems.count == 1) {
                [self configColseItem];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        if (self.webView.canGoBack) {
            [self.webView goBack];
            if (self.navigationItem.leftBarButtonItems.count == 1) {
                [self configColseItem];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark 菜单按钮点击
- (void)handleRightButtonEvent:(UIButton *)sender
{
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"更多" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"safari打开" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
    }]];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"复制链接" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        
    }]];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"分享" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        
    }]];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"刷新" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        
    }]];
    [alertController addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [alertController showWithAnimated:YES];
    
    
    
//
//    NSArray *reasons = @[@"取消", @"safari打开",@"复制链接",@"分享",@"刷新"];
//    [ATDialog dialogWithTitle:@"更多" items:reasons handler:^(NSInteger idx) {
//        NSString *urlStr = [NSURL URLWithString:self.urlString].absoluteString;
//        if (IOS8_SDK_ALLOWED)
//            urlStr = self.wkWebView.URL.absoluteString;
//        else
//            urlStr = self.webView.request.URL.absoluteString;
//
//        if (idx == 0)
//        {
//            return ;
//        }
//        if (idx == 1)
//        {
//            /*! safari打开 */
//            [SharedApplication openURL:[NSURL URLWithString:urlStr]];
//        }
//        else if (idx == 2)
//        {
//            /*! 复制链接 */
//            if (urlStr.length > 0)
//            {
//                [[UIPasteboard generalPasteboard] setString:urlStr];
//                [ATTips tipsWithMessage:@"亲爱的，已复制URL到黏贴板中！"];
//                return;
//            }
//        }
//        else if (idx == 3)
//        {
//            NSString *shareTitle = @"分享 2.0 版";
//            NSString *shareUrlSrt = @"http://www.baidu.com";
//            NSString *shareContent = [NSString stringWithFormat:@"测试（ATBaseProject）分享【之家】！详情点击：%@", shareUrlSrt];
//            // 注意：图片不能为空
//            UIImage *shareImage = [UIImage imageNamed:@"fs_icon"];
//
//        }
//        else if (idx == 4)
//        {
//            /*! 刷新 */
//            if (IOS8_SDK_ALLOWED)
//                [self.wkWebView reload];
//            else
//                [self.webView reload];
//        }
//
//    }];
    
}

#pragma mark 关闭按钮点击
- (void)colseBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate 【该代理提供的方法，可以用来追踪加载过程（页面开始加载、加载完成、加载失败）、决定是否执行跳转。】
#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    // 类似UIWebView的 -webViewDidStartLoad:
    NSLog(@"didStartProvisionalNavigation");
    SharedApplication.networkActivityIndicatorVisible = YES;
}

#pragma mark 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"didCommitNavigation");
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 类似 UIWebView 的 －webViewDidFinishLoad:
    NSLog(@"didFinishNavigation");
    if (webView.title.length > 0)
    {
        self.title = webView.title;
    }
    
    // 获取内容高度
    //    CGFloat height =  [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
    //
    //    NSLog(@"html 的高度：%f", height);
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    NSLog(@"didFailProvisionalNavigation");
}

/*! 页面跳转的代理方法有三种，分为（收到跳转与决定是否跳转两种）*/
#pragma mark 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

#pragma mark 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark 在发送请求之前，决定是否跳转，如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"])
    {
        [SharedApplication openURL:(navigationAction.request.URL)];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
//{
//
//}

#pragma mark 创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    // 接口的作用是打开新窗口委托
//    [self createNewWebViewWithURL:webView.URL.absoluteString config:configuration];
//    return _wkWebView2;
//}
//
//- (void)createNewWebViewWithURL:(NSString *)url config:(WKWebViewConfiguration *)configuration
//{
//    _wkWebView2 = [[WKWebView alloc] initWithFrame:self.wkWebView.frame configuration:configuration];
//    [_wkWebView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//}

#pragma mark 针对于web界面的三种提示框（警告框、确认框、输入框）分别对应三种代理方法。下面只举了警告框的例子。
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
//{
//    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
//                                                                             message:nil
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction *action) {
//                                                          completionHandler(YES);
//                                                      }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
//                                                        style:UIAlertActionStyleCancel
//                                                      handler:^(UIAlertAction *action){
//                                                          completionHandler(NO);
//                                                      }]];
//
//    [self presentViewController:alertController animated:YES completion:^{}];
//
//}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler
{
    completionHandler(@"Client Not handler");
}

#pragma mark 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}


#pragma mark 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1)
        {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }
        else
        {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - ***** dealloc 记得取消监听
- (void)dealloc
{
    if (IOS8_SDK_ALLOWED)
    {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark - ***** UIWebViewDelegate
#pragma mark 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount
{
    _loadCount = loadCount;
    if (loadCount == 0)
    {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }
    else
    {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95)
        {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    SharedApplication.networkActivityIndicatorVisible = NO;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    // 获取内容高度
    CGFloat height =  [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
    
    NSLog(@"html 的高度：%f", height);
    
    //    CGFloat htmlHeight;
    //    // 防止死循环
    //    if (height != htmlHeight)
    //    {
    //
    //        htmlHeight = height;
    //
    //        if (height > 0)
    //        {
    //            // 更新布局
    //            CGFloat paddingEdge = 10;
    //            [webView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //
    //                make.left.equalTo(self.view).with.offset(paddingEdge);
    //                make.right.mas_equalTo(-paddingEdge);
    //                make.top.equalTo(self.view).with.offset(paddingEdge);
    //                make.bottom.mas_equalTo(-paddingEdge);
    //
    //            }];
    //
    //            // 刷新cell高度
    ////            _viewModel.cellHeight = _viewModel.otherHeight + _viewModel.htmlHeight;
    ////            [_viewModel.refreshSubject sendNext:nil];
    //        }
    //        NSLog(@"html 的高度：%f", htmlHeight);
    //    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadCount --;
}

- (void)setUrlString:(NSString *)urlString
{
    //转义中文
    _urlString = [urlString URLEncodeString];
}
@end
