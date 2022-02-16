package com.xhd.td.constants


object Constants {

    //商户级别
    val AGENT = 1 //代理
    val PROVINCIAL_AGENT = 2 //省代
    val MUNICIPAL_AGENT = 3 //市代
    val COUNTY_AGENT = 4 // 县代
    val CHAIN_AGENT = 6 //连锁总店

    val MERCHANT = 5  //普通商户
    val CHAIN_STORE = 7 //连锁门店

    val PLATFORM =  0//平台

    //账号类型
    //类型，0：超级管理员（admin），1:普通管理员 2：代理商业务员，
    val ROLY_TYPE_SALESMAN = 8 //业务员
    val ROLY_TYPE_SUPER_ADMIN = 9 //超级管理员
    val ROLY_TYPE_ADMIN = 10 //普通管理员

    var IS_ALREADY_SIGN_OUT = false //是否已经退出登录

    //获取配置的参数
    val CFG_INDUSTRY_TYPE = "industry_type"
    val CFG_CAPITAL_HELP = "capital_help"
    //0是代理商，1是商户
    val CFG_WITHDRAW_ALL_HINT = "withdraw_all_hint"
    val CFG_ORDER_WITHDRAW = "order_withdraw"
    val CFG_REFUND_REASON = "refund_reason"
    val CFG_WHITELIST = "whitelist"
    val CFG_INDUSTRY_DEFAULT_PRICE = "industry_default_price_cfg"
    val CFG_MIN_PAY = "min_pay"

    val CFG_WHITELIST_TIME_LEVEL = "white_list_time_level"
    //起提金额，0是代理商，1是商户
    val CFG_WITHDRAW_START_NUM= "withdraw_start_num"


    val CFG_RELATIVE_PERCENT_WHITELIST= "relative_percent_whitelist"

    val CARD_COMPANY = 1  //注意这里的对公最好是1，与BankBeam中的isPublic 含义保持一致
    val CARD_PERSONAL = 0 // 对私银行卡
    val CARD_WECHAT_PAY = 2 // 微信零钱

    val RESULT_KEY = "result_key"
    val START_PAGE_ID = 1

    val PRODUCT_YELLOW:Byte = 1
    val PRODUCT_RDE:Byte = 2


    val BAI_DU_MAP = "com.baidu.BaiduMap"
    val AMAP = "com.autonavi.minimap"
    val GOOGLE_MAP = "com.google.android.apps.maps"
    val TENCENT_MAP = "com.tencent.map"


    val BAI_DU_MAP_TYPE = "百度地图"
    val AMAP_TYPE = "高德地图"
    val GOOGLE_MAP_TYPE = "谷歌地图"
    val TENCENT_MAP_TYPE = "腾讯地图"

    //app未启动时，点击状态栏消息
    var CLICK_NEW_MESSAGE_ID:Int? = null

    //app是否已经启动
    var APP_ALREADY_OPEN = false

}