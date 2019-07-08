//
//  KKWebViewController.m
//  game
//
//  Created by greatkk on 2018/11/28.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKWebViewController.h"
#import <WebKit/WebKit.h>
@interface KKWebViewController ()<WKNavigationDelegate>
@property (strong,nonatomic) WKWebView * webView;
@end

@implementation KKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(WKWebView *)webView
{
    if (_webView) {
        return _webView;
    }
    WKWebViewConfiguration * configuration = [WKWebViewConfiguration new];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.right.mas_equalTo(self.view);
        }else {
            make.top.left.right.bottom.mas_equalTo(self.view);
        }
    }];
    _webView.navigationDelegate = self;
    return _webView;
}
-(void)loadUrl:(NSString *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
-(void)loadLocalFile:(NSString *)fileName
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}
-(void)setWebTitle:(NSString *)webTitle
{
    if (_webTitle == webTitle) {
        return;
    }
    _webTitle = webTitle;
    self.navigationItem.title = _webTitle;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
//    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.zoom=%f",210/(210 - 31.8 * 2)] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        CGFloat w = ScreenWidth * 210/(210 - 31.8 * 2);
//        webView.scrollView.contentOffset = CGPointMake((ScreenWidth - w) * 0.5, 0);
//    }];
}
@end
