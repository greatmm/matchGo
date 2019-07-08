//
//  KKNewShareView.m
//  game
//
//  Created by greatkk on 2019/1/15.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKNewShareView.h"

@interface KKNewShareView ()
@property (strong,nonatomic) UIImageView * topImgView;
@property (strong,nonatomic) UIView * contentView;
@property (strong,nonatomic) UILabel * titleLabel;
@property (strong,nonatomic) UILabel * codeLabel;
@property (strong,nonatomic) UILabel * desLabel;
@end

@implementation KKNewShareView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self initSubviews];
    }
    return self;
}
- (UIView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 10;
    _contentView.layer.masksToBounds = true;
    return _contentView;
}
-(UIImageView *)topImgView
{
    if (_topImgView) {
        return _topImgView;
    }
    _topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inviteCodeTop"]];
    return _topImgView;
}
-(UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = kThemeColor;
    _titleLabel.text = @"您的邀请码";
    return _titleLabel;
}
-(UILabel *)codeLabel
{
    if (_codeLabel) {
        return _codeLabel;
    }
    _codeLabel = [UILabel new];
    _codeLabel.font = [UIFont fontWithName:@"bahnschrift" size:46];
    _codeLabel.textColor = kThemeColor;
    _codeLabel.text = @"";
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    return _codeLabel;
}
-(UILabel *)desLabel
{
    if (_desLabel) {
        return _desLabel;
    }
    _desLabel = [UILabel new];
    _desLabel.font = [UIFont systemFontOfSize:12];
    _desLabel.textColor = k153Color;
    _desLabel.numberOfLines = 0;
    _desLabel.text = @"好友登录赛事狗输入邀请码双方\n各得一张锦标赛入场券";
    _desLabel.textAlignment = NSTextAlignmentCenter;
    return _desLabel;
}
-(void)initSubviews
{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
    }];
    if ([KKDataTool token]) {
        [self layoutUiLogin];
    } else {
        [self layoutUiNotLogin];
    }
    [self layoutIfNeeded];
}
- (void)layoutUiNotLogin
{
    self.topImgView.image = [UIImage imageNamed:@"notLoginShareIcon"];
    [self.contentView addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(28);
        make.width.mas_equalTo(228);
        make.height.mas_equalTo(205);
        make.left.mas_equalTo(self.contentView).offset(28);
    }];
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"rightTopClose"] forState:UIControlStateNormal];
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(28);
    }];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * shareLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareLine"]];
    [self.contentView addSubview:shareLine];
    [shareLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImgView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.topImgView).offset(10);
        make.height.mas_equalTo(2);
    }];
    NSMutableArray <NSNumber*>* arr = @[].mutableCopy;
    //    UMSocialPlatformType_WechatSession      = 1, //微信聊天
    //    UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
    //    UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
    //    UMSocialPlatformType_Qzone              = 5,//qq空间
    if ([WXApi isWXAppInstalled]) {
        [arr addObjectsFromArray:@[@1,@2]];
    }
    if ([QQApiInterface isQQInstalled]) {
        [arr addObjectsFromArray:@[@4,@5]];
    }
    NSInteger count = arr.count;
    if (count == 0) {
        [shareLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-20);
        }];
    } else {
        NSDictionary * imgs = @{@1:@"share0",@2:@"share1",@4:@"share2",@5:@"share3"};
        CGFloat w = 264 * 0.25 + 5;
        CGFloat h = w/66 * 71;
        if (count == 2) {
            for (int i = 0; i < count; i ++) {
                NSInteger tag = arr[i].integerValue;
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = tag;
                if ([imgs.allKeys containsObject:arr[i]]) {
                    [btn setBackgroundImage:[UIImage imageNamed:imgs[arr[i]]]  forState:UIControlStateNormal];
                }
                [self.contentView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView).offset(w * (i + 1));
                    make.size.mas_equalTo(CGSizeMake(w, h));
                    make.top.mas_equalTo(shareLine.mas_bottom).offset(25);
                }];
                [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        } else if (count == 4){
            for (int i = 0; i < count; i ++) {
                NSInteger tag = arr[i].integerValue;
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = tag;
                if ([imgs.allKeys containsObject:arr[i]]) {
                    [btn setBackgroundImage:[UIImage imageNamed:imgs[arr[i]]]  forState:UIControlStateNormal];
                }
                [self.contentView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView).offset(w * i);
                    make.size.mas_equalTo(CGSizeMake(w, h));
                    make.top.mas_equalTo(self.topImgView.mas_bottom).offset(25);
                }];
                [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [shareLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-h - 15 -25);
        }];
    }
}
- (void)layoutUiLogin
{
    [self.contentView addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(264);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
    }];
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"rightTopClose"] forState:UIControlStateNormal];
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(28);
    }];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.topImgView.mas_bottom);
    }];
    
    [self.contentView addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.right.mas_equalTo(self.topImgView);
    }];
    UIButton * copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    copyBtn.backgroundColor = kThemeColor;
    copyBtn.layer.cornerRadius = 15;
    copyBtn.layer.masksToBounds = true;
    [self.contentView addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(92, 30));
        make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(10);
    }];
    [copyBtn addTarget:self action:@selector(copyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(copyBtn.mas_bottom).offset(25);
    }];
    UIImageView * shareLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareLine"]];
    [self.contentView addSubview:shareLine];
    [shareLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self.topImgView);
        make.height.mas_equalTo(2);
    }];
    NSMutableArray <NSNumber*>* arr = @[].mutableCopy;
    //    UMSocialPlatformType_WechatSession      = 1, //微信聊天
    //    UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
    //    UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
    //    UMSocialPlatformType_Qzone              = 5,//qq空间
    if ([WXApi isWXAppInstalled]) {
        [arr addObjectsFromArray:@[@1,@2]];
    }
    if ([QQApiInterface isQQInstalled]) {
        [arr addObjectsFromArray:@[@4,@5]];
    }
    NSInteger count = arr.count;
    if (count == 0) {
        [shareLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-20);
        }];
    } else {
        NSDictionary * imgs = @{@1:@"share0",@2:@"share1",@4:@"share2",@5:@"share3"};
        CGFloat w = CGRectGetWidth(self.topImgView.bounds) * 0.25 + 5;
        CGFloat h = w/66 * 71;
        if (count == 2) {
            for (int i = 0; i < count; i ++) {
                NSInteger tag = arr[i].integerValue;
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = tag;
                if ([imgs.allKeys containsObject:arr[i]]) {
                    [btn setBackgroundImage:[UIImage imageNamed:imgs[arr[i]]]  forState:UIControlStateNormal];
                }
                [self.contentView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView).offset(w * (i + 1));
                    make.size.mas_equalTo(CGSizeMake(w, h));
                    make.top.mas_equalTo(shareLine.mas_bottom).offset(25);
                }];
                [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        } else if (count == 4){
            for (int i = 0; i < count; i ++) {
                NSInteger tag = arr[i].integerValue;
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = tag;
                if ([imgs.allKeys containsObject:arr[i]]) {
                    [btn setBackgroundImage:[UIImage imageNamed:imgs[arr[i]]]  forState:UIControlStateNormal];
                }
                [self.contentView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView).offset(w * i);
                    make.size.mas_equalTo(CGSizeMake(w, h));
                    make.top.mas_equalTo(shareLine.mas_bottom).offset(25);
                }];
                [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [shareLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-h -15 -25);
        }];
    }
}
-(void)copyCode
{
    [KKDataTool copyStr:self.codeStr];
    NSString * str = (self.shareType == KKShareTypeRoomCode?@"房间号已复制至剪切板":@"邀请码已复制至剪切板");
    [KKAlert showText:str toView:self];
}
-(void)setCodeStr:(NSString *)codeStr
{
    if (_codeStr != codeStr) {
        _codeStr = codeStr;
    }
    self.codeLabel.text = codeStr;
//    if (codeStr.length > 0) {
//        [self textAlignmentLeftAndRightWith:CGRectGetWidth(self.topImgView.bounds)];
//    }
}
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth{
    
    CGSize size = [self.codeStr boundingRectWithSize:CGSizeMake(labelWidth,MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :self.codeLabel.font} context:nil].size;
    
    CGFloat margin = (labelWidth - size.width)/(self.codeStr.length - 1);
    
    NSNumber *number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.codeStr];
    
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,self.codeStr.length -1)];
    
    self.codeLabel.attributedText = attribute;
    
}
-(void)clickShareBtn:(UIButton *)btn
{
    DLOG(@"分享的地方：%ld",btn.tag);
    if (self.shareBlock) {
        self.shareBlock(btn.tag);
    }
    [self removeFromSuperview];
}
- (void)clickCloseBtn
{
    [self removeFromSuperview];
}
- (void)setShareType:(KKShareType)shareType
{
    _shareType = shareType;
    if (_shareType == KKShareTypeRoomCode) {
        self.topImgView.image = [UIImage imageNamed:@"roomCodeTop"];
        self.titleLabel.text = @"您的房间号";
        self.desLabel.text = @"好友登录赛事狗点加入对战->\n输入房间号，就可以进入比赛房间啦~";
    }
}
@end
