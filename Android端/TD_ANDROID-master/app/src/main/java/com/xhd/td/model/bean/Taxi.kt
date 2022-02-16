package com.xhd.td.model.bean

/**
 * create by xuexuan
 * time 2019/4/10 22:40
 */

data class TaxiGroupBean(
    var aftersaleArea: String? ,
    var aftersaleCity: String? ,
    var aftersaleProvince: String? ,
    var aftersaleContactName: String? = null,
    var aftersaleContactTel: String,
    var aftersaleDetailAddr: String? = null,
    val createTime: Long? = null, // 1554977301000
    var delState: String? = null,
    var deviceTotal: Int? = null,
    var deviceTotalActive: Int? = null,
    var groupId: String? = null,
    var groupName: String,
    var locator: String? = null,
    var mchId: String?,
    var modifyTime: Long? = null, // 1555053921000
    var orderTotalmoney: Int? = null,
    var orderTotalnum: Int? = null,
    var presaleArea: String?,
    var presaleCity: String?,
    var presaleProvince: String?,
    var presaleContactName: String? = null,
    var presaleContactTel: String,
    var presaleDetailAddr: String? = null,
    var profitPercentTaxi: Float,
    var profitTotalmoney: Int? = null,
    var deposit: Int,
    val salesId: String, // 12365852525
    val salesName: String? = null, // 美美
    val service: String, // [{"price":1.0,"scale":3,"time":"120"}] //"service":"[{\"price\":1,\"scale\":3,\"time\":\"120\"}]"
    var taxiNum: Int? = null
)


data class SalesmanBean(
    val name: String, // 管理员,业务员
    val roleType: Int, // 1:普通管理员 2：代理商业务员，3：商户业务员
    val userId: String // m2018121100095
)



//查询分组列表
data class QueryGroupBean(
    val groupName: String? = null,
    val mchId: String,
    val pageId: Int,
    val pageSize: Int = 100,
    val salesId: String? = null
)


data class Pages<T>(
    val nextPage: Boolean, // false
    val order: String, // desc
    val pageCount: Int, // 1
    val pageId: Int, // 1
    val pageSize: Int, // 12
    val rows: List<T>,
    val startNum: Int, // 0
    val totalCount: Int // 1
)

data class TaxiActivateDevice(
    val groupId: String, // string
    val lstSn: List<String>
)


/**
 * 批量操作设备的参数，或者返回值
 * 目前用在
 * 1、添加设备到出租车分组的
 * 2、设备解绑的时候
 *
 * 他们都是批量操作在web端，所以都是list<BatchOperationDeviceBean>
 * 在app端虽然是单个操作，也是使用这个接口
 */
data class BatchOperationDeviceBean(
    val deviceSn: String, // 6660002000000006
    val errMsg: String, // 设备已激活
    val result: Boolean // false
)
