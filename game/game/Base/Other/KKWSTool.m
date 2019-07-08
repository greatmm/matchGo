//
//  KKWSTool.m
//  game
//
//  Created by GKK on 2018/9/17.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKWSTool.h"
#import <SocketRocket.h>
#import "KKHintTool.h"
#import "KKWSCode.h"
NSString * const kWebSocketDidOpenNote           = @"kWebSocketDidOpenNote";
NSString * const kWebSocketDidCloseNote          = @"kWebSocketDidCloseNote";
NSString * const kWebSocketdidReceiveMessageNote = @"kWebSocketdidReceiveMessageNote";

@interface KKWSTool()<SRWebSocketDelegate>
@property (nonatomic,strong) NSArray * wsList;
@property (nonatomic,strong) SRWebSocket * socket;
@property (nonatomic,strong) NSTimer *heartBeat;
@property (nonatomic,assign) NSTimeInterval reConnectTime;
@property (nonatomic,copy) NSString *urlString;
@property (assign,nonatomic) NSInteger index;
@property (nonatomic,assign) int wsHeartTimes;
@property (nonatomic, assign) BOOL wsConnected;
@property (nonatomic, strong) NSTimer *wsHeartBeat;
@property (nonatomic, assign) BOOL wsSendHeartBeat;
@end
static KKWSTool *_instance;
@implementation KKWSTool
+(instancetype)shareTools
{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance performSelector:@selector(addAllNotification) withObject:nil afterDelay:5];
    });
    return _instance;
}
-(nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _instance;
}

-(nonnull id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return _instance;
}
- (void)addAllNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    self.reConnectTime = 0;
    //开启心跳
//    [self initHeartBeat];
    if (webSocket == self.socket) {
//        NSLog(@"socket连接成功");
        if ([KKDataTool token] != nil) {
            NSDictionary * d = @{@"t":@100,@"u":[KKDataTool token],@"d":@{}};
            [self sendMessage:d];
        }
    }
    _wsConnected=true;
    [self startWSHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (webSocket == self.socket) {
        //        NSLog(@"socket连接失败");
        _socket = nil;
        self.index ++;
        if (self.index >= self.wsList.count) {
            self.index = 0;
        }
        self.urlString = self.wsList[self.index];
        [self reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
//        NSLog(@"socket连接断开 被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
         [self SRWebSocketClose];
         [self reConnect];
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
//    NSLog(@"Pong = %@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
//    NSLog(@"收到的消息：%@,收到的消息类型：%@",message,[message class]);
    NSData * dataStr = message;
    NSString * str = [[NSString alloc] initWithData:dataStr encoding:NSUTF8StringEncoding];
    NSError * error;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error) {
//        NSLog(@"%@",error);
        return;
    }
    _wsHeartTimes=0;
    NSNumber * code = dic[@"t"];
    NSInteger t = code.integerValue;
    NSLog(@"ws消息：%ld",t);
    switch (t) {
        case 298:
        {
            //绑定账号结果
            _wsSendHeartBeat=false;
//            "d" 时间戳
            //
            NSInteger severTime=((NSNumber *)(dic[@"d"][@"t"])).integerValue;
            if (severTime>0) {
                //偏移1 增加服务器时间传递修正
                NSInteger deviation=[KKDataTool nowTimeStamp]-severTime-1;
                if (deviation>5) {
                    [KKDataTool shareTools].timeDeviation=deviation;
                }
            }
            
        }
            break;
        case 201:
        {
            //绑定账号结果
            [[NSNotificationCenter defaultCenter] postNotificationName:kBindAccountResult object:nil userInfo:dic[@"d"]];
        }
            break;
        case 202:
        {
            //匹配成功
            [[NSNotificationCenter defaultCenter] postNotificationName:kGameMatchResultSuccess object:nil userInfo:dic[@"d"]];
        }
            break;
        case 203:
        {
            //匹配失败  自己取消/超时/系统错误 -- 自己/停止当前匹配
            [[NSNotificationCenter defaultCenter] postNotificationName:kGameMatchResultFail object:nil userInfo:dic[@"d"]];
        }
            break;
        case 205:
        {
            //取消匹配
           [[NSNotificationCenter defaultCenter] postNotificationName:kCancelMatch object:nil userInfo:dic[@"d"]];
        }
            break;
        case 206:
        {
            //开始比赛
            [[NSNotificationCenter defaultCenter] postNotificationName:kEnterGame object:nil userInfo:dic[@"d"]];
        }
            break;
        case 207:
        {
            //匹配赛或自建房结果通知
            [KKHintTool showResultHintWithDic:dic[@"d"]];
        }
            break;
         case 208:
        {
            //有人加入房间
            [[NSNotificationCenter defaultCenter] postNotificationName:kJoinRoom object:nil userInfo:dic[@"d"]];
        }
            break;
        case 209:
        {
            //离开房间
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveRoom object:nil userInfo:dic[@"d"]];
        }
            break;
       case 280:
        {
            //充值成功
            [[NSNotificationCenter defaultCenter] postNotificationName:KKRechargeSuccessNotification object:nil];
        }
            break;
        case 299:
        {
            //token失效，退出登录
             [[NSNotificationCenter defaultCenter] postNotificationName:KKLogoutNotification object:nil];
        }
            break;
        case 231:
        {
            //锦标赛要开始了
            [KKHintTool showChampionMatchBegin:dic[@"d"]];
        }
            break;
         case 232:
        {
            //锦标赛结算结束
            [KKHintTool showChampionMatchEnd:dic[@"d"]];
        }
            break;
        default:
            break;
    }
}
//重连机制
- (void)reConnect
{
    [self SRWebSocketClose];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self SRWebSocketOpenWithURLString:self.urlString];
        //        NSLog(@"重连");
    });
    
    //重连时间2的指数级增长
    if (self.reConnectTime == 0) {
        self.reConnectTime = 2;
    }else{
        self.reConnectTime *= 2;
    }
}
-(void)SRWebSocketOpenWithURLString:(NSString *)urlString {
    //如果是同一个url return
    if (self.socket) {
        return;
    }
    if (!urlString) {
        return;
    }
    self.urlString = urlString;
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    //    NSLog(@"请求的websocket地址：%@",self.socket.url.absoluteString);
    
    self.socket.delegate = self;
    [self.socket open];     //开始连接
}

-(void)SRWebSocketClose{
    if (self.socket){
        _wsConnected=false;
        [self.socket close];
        self.socket = nil;
        //断开连接时销毁心跳
        [self destoryHeartBeat];
    }
}
#pragma mark - setter getter
- (SRReadyState)socketReadyState{
    return self.socket.readyState;
}

//发送一条消息
+ (void)sendMessage:(NSDictionary *)message
{
    [[KKWSTool shareTools] sendMessage:message];
    
}
- (void)sendMessage:(NSDictionary *)message
{
    NSLog(@"发送的消息：%@",message);
//    WeakSelf(ws);
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:message options:kNilOptions error:&error];
    if (error) {
//        NSLog(@"消息错误：%@",error);
    } else {
//        NSLog(@"%@",data);
    }
//    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
//    dispatch_async(queue, ^{
        if (self.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (self.socket.readyState == SR_OPEN) {
                [self.socket send:data];    // 发送数据
            } else if (self.socket.readyState == SR_CONNECTING) {
//                NSLog(@"正在连接中");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                [self reConnect];
            } else if (self.socket.readyState == SR_CLOSING || self.socket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                //                NSLog(@"重连");
                [self reConnect];
            }
        } else {
            //            NSLog(@"没网络，发送失败，socket=nil");
        }
//    });
}
//获取服务器地址列表
- (void)getWSList
{
    [KKNetTool getWSListSuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        self.urlString = arr.firstObject;
        self.index = 0;
        self.wsList = arr;
        if (self.urlString) {
            [self SRWebSocketOpenWithURLString:self.urlString];
        }
    } erreorBlock:^(NSError *error) {
    }];
}

//取消心跳
- (void)destoryHeartBeat{
    dispatch_main_async_safe(^{
        if (self.heartBeat) {
            if ([self.heartBeat respondsToSelector:@selector(isValid)]){
                if ([self.heartBeat isValid]){
                    [self.heartBeat invalidate];
                    self.heartBeat = nil;
                }
            }
        }
    })
}
//初始化心跳
- (void)initHeartBeat{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        self.heartBeat = [NSTimer timerWithTimeInterval:54 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
    })
}
//发送ping消息
-(void)sentheart{
    //发送心跳
    [self.socket sendPing:nil];
}

#pragma mark 心跳框架
- (void)startWSHeartBeat
{
    if (!self.wsHeartBeat) {
        _wsHeartTimes=0;
        self.wsHeartBeat = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(sendWSHeartBeat) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.wsHeartBeat forMode:NSRunLoopCommonModes];
    }
    
}
- (void)sendWSHeartBeat
{
    //判断链接状态
    if (_wsSendHeartBeat) {
        _wsSendHeartBeat=false;
        DLOG(@"重新连接");
        [[NSNotificationCenter defaultCenter] postNotificationName:KKViewNeedReloadNotification object:nil];
        [self reConnect];
        return;
    }
    if (_wsHeartTimes>15) {
        if (_wsConnected) {
             _wsHeartTimes=0;
            _wsSendHeartBeat=true;
            [self sendMessage:@{@"t":@199,@"u":([KKDataTool token]?[KKDataTool token]:@""),@"d":@{}}];
        }
        
    }
    else  _wsHeartTimes++;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark notification
- (void)handleDidBecomeActive:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KKViewNeedReloadNotification object:nil];
}
@end
