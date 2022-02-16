package com.xhd.td.model.bean

import java.io.Serializable

/**
 * create by xuexuan
 * time 2019/3/23 18:16
 */

//-----------------------request bean  ------------------------------

data class BillingBean(
    val deviceType: String,
    val pledgeYuan: String,
    val mchId: String,
    val modifyTime: String,
    val createTime: String,
    val service: String,
    val delState: String,
    val pledge: String,
    val serviceType: Int
)


data class PriceBean(var price: String, var time: String)

//添加编辑商户的时候，收费档位的数据
data class GradeBean(val time: String?, val scale: Int?, val price: Float?) : Serializable


data class PreBean(
    val prepaid: Int,
    val maxMoney: Int,
    val minMinutes: Int,
    val minMoney: Double,
    val stepMinutes: Int,
    val price: Double
)


//添加代理、普通商户、连锁总店、添加连锁分店
data class AddMerchantBean(
    val contactPhone: String,
    val contactUser: String,
    val profitSubAgent: Float,
    val mchName: String,
    val industry: String, //行业
    val level: Int = 1, //我们是0级代理，1：省代, 2:市代, 3：县代，4:连锁门店 不代表物理层级;如果是商户,0:普通商户,1:连锁门店商户'
    val pledge: String = "0", //押金
    val service: String = "",
    val serviceType: Int = 1,
    val salesId: String = "", //'拓展该代理商的业务员id',
    val superUser: String = "", //'超级管理员账号，即代理商账号'
    val province: String? = null,
    val city: String? = null,
    val area: String? = null,
    val detailAddr: String? = null,
    val mchParentChainAgentId: String? = null,
    val settementPeriod: String? = null,
    val blockedAmount: Int?,  //冻结金额，以分为单位
//    val relativeRatioFlag:Boolean? = false //是否是相对分润比例

    val profitPool: Float? = null, //(分润池比例)
    val percentInPool: Float? = null //(商户相对分润比例)

)


data class AddSalesmanBean(val mobile: String, val name: String)

data class BindMerchantBean(val openid: String, val unionid: String, val userId: String, val type: String)
//-----------------------response bean  ------------------------------

//添加代理商、连锁总店、普通商户、连锁分店的返回
data class AddResponseBean(val password: String, val SuperUser: String)


//配置表的返回
data class CfgBean(
    val id: String, val cfgKey0: String, val cfgKey1: String
    , val cfgValue: String, val cfgDesc: String, val createTime: String, val modifyTime: String
)


data class PriceListBean(val defaultPriceRule: List<PriceBean>)

data class SalesmanResultBean(val password: String, val userId: String)


data class EarningDetailDeveloperBeam(
    val mchId: String, val salesId: String, val profitOrder: String,
    val profitRefund: String, val profitOrderYuan: String, val profitRefundYuan: String, val profitDate: Long
    , val profitActualIncomeYuan: String, val canWithDrawDate: String
)

data class EarningDetailPageBeam(
    val totalCount: Int,
    val pageCount: Int,
    val pageSize: Int,
    val nextPage: Boolean,
    val pageId: Int,
    val rows: List<EarningDetailDeveloperBeam>,
    val startNum: Int,
    val order: String
)

data class EarningDetailBeam(val profitTotal: String, val pages: EarningDetailPageBeam, val tradeTotal: Int)

//首页，业绩明细中的开发商户数和激活设备数

//激活设备数报表的返回结果
data class ActiveDeviceListBean(
    val activeDeviceTotalNum: Int, // 0 截止查询终止条件，设备激活总数
    val deviceTotalNum: Int, // 0  截止查询终止条件，设备总数
    val activeRatio: Float, // 0 :截止查询终止条件，激活率，上面两个的商*100
    val activeNum: Int, // 0 查询开始和终止条件端内，激活设备总数
    val mchId: String, // m2019061900897
    val mchName: String, // 步步高
    val level: Int, // 1
    val mchType: Int, // 1
    val salesId: String, // m2019052400876
    val salesName: String, // 管理员
    val contactUser: String//=王健林
)


//激活设备总数返回
data class ActiveDeviceSum(val sum: Int)

data class PageBean<T>(
    val nextPage: Boolean, // false
    val order: String, // desc
    val pageCount: Int, // 1
    val pageId: Int, // 1
    val pageSize: Int, // 100
    val rows: List<T>?,
    val startNum: Int, // 0
    val totalCount: Int // 4
)

data class DevMchListBean(
    val accountState: Int, // 0
    val area: String, // null
    val authBit: String, // null
    val blockedAmount: Double, // 0
    val canWithdrawNum: Double, // 0
    val city: Any, // null
    val contactPhone: String, // 15312341239
    val contactUser: String, // 段永平
    val contractTime: Any, // null
    val createTime: Long, // 1560908475000
    val delState: Int, // 1
    val detailAddr: String, // 岗园路49在中科纳能大厦附近
    val deviceCount: Int, // 0
    val freezeNum: Double, // 0
    val industry: String, // 宾馆/经济连锁酒店
    val level: Int, // 0
    val locator: String, // 0.72.3
    val latitude: Double, // null
    val longitude: Double, // null
    val mchId: String, // m2019061900897
    val mchName: String, // 步步高
    val mchType: Int, // 1
    val modifyTime: Long, // 1560908475000
    val nextChildLocator: Int, // 0
    val otherInfo: String, // null
    val parentAgencyId: String, // m2019052400876
    val profitPercent: Double, // 95.00
    val province: String, // null
    val salesId: String, // m2019052400876
    val salesName: String, // 管理员
    val settementPeriod: Int, // 1
    val superUser: String, // m2019061900897
    val supportSevice: String, // null
    val totalPercent: Double, // 5.00
    val waitSettlement: Int, // 0
    val agentCount: Int?, //0,
    val tenantCount: Int? //0
)


data class DevMchSum(
    val directAgent: Int, // 2
    val directTenant: Int, // 2
    val subordinateAgent: Int, // 0
    val subordinateTenant: Int // 2
)


data class QueryAgentMchBean(
    val mchId: String, // string
    val mchLevel: Int? = null, // 0
    val pageId: Int = 1, // 0
    val pageSize: Int = 50, // 0
    val lstMchId: List<String>? = null,
    val contactName: String? = null, // string
    val mchForm: Int? = null, // 1 查询商户
    val mchName: String? = null, // string
    val parentMchid: String? = null, // string
    val salesId: String? = null, // string
    val superUser: String? = null, // string
    val beginDate: Long? = null, // string
    val endDate: Long? = null // string
)
