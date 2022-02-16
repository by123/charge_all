package com.xhd.td.model.bean

/**
 * create by xuexuan
 * time 2019/4/6 20:08
 */
data class OrderData(val totalCount: Int, val pageCount: Int, val pageSize: Int,
                     val nextPage: Boolean, val pageId: Int, val rows: List<OrderBean>?,
                     val startNum: Int, val order: String, val serviceSumYuan: String
                     , val finishedOrderNum: String, val finishedOrderServiceSumYuan: String
)


data class OrderBean(val orderId: String, // 201904121700000022719414
                     val deviceSn: String, // 6660002000000016
                     val mchId: String, // m2019041200578
                     val mchName: String, // 15986611642
                     val mchLocator: String, // 0.25.0
                     val userId: String, // U626437341
                     val userName: String,// 酱油君
                     val orderPrice: Int, // 100
                     val orderPriceYuan: Float,
                     val depositPrice:  Int, // 0
                     val depositPriceYuan: Float,
                     val descendantsTotalProfit: String,
                     val servicePrice:Int, // 100
                     val servicePriceYuan: Float,
                     val refundMoney: Int, // 0
                     val refundingMoney: Int, // 0
                     val refundMoneyYuan: Float, // 0.00
                     val refundingMoneyYuan: Float,
                     val orderName: String,  // 炭电充电 2小时
                     val payType: Int, // 0
                     val prepayId: String, // wx12174116881528c1e01aa1452416102620
                     val transactionId: String,  // 4200000280201904134223106693
                     val orderState:  Int, // '订单状态，0未支付，1 超时未支付关闭, 2 已支付, 3押金已退, 4 服务费退款, 5 全部服务费退款(废弃), 6 退款中(退款服务费中间状态)' ,
                     val orderStateWeb: Int, //web端 后台数据库 该值与orderState的对应状态 1 0 未支付 2 2 支付成功 3 3 订单完成 4 1 关闭 5 6 退款中 6 4,5 退款
                     val allotState: Int,
                     val orderType:  Int, // 订单类型，-1,全部订单,0:共享充电线租用,1:出租车充电
                     val payTime:Long, // 1555062076000
                     val platformPayTime: Long,
                     val latitude: String,
                     val longitude: String,
                     val timeLevel: Int, // 3
                     val location: String,
                     val profitRule: String,
                     val priceSelected: String,// 0.0元押金/2小时1.0元
                     val buyDuration: Int,
                     val startTime: Long,
                     val endTime: Long,
                     val endMode: String,
                     val actualEndTime: Long,
                     val createTime: Long,
                     val modifyTime: Long,
                     val myProfit: Float,
                     val canRefund: Boolean,
                     val groupId: String, // g2019041200025
                     val groupName: String // 南山龙井片区
                     )



data class OrderQueryBean(val lstMchId: List<String>,
                          val orderState: Int, val  orderType: Int, val payTimeEnd: String, val payTimeStart: String, val pageId: Int?, val pageSize: Int,val lastOrderId:String?)



data class OrderDetailBean(val refundOperatorId: String, val refundOperatorName: String, val refundReason: String, val tblOrder: OrderBean, val orderStateWeb: Int, val orderPriceYuan: Float, val depositPriceYuan: String,
                           val servicePriceYuan: String, val refundMoneyYuan: Float, val refundingMoneyYuan: String, val orderProfit: String,
                           val myProfilt: String, val descendantsTotalProfit: String, val deviceName: String, val deviceSn: String,
                           val deviceLocation: String, val mchName: String, val pledgeRuan: String,
                           val refundMoney: String, val refundId: String, val refundTime: Long, val refundDepositId: String,
                           val refundDepositTime: Long, val refundDepositState: Int, val canRefund: Boolean,
                           val groupName: String // 南山龙井片区
                           )



data class RefundBean(val orderId: String, val reason: String, val refundMoney: Float)
data class RefundReasonBean(val title: String)

