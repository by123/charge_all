package com.xhd.td.model.bean


/**
 * create by xuexuan
 * time 2019/5/20 18:43
 */
/**
 * 查询商家或代理商设备统计信息，只查直属的设备
 */
data class DeviceAmount(
    val active: Int, // 0
    val inActive: Int, // 131
    val total: Int // 131
)

/**
 * 解绑商户下面的设备，成功的数量
 */
data class UnbindSuccessAmount(
    val count: Int // 0
)

/**
 * 解绑设备，需要传入这样的参数
 */
data class DeviceSnList(
    val deviceSnLst: List<String>
)


/**
 * 查询设备的详情返回的数据
 */
data class DeviceInfo(
    val deviceDetail: DeviceDetail?, // null
    val deviceMach: List<DeviceMach>?, // null
    val devicePriceCfg: DevicePriceCfg?, // null
    val driverInfo: DriverInfo?, // null
    val profitToTaxi: Double? // //给司机的分润比例(出租车设备才有该字段)
)



data class DriverInfo (
     val carNumber: String? = null,//车牌号码
     val taxiMchId: String? = null, //司机账号
     val driverName: String? = null, //司机姓名
     val driverPhone: String? = null, //司机手机号码
     val lstAssiantDriver: List<Map<String, Any>>? = null //副班司机信息
)


data class DeviceMach (
     val mchId: String? = null,
     val mchType: Int = 0,
     val mchName: String? = null,
     val level: Int = 0,
     val parentAgencyId: String? = null,
     val profitPercent: Double? = null,
     val totalPercent: Double? = null,
     val currentpercent: Double? = null,
     val locator: String? = null,
     val industry: String? = null,
     val superUser: String? = null
)


data class DevicePriceCfg (
     val pledge: Double? = null,// 押金
     val service: String? = null// 服务费为Json格式
)



data class DeviceDetail  (
     val total: Double? = null,// 总金额
     val lastUseTime: Long? = null,// 最后交易时间
     val location: String? = null,
     val wireType: Int? = null ,// 0充电线，1充电器
     val groupName: String? = null, //分组名称

     val deviceSn: String? = null,// 设备sn

     val deviceBatch: String? = null,// 设备批次

     val deviceVersion: String? = null,// 设备硬件型号

     val deviceType: Int = 0,// 设备类型，0充电线

     val mchId: String? = null,// 未激活为所属经销商id，激活后为所属商户id

     val mchLocator: String? = null,// 未激活为所属经销商id，激活后为所属商户id

     val deviceState: Int = 0,// 设备状态，0未投放，1未激活，2激活

     val place: String? = null,// 投放区域

     val salerId: String? = null,// 最后一个级别的业务员id

     val launchTime: Long? = null,// 投放时间

     val activeTime: Long? = null,// 激活时间

     val firstuseTime: Long? = null,// 首次使用时间

     val count: Int = 0,// 使用次数

     val totalAmount: Long = 0,// 总金额

     val delState: Int = 0,// 有效状态，1有效，0无效

     val pwdType: Int? = null, // 密码算法类型

     val pwdCount: Int? = null, // 密码算法计数

     val groupId: String? = null, // 分组ID

     val createTime: Long? = null,//

     val modifyTime: Long? = null//

)
