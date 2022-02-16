//
//  EnumMacro.h
//  framework
//
//  Created by by.huang on 2018/5/23.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PAGESIZE 10

typedef NS_ENUM(NSInteger,AchieveType){
    Achieve_Merchant = 0,
    Achieve_Device,
    Achieve_Profit
};


typedef NS_ENUM(NSInteger,CapitalType){
    CapitalType_Profit = 0,
    CapitalType_Withdraw
};

typedef NS_ENUM(NSInteger,CapitalDetailType){
    CapitalDetailType_Profit = 0,
    CapitalDetailType_Device,
    CapitalDetailType_All

};

//支付状态(订单状态，1 未支付，2 已支付 3 已完成, 4已取消, 5 退款中, 6已退款
typedef NS_ENUM(NSInteger, OrderType){
    OrderType_All = 0,
    OrderType_WaitPay = 1,
    OrderType_Paid = 2,
    OrderType_Completed = 3,
    OrderType_Cancel = 4,
    OrderType_Refunding = 5,
    OrderType_Refunded = 6,

} ;

//搜索选择（0 按商户 1 按订单 2 按设备）
typedef NS_ENUM(NSInteger,SearchType){
    SearchType_Merchant = 0,
    SearchType_Order = 1,
    SearchType_Device = 2,
};


//白名单选择
typedef NS_ENUM (NSInteger,WhiteListSelectStatu){
    WHITELIST_SELECT_NONE = 0,
    WHITELIST_SELECT_ALL = 1,
    WHITELIST_SELECT_HALF = 2,

};

//皮肤选择
typedef NS_ENUM(NSInteger, SKinType){
    SkinType_Yellow = 0,
    SkinType_Red
};

//白名单跳转
#define WHITELIST_FROM_EDIT 0
#define WHITELIST_FROM_CREATE 1

//扫码类型
typedef NS_ENUM(NSInteger,ScanType){
    ScanType_ACTIVE_DEVICE = 0,
    ScanType_BIND_MERCHANT,
    ScanType_RESET_PSW,
    ScanType_BIND_GROUP,
    ScanType_UNBIND_DEVICE
};

//提现类型
typedef NS_ENUM(NSInteger, WithDrawType) {
    WithDrawType_Agent = 0,
    WithDrawType_Merchant,
    WithDrawType_Wechat,
    WithDrawType_Other
};

//激活设备，解绑设备
typedef NS_ENUM(NSInteger,DeviceActiveType){
    DeviceActiveType_Active = 0,
    DeviceActiveType_UnBind
};

//
typedef NS_ENUM(NSInteger,PerformanceType){
    PerformanceType_Active = 0,
    PerformanceType_Merchant,
    PerformanceType_Archive
};

//
typedef NS_ENUM(NSInteger,WhiteListType){
    WhiteListType_Create = 0,
    WhiteListType_Edit,
};

typedef NS_ENUM(NSInteger,MerchantFromType){
    MerchantFromType_BIND = 0,
    MerchantFromType_ACTIVE,
    MerchantFromType_UNBIND
};


//绑定银行卡入口
#define BIND_FROM_WITHDRAW 0
#define BIND_FROM_BANKINFO 1
#define BIND_FROM_WITHDRAW_BANKINFO 2
