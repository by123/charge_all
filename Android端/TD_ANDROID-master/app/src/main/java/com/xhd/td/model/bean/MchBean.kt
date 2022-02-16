package com.xhd.td.model.bean

import androidx.annotation.NonNull
import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey

/**
 * create by xuexuan
 * time 2019/4/24 16:50
 */

@Entity(tableName = "merchant")
data class MchBean(
    @PrimaryKey
    @NonNull
    var mchId: String, //商户id
    var mchType: Int,  //'0:代理商， 1:普通商户, 2:平台',
    var mchName: String?, //商户姓名
    var name: String?,
    var mobile: String?,
    var level: Int, //代理商业务层级数，我们是0级代理，1：省代, 2:市代, 3：县代，4:连锁门店 不代表物理层级;如果是商户,0:普通商户,1:连锁门店商户',2：出租车,
    var parentAgencyId: String?,  //父节点代理商id
    var locator: String?, //定位符
    var industry: String?, //商户所在行业
    var canWithdrawNum: Int,  //'可提现金额，单位分',
    var freezeNum: Int, //'冻结金额，提现中，单位分',
    var profitPercent: Double,  //'默认父级分润百分比，冗余字段,等于上级的total_percent减去本级total_percent',
    var totalPercent: Double,  //'到当前用户剩余总比例，为负数时，该链条分润比例需要代理商重新设置',
    var latitude: Double?,
    var longitude: Double?,
    var contractTime: String?, //合同结束期
    var province: String?,
    var city: String?,
    var area: String?,
    var detailAddr: String?, //详细地址
    var contactUser: String?, //代理人姓名
    var contactPhone: String?, //代理人电话
    var salesId: String?,//'拓展该代理商的业务员id',
    var salesName: String?,  // '拓展该代理商的业务员姓名',
    var superUser: String?,  //'超级管理员账号，即代理商账号',
    var nextChildLocator: String?,
    var delState: Int,  //置删除位，是否有效，1有效，0无效'
    var supportSevice: Int?,// 是否有出租车的功能
    var createTime: Long?,
    var modifyTime: Long?,

    var settementPeriod: String,
    var deviceTotal: Int,
    var deviceActiveTotal: Int,
    var blockedAmount: Int?,
    var blockedAmountYuan: Double?,

    var mchPriceRule: List<BillingBean>?,
    @Ignore
    var mchLocationLatitude: Double?,//=22.53332

    @Ignore
    var mchLocationLongitude: Double?, //=113.93041
    @Ignore
    var provinceAgentMchName: String?,

    @Ignore
    var cityAgentMchName: String?,

    @Ignore
    var countryAgentMchName: String?,

    @Ignore
    var listAgentMchName: String?,

    //分润比例池
    @Ignore
    var profitPool: Float?,

    //相对分润比例
    @Ignore
    var percentInPool: Float?
    ) {
    @Ignore
    var isSelected: Boolean = false //这个不是服务器返回的字段，是为了方便实现单选，额外添加的

    constructor() : this(
        "", 0, "", "", "", 0, "", "",
        "", 0, 0, 0.0, 0.0, 0.0, 0.0,
        "", "", "", "", "", "", "", "",
        "", "", "", 0, 0, 0, 0,
        "", 0, 0, 0, 0.0,
        null, null, null,null,null,null,null,null,null)
}