package com.xhd.td.model.bean

/**
 * create by xuexuan
 * time 2019/4/10 9:45
 */

data class CreateOrderWhiteListBean(
    val mchIds: List<String>?,
    val orderWhiteListId: String?, // string
    val duration: Int,
    val timeLevel:Int,
    val userName: String // string
)

data class WhitelistBean(var mChName:String?, var mchId:String)

data class WhitelistItemBean(
    val nextPage: Boolean, // false
    val order: String, // desc
    val pageCount: Int, // 1
    val pageId: Int, // 1
    val pageSize: Int, // 50
    val rows: List<Row>,
    val startNum: Int, // 0
    val totalCount: Int // 1
)

data class Row(
    val tblOrderWhiteList: TblOrderWhiteList,
    val tblUserOpenid: TblUserOpenid,
    val tblUserUnionid: TblUserUnionid?
)

data class TblUserOpenid(
    val appType: Int, // 0
    val createTime: Long, // 1552644745000
    val delState: Int, // 1
    val modifyTime: Long, // 1552644745000
    val openId: String, // oDS9W44k_u5T-QDeduZyt_Fiejoc
    val unionId: String, // oc2yM1d2MVhXsF0--1EZSCLeN0x4
    val userId: String // U685957391
)

data class TblUserUnionid(
    val city: String, // 吉安
    val country: String, // 中国
    val createTime: Long, // 1552644745000
    val delState: Int, // 1
    val gender: Int, // 1
    val headUrl: String, // https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLrSwX46V1ia1OnMdnRCbukHPu09lyoBh2aS21GyuEZ6IJLk0jssuAibM5yxriastrvf08spalMiatmBw/132
    val modifyTime: Long, // 1552644745000
    val nickname: String, // Monster👹
    val province: String, // 江西
    val unionId: String // oc2yM1d2MVhXsF0--1EZSCLeN0x4
)

data class TblOrderWhiteList(
    val acceptTime: Long, // 1561447590000
    val createTime: Long, // 1561447581000
    val deadLine: Long, // 4070880000000
    val duration: Int, // 120
    val inviterId: String, // m123456
    val modifyTime: Long, // 1561447590000
    val orderWhiteListId: String, // b8ae535a3d8d4614ac002272e7bf7965
    val timeLevel: Int, // 3
    val timesLeft: Int, // 99999
    val userId: String, // U19052800026
    val userName: String, // 测试白名单
    var whiteListState: Int // 白名单状态，0发出邀请，1正常，2暂停
)


//data class EditWhitelistBean(
//    val mchIds: List<String>? = null,
//    val orderWhiteListId: String,
//    val whiteListState: Int? = null
//)

data class EditWhitelistBean(
    val orderWhiteListId: String?, // string
    val userName: String? = null, // string
    val mchIds: List<String>? = null,
    val duration: Int? = null, // 0
    val timeLevel: Int? = null,// 0
    val whiteListState: Int? = null // 0
)


data class WhitelistMerchantBean(
    val accountState: Int, // 0
    val area: String,
    val authBit: Any, // null
    val canWithdrawNum: Int, // 0
    val city: String,
    val contactPhone: String, // 14980852014
    val contactUser: String, // 小9
    val contractTime: Any, // null
    val createTime: Long, // 1552561340000
    val delState: Int, // 1
    val detailAddr: String,
    val freezeNum: Int, // 0
    val industry: String, // 星级酒店
    val latitude: Any, // null
    val level: Int, // 4
    val locator: String, // 0.9.25
    val longitude: Any, // null
    val mchId: String, // m2019031400519
    val mchName: String, // 9天酒店
    val mchType: Int, // 0
    val modifyTime: Long, // 1552961264000
    val nextChildLocator: Int, // 4
    val parentAgencyId: String, // m2018121100095
    val profitPercent: Float, // 10
    val province: String,
    val salesId: String, // 17101011010
    val salesName: String, // 10101011010
    val selected: Int, // 1
    val settementPeriod: Int, // 15
    val superUser: String, // m2019031400519
    val totalPercent: Float, // 80
    val waitSettlement: Int // 0
)


data class WhitelistTimeBean(
    val price: Int, // 0
    val scale: Int, // 8
    val time: Int // 720
)