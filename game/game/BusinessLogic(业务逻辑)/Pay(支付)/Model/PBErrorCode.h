//
//  PBErrorCode.h
//  PayBusSDK
//
//  Created by linsheng on 2018/4/12.
//  Copyright © 2018年 linsheng. All rights reserved.
//

//支付成功
#define PAYBUS_ERROR_NONE 0
//初始化失败
#define PAYBUS_ERROR_INIT 1
//网络失败
#define PAYBUS_ERROR_NETWORK 2
//预订单失败
#define PAYBUS_ERROR_PRE  11
//金额错误
#define PAYBUS_ERROR_AMOUNT 12
//第三方支付失败
#define PAYBUS_ERROR_THIRD_FAIL 101
//第三方支付取消
#define PAYBUS_ERROR_THIRD_CANCEL 102
//唤起第三方支付失败
#define PAYBUS_ERROR_THIRD_AROUSE 103
//第三方支付平台未安装
#define PAYBUS_ERROR_THIRD_INSTALL 104
//查询失败
#define PAYBUS_ERROR_QUERY 201
//查询-交易关闭
#define PAYBUS_ERROR_QUERY_CLOSE 202
//查询-支付失败
#define PAYBUS_ERROR_QUERY_PAY_FAIL 203
