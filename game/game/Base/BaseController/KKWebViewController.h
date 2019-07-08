//
//  KKWebViewController.h
//  game
//
//  Created by greatkk on 2018/11/28.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKWebViewController : KKBaseViewController
@property (strong,nonatomic) NSString * webTitle;//文件标题
-(void)loadLocalFile:(NSString *)fileName;//加载本地文件
-(void)loadUrl:(NSString *)url;//加载线上的网页
@end

NS_ASSUME_NONNULL_END
