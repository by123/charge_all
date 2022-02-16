package com.xhd.td.model.bean

/**
 * create by xuexuan
 * time 2019/4/4 18:40
 */

//从服务器获取的城市列表
data class CityBean(val city_name: String, val children: List<CityDetailBean>)
data class CityDetailBean(val city_name: String, val city_code: String)

//从服务器获得银行列表
data class BankCardBean(val node: BankItemBean)
data class BankItemBean(val id: String, val bank_name: String, val bank_code: String)


//本地的城市列表
data class LocalCityBean(
    val children: List<Children>?,
    val label: String, // 澳门特别行政区
    val value: String // 820000
)

data class Children(
    val children: List<ChildrenX>?,
    val label: String, // 阿勒泰地区
    val value: String // 654300
)

data class ChildrenX(
    val label: String, // 吉木乃县
    val value: String // 654326
)


data class BankBeam(val accountName: String, val bankBranch: String, val bankCode: String, val bankId: String
                    , val bankName: String, val cityCode: String, val cityName: String, val isPublic: Int)