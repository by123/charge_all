package com.xhd.td.model.bean

/**
 * create by xuexuan
 * time 2019/4/1 16:24
 */
data class ActiveDeviceBean(val deviceSn: String, val mchId: String)

data class PerformanceBean(val type: String, val count: String)


data class HomeItemBean(val title: String, val imgResourceId: Int,val index:Int)

data class PerformanceDTO(val allDeviceCount: String, val allAmount: String, val todayMchCount: String, val todayDeviceCount: String, val allMchCount: String, val todayAmount: String)


data class IndustryBillingRule(
    val industry: String, // 其他
    val rule: List<Rule>
)

data class Rule(
    val price: Int, // 300
    val scale: Int, // 5
    val time: String // 240
)
//[{"industry":"宾馆/经济连锁酒店","rule":[{"scale":3,"time":"120","price":200},{"scale":6,"time":"360","price":300},{"scale":8,"time":"720","price":500}]},{"industry":"网吧网咖","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300},{"scale":8,"time":"720","price":500}]},{"industry":"足疗按摩","rule":[{"scale":3,"time":"120","price":300},{"scale":5,"time":"240","price":400},{"scale":8,"time":"720","price":500}]},{"industry":"洗浴/会所","rule":[{"scale":3,"time":"120","price":300},{"scale":5,"time":"240","price":400},{"scale":8,"time":"720","price":500}]},{"industry":"星级酒店","rule":[{"scale":3,"time":"120","price":200},{"scale":6,"time":"360","price":300},{"scale":8,"time":"720","price":500}]},{"industry":"中餐/茶馆","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"酒吧/KTV","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"美容行业","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"棋牌室","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"电影院","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"西餐咖啡厅","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"培训机构","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"医院","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]},{"industry":"其他","rule":[{"scale":3,"time":"120","price":200},{"scale":5,"time":"240","price":300}]}]




data class GrayscaleUpdateUsers(
    val users: List<String>
)

data class MinPay(
    val money:Int
)