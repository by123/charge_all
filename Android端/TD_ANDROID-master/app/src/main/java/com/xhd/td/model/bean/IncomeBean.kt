package com.xhd.td.model.bean

/**
 * create by XueXuan
 * time 2019/4/1 22:04
 * description
 */
data class IncomeBean(val freezeNum:String, val total:String, val canWithdrawNum:String, val waitSettlement:String, val todayIncome:String, val balanceAmount:String,val frozenMoney:Double)

data class CardInfoBean(val mchId: String, val mchType: String,
                        val bankId: String, val bankName: String,
                        val bankBranch: String, val cityName: String,
                        val bankCode: String, val accountName: String,
                        val isPublic: Int, val delState: String, val createTime: String, val modifyTime: String)


data class WithDrawDetailBeam(val pageCount: Int, val nextPage: Boolean, val startNum: Int, val pageSize: Int, val sort: String, val pageId: Int, val totalCount: Int
                              , val order: String, val rows: List<WithDrawResultBean>)

data class WithDrawResultBean(val bankCode: String, val mchId: String, val accountName: String, val bankBranch: String,
                              val auxiliaryExpensesYuan: String, val cityCode: String, val infoOrder: String, val channel: String,
                              val tax: Double, val taxYuan: Double, val payExpenses: Double, val payExpensesYuan: Double,
                              val withdrawType: String, val withdrawMoneyYuan: String, val bankName: String, val withdrawMoney: String,
                              val auxiliaryExpenses: String, val bankId: String, val modifyTime: Long,
                              val withdrawMoneyTotal: String, val createTime: Long,
                              val withdrawState: Int, //'订单状态, -3，审核不通过(4状态时，财务审核不通过，变成此状态), -2:挂起,-1:待审核, 0:审核通过，1:提现中, 2:提现成功, 3:提现失败, 4需要人工确认',
                              val withdrawMoneyTotalYuan: String, val isPublic: Int, val withdrawId: String, val failedMsg: String, val alarmCheckMessage: String, val bankOrderid: String)


data class AccountDetailBean(val activeCount: Long, val deviceCount: Long, val user: MchBean?)



//收入明细头部
data class IncomeTopBeam(val orderPercent: String, val orderNum: String, val activeDeviceTotalNum: String, val refundProfitForParentYuan: String, val profitForParentYuan: String,
                         val modifyTime: String, val salesId: String, val statisticsDate: String,
                         val id: String, val profitRefund: String, val deviceUsingPercent: String,
                         val profit: String, val orderServiceNumYuan: String, val profitYuan: String,
                         val profitOrderYuan: String, val mchId: String, val mchName: String,
                         val profitForParent: String, val parentAgencyId: String, val mchType: String,
                         val createTime: String, val usingDeviceNum: String, val orderServiceNum: String,
                         val refundProfitForParent: String, val contactUser: String, val locator: String,
                         val profitOrder: String, val profitRefundYuan: String)

data class IncomeTempBeam<T>(val pageCount: Int, val nextPage: Boolean, val startNum: Int, val pageSize: Int, val sort: String, val pageId: Int, val totalCount: Int
                             , val order: String, val rows: List<T>?)

data class WithdrawBean(
    val bankId: String, // string
    val withdrawMoney: Double // 0.0
)


data class BankCardWithDrawRule(
    val auxiliaryExpenses: Double, // 0
    val auxiliaryExpensesYuan: Double, // 0
    val createTime: Long, // 1557482155000
    val id: Int, // 4
    val mchType: Int, // 0:代理商, 1:普通商户, 不传为全部
    val channel:Int,  // 0 连连渠道, 1:微信渠道
    val modifyTime: Long, // 1557482158000
    val withdrawMaxNum: Double, // 500000
    val withdrawMaxNumYuan: Double, // 5000
    val withdrawStartNum: Double, // 100
    val withdrawStartNumYuan: Double // 1
)



//data class WithDrawRule(
//    val auxiliaryExpenses: Double, // 200
//    val auxiliaryExpensesYuan: Double, // 2
//    val createTime: Long, // 1561969397000
//    val id: Int, // 1
//    val mchType: Int, // 0
//    val modifyTime: Long, // 1561969400000
//    val withdrawStartNum: Double, // 1000
//    val withdrawStartNumYuan: Double // 10
//)



data class WithDrawFee(
    val auxiliaryExpenses: Double, // 0
    val auxiliaryExpensesYuan: Double, // 0
    val lstWithDrawRule: List<WithDrawRule>,
    val needTax: Boolean, // true
    val payExpenses: Double, // 0
    val payExpensesYuan: Double, // 0
    val tax: Double, // 0
    val taxYuan: Double, // 0
    val tipsInfo: String, // string
    val withdrawReal: Double, // 0
    val withdrawRealYuan: Double // 0
)

data class WithDrawRule(
    val auxiliaryExpenses: Double, // 0
    val auxiliaryExpensesYuan: Double, // 0
    val createTime: String, // 2019-11-23T09:08:12.747Z
    val id: Int, // 0
    val mchType: Int, // 0
    val modifyTime: String, // 2019-11-23T09:08:12.747Z
    val withdrawStartNum: Double, // 0
    val withdrawStartNumYuan: Double // 0
)



data class WithdrawAllHintBean(
    val bank: LimitBean,
    val bankHint: List<String>,
    val commonHint: List<String>,
    val wechat: LimitBean,
    val wechatHint: List<String>
)

data class LimitBean(
    val max: Int?, // 单位分 223
    val min: Int? // 单位分 2333
)


