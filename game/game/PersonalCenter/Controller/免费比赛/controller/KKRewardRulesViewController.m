//
//  KKRewardRulesViewController.m
//  game
//
//  Created by greatkk on 2019/1/14.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKRewardRulesViewController.h"
#import <WebKit/WebKit.h>
@interface KKRewardRulesViewController ()<WKNavigationDelegate>
@property (strong,nonatomic) UIView * contentView;
@property (strong,nonatomic) WKWebView * webView;
@end

@implementation KKRewardRulesViewController
-(void)loadView
{
    [super loadView];
    UIScrollView * scrollView = [UIScrollView new];
    scrollView.alwaysBounceVertical = true;
    scrollView.showsVerticalScrollIndicator = false;
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
}
-(void)initSubviews
{
    self.contentView = [UIView new];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(3000);
    }];
    WKWebViewConfiguration * configuration = [WKWebViewConfiguration new];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    _webView.scrollView.scrollEnabled = false;
    [self.contentView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.contentView);
    }];
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kInviteExplainUrl]]];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    __block CGFloat webViewHeight;
    __weak typeof(self) weakSelf = self;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        [weakSelf.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(webViewHeight * 0.5);
        }];
        [self.contentView layoutIfNeeded];
    }];
}
@end
