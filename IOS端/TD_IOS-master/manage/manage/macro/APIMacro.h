//
//  APIMacro.h
//  framework
//
//  Created by 黄成实 on 2018/4/17
//  Copyright © 2018年 黄成实. All rights reserved.
//



#import <Foundation/Foundation.h>

#pragma mark 定义API相关


//记得改info.plist微信appid
#define MSG_VERSION @"炭电v1.0.0(7)"

#ifdef DEBUG

#define ROOT_URL @"https://admin.tandianvip.com/api"
#define DEFAULT_SCAN_URL @"https://admin.tandianvip.com/interface/qr?sn="

#else


#define ROOT_URL @"https://admin.tandianvip.com/api"
#define DEFAULT_SCAN_URL @"https://admin.tandianvip.com/interface/qr?sn="

#endif




//登录
#define URL_LOGIN [ROOT_URL stringByAppendingString:@"/applogin"]
//首页
#define URL_HOME [ROOT_URL stringByAppendingString:@"/manageWeb/app/home"]
//个人信息(废弃)
//#define URL_MYDETAIL [ROOT_URL stringByAppendingString:@"/manageWeb/app/mydetail"]
//银行卡信息
#define URL_BANKINFO [ROOT_URL stringByAppendingString:@"/manageWeb/bank/bankCardList"]
//查询商户(废弃)
#define URL_MCH [ROOT_URL stringByAppendingString:@"/manageWeb/app/mch"]
//添加商户
#define URL_ADD_MCH [ROOT_URL stringByAppendingString:@"/manageWeb/user/addTenant"]
//获取商户默认计费规则
#define URL_DEFALT_PAY_RULE [ROOT_URL stringByAppendingString:@"/manageWeb/user/getDefaultDevicePriceRule"]
//添加代理商
#define URL_ADD_AGENT [ROOT_URL stringByAppendingString:@"/manageWeb/user/addAgent"]
//添加业务员
#define URL_ADD_SALEMAN [ROOT_URL stringByAppendingString:@"/manageWeb/businessUser/createUser"]
//激活设备
#define URL_ACTIVE_DEVICE [ROOT_URL stringByAppendingString:@"/manageWeb/app/active"]
//检测需要绑定的openid是否可用
#define URL_CHECK_OPENID [ROOT_URL stringByAppendingString:@"/manageWeb/app/checkOpenIdOnBindingTenant"]
//绑定商户的微信账户
#define URL_BIND_MERCHANT [ROOT_URL stringByAppendingString:@"/manageWeb/app/bindingTenantWeixinUser"]
//修改密码
#define URL_UPDATE_PSW [ROOT_URL stringByAppendingString:@"/manageWeb/businessUser/modifyPwd"]
//检测更新
#define URL_CHECKUPDATE [ROOT_URL stringByAppendingString:@"/getSoftwareUpdateVersion"]
//产生设备重置码
#define URL_RESET_PSW  [ROOT_URL stringByAppendingString:@"/manageWeb/app/getResetPasswordDeviceCode"]
//确认重置
#define URL_CONFIRM_RESET   [ROOT_URL stringByAppendingString:@"/manageWeb/app/confirmResetDevicePassword"]
//开发商户及激活设备列表
#define URL_HOME_DETAIL  [ROOT_URL stringByAppendingString:@"/manageWeb/app/homedetail"]
//收益列表
#define URL_PROFIT_LIST  [ROOT_URL stringByAppendingString:@"/manageWeb/app/getCashProfitByDate"]
//收益首页
#define URL_CAPITAL_LIST [ROOT_URL stringByAppendingString:@"/manageWeb/mp/home/top"]
//订单列表
#define URL_ORDER_LIST [ROOT_URL stringByAppendingString:@"/manageWeb/order/querylistPost"]
//订单详情
#define URL_ORDER_DETAIL [ROOT_URL stringByAppendingString:@"/manageWeb/order/detail"]
//退款
#define URL_REFUND  [ROOT_URL stringByAppendingString:@"/manageWeb/order/refund"]
//保存银行
#define URL_SAVEBANK [ROOT_URL stringByAppendingString:@"/manageWeb/bank/save"]
//获取提现规则
//#define URL_WITHDRAW_RULE [ROOT_URL stringByAppendingString:@"/manageWeb/bank/getWithdrawRuleByMchTypeAndChannel"]
//#define URL_WITHDRAW_RULE [ROOT_URL stringByAppendingString:@"/manageWeb/bank/getWithdrawRuleByMchType"]

#define URL_WITHDRAW_RULE [ROOT_URL stringByAppendingString:@"/manageWeb/bank/queryWithdrawTax"]
//申请提现
#define URL_WITHDRAW [ROOT_URL stringByAppendingString:@"/manageWeb/bank/requestToWithDraw"]
//提现详情
#define URL_WITHDRAW_DETAIL [ROOT_URL stringByAppendingString:@"/manageWeb/bank/getWithdrawDetail"]
//提现列表
#define URL_WITHDRAW_LIST [ROOT_URL stringByAppendingString:@"/manageWeb/bank/withDrawList"]
//获取配置
#define URL_SPECIAL_SETTING [ROOT_URL stringByAppendingString:@"/getSpecialCfg"]
//获取验证码
#define URL_GET_VERIFYCODE [ROOT_URL stringByAppendingString:@"/resetPasswordForApp"]
//验证验证码
#define URL_CHECK_VERIFYCODE [ROOT_URL stringByAppendingString:@"/checkVerificationCodeWhenChangingPassword"]
//重置密码
#define URL_RESET_PASSWORD [ROOT_URL stringByAppendingString:@"/changingPassword"]
//查询子代理/商户
#define URL_QUERY_AGENT_AND_MERCHANT [ROOT_URL stringByAppendingString:@"/manageWeb/user/queryChildMch"]
//查询所有子代/商户
//#define URL_QUERY_All_AGENT_AND_MERCHANT [ROOT_URL stringByAppendingString:@"/manageWeb/user/blurQuerySubMch"]
#define URL_QUERY_All_AGENT_AND_MERCHANT [ROOT_URL stringByAppendingString:@"/manageWeb/user/querylistPost"]
//代理商详情
#define URL_AGENT_DETAIL [ROOT_URL stringByAppendingString:@"/manageWeb/user/queryDetail"]
//编辑代理商
#define URL_EDIT_AGENT [ROOT_URL stringByAppendingString:@"/manageWeb/user/modAgent"]
//编辑商户
#define URL_EDIT_MERCHANT [ROOT_URL stringByAppendingString:@"/manageWeb/user/modTenant"]
//直属代理修改商户计费规则
#define URL_UPDATE_RULE [ROOT_URL stringByAppendingString:@"/manageWeb/user/changeDefaultPriceRuleOfTenant"]
//自身设备使用情况
#define URL_DEVICEUSING [ROOT_URL stringByAppendingString:@"/manageWeb/user/getDeviceUsingCondition"]
//子代设备使用情况
#define URL_CHILD_DEVICEUSING [ROOT_URL stringByAppendingString:@"/manageWeb/user/getChildrenDeviceUsingCondition"]
//卡bin校验
#define URL_CARDNUM_CHECK [ROOT_URL stringByAppendingString:@"/lianlianCardQuery"]
//添加连锁门店
#define URL_ADD_CHAIN [ROOT_URL stringByAppendingString:@"/manageWeb/user/addChainAgent"]
//添加连锁门店分店
#define URL_ADD_CHILD_CHAIN [ROOT_URL stringByAppendingString:@"/manageWeb/user/addChainTenant"]

//逐级查询子商户和/或子代理，只查询一个层级
#define URL_WHITELIST_QUERY_CHILD [ROOT_URL stringByAppendingString:@"/manageWeb/user/queryGraduallyChildMch"]
//查询白名单记录
#define URL_WHITELIST_RECORD [ROOT_URL stringByAppendingString:@"/manageWeb/app/getOrderWhiteListPage"]
//创建白名单
#define URL_WHITELIST_CREATE [ROOT_URL stringByAppendingString:@"/manageWeb/app/createOrderWhiteList"]
//启用/禁用白名单/编辑白名单
#define URL_WHITELIST_CHANGE_STATU [ROOT_URL stringByAppendingString:@"/manageWeb/app/editOrderWhiteList"]
//查询白名单的使用范围
#define URL_WHITELIST_QUERY_SCOPE [ROOT_URL stringByAppendingString:@"/manageWeb/user/queryWhiteListNodeTree"]
//查询当前商户所有用户
#define URL_ALL_USER [ROOT_URL stringByAppendingString:@"/manageWeb/businessUser/getAllUser"]

/**出租车业务**/
//分组列表
#define URL_GROUP_LIST [ROOT_URL stringByAppendingString:@"/manageWeb/taxi/group/page"]
//添加分组
#define URL_GROUP_ADD  [ROOT_URL stringByAppendingString:@"/manageWeb/taxi/group/add"]
//编辑分组
#define URL_GROUP_EDIT [ROOT_URL stringByAppendingString:@"/manageWeb/taxi/group/mod"]
//查看分组详情
#define URL_GROUP_DETAIL [ROOT_URL stringByAppendingString:@"/manageWeb/taxi/group"]
//将指定设备添加到分组
#define URL_GROUP_ADD_DEVICE [ROOT_URL stringByAppendingString:@"/manageWeb/taxi/device/addToGroupBySnList"]

//绑定微信
#define URL_BIND_WECAHT [ROOT_URL stringByAppendingString:@"/manageWeb/bank/bindWechatBankInfo"]
//行业默认计费规则
#define URL_DEFAULT_RULE [ROOT_URL stringByAppendingString:@"/getIndustryPriceCfg"]

//解绑单个设备
#define URL_UNBIND_DEVICE [ROOT_URL stringByAppendingString:@"/manageWeb/device/unbindDeviceBysnList"]
//解绑一个商户的设备
#define URL_UNBIND_MERCHANT_DEVICE [ROOT_URL stringByAppendingString:@"/manageWeb/device/unbindByTenantId"]
//获取商户设备激活数
#define URL_MERCHANT_DEVICE_TOTAL [ROOT_URL stringByAppendingString:@"/manageWeb/device/getTenantDeviceInfo"]

//获取设备信息
#define URL_DEVICE_INFO [ROOT_URL stringByAppendingString:@"/manageWeb/device/detail"]


//激活设备数列表
#define URL_PERFORMANCE_ACTIVE_LIST [ROOT_URL stringByAppendingString:@"/manageWeb/deviceMgr/report/getAppReport"]
//激活设备数汇总
#define URL_PERFORMANCE_ACTIVE_TOTAL [ROOT_URL stringByAppendingString:@"/manageWeb/deviceMgr/report/getReportSum"]

//直属商户数列表
#define URL_PERFORMANCE_MERCHANT_LIST [ROOT_URL stringByAppendingString:@"/manageWeb/app/directMchList"]
//下级商户数列表
#define URL_PERFORMANCE_MERCHANT_SUBLIST [ROOT_URL stringByAppendingString:@"/manageWeb/app/subordinateMchList"]
//开发数汇总
#define URL_PERFORMANCE_MERCHANT_TOTAL [ROOT_URL stringByAppendingString:@"/manageWeb/app/mchStats"]
//消息列表
#define URL_MSG_LIST [ROOT_URL stringByAppendingString:@"/manageWeb/message/notice/queryNoticeMessageList"]

//消息列表
#define URL_MSG_DETAIL [ROOT_URL stringByAppendingString:@"/manageWeb/message/notice/getNoticeMessageDetail"]


#define URL_BANK @"https://jifung-pub.oss-cn-shenzhen.aliyuncs.com/bankCode.json"
#define URL_CITY @"https://jifung-pub.oss-cn-shenzhen.aliyuncs.com/cityCode.json"

#pragma mark 网络请求码

#define STATU_SUCCESS @"0"
#define STATU_INVALID @"90"
#define STATU_SERVER_EROOR 502

#define URL_SETTING [ROOT_URL stringByAppendingString:@"/appleCheckState"]




//配置表
#define CONFIG_ALL @"all"
#define CONFIG_INDUSTY @"industry_default_price_cfg"

#define CONFIG_ORDER_TIPS @"order_withdraw"
#define CONFIG_BROADCAST @"broadcast"
#define CONFIG_REFUND_REASON @"refund_reason"
#define CONFIG_WHITELIST @"whitelist"
#define CONFIG_TAXI @"taxi_device_config"
#define CONFIG_WITHDRAW_HINT @"withdraw_hint"
#define CONFIG_CAPITAL_HELP @"capital_help"
#define CONFIG_WHITELIST_TIME @"white_list_time_level"
#define CONFIG_WITHDRAW_START @"withdraw_start_num"
#define CONFIG_WITHDRAW_MAX_WX @"wxpay_max_withdraw_money"
#define CONFIG_MIN_PAY @"min_pay"

#define CONFIG_RELATIVE_PERCENT_WHITELIST @"relative_percent_whitelist"
