package com.xhd.td.model.bean

/**
 * create by xuexuan
 * time 2019/4/8 17:22
 */

data class ModifyBean(val oldPwd: String, val submitPwd: String,val conformPwd: String,  val needCheck: Int = 0)
data class  VersionBeam(val id:String,val softwareType:String,val downloadUrl:String,val version:String,val versionNum:String,
                        val recommend:Int,val versionDesc:String,val createTime:
                        String,val modifyTime:String,val versionSize:String)


data class ServiceBean(val time: String, val price: String, val scale: String)

data class EditBeam(val mchId: String,
                    val mchName: String?,
                    val contactUser: String?,
                    val contactPhone: String?,
                    val profitSubAgent: Float?,
                    val industry: String? = null,
                    val blockedAmount:Int?,
                    val province: String?,
                    val city: String?,
                    val area: String?,
                    val detailAddr: String?,

                    val bclearRelativeFlag:Boolean? = false, //true，显示绝对，清空相对比例两个字段，商户显示绝对比例 profitPool，percentInPool
                    var profitPool: Float? = null, //分润比例池
                    var percentInPool: Float? = null//相对分润比例
                    )


data class ChangeRuleBeam(val pledgeYuan: Float, val service: String, val tenantId: String, val serviceType: Int)




data class BankListBean(
    val banks: List<Bank>,
    val tblUserUnionid: TblUserUnionid?
)

data class Bank(
    val accountName: String, // 天下大同
    val bankBranch: String,
    val bankCode: String, // 5
    val bankId: String, // opLDq5oD5w3KmB79v90DkNgtrwp4
    val bankName: String, // 微信零钱
    val cityCode: String,
    val cityName: String,
    val createTime: Long, // 1556528426000
    val delState: Int, // 1
    val id: String, // 52
    val isPublic: Int, // 0
    val mchId: String, // m2018121100095
    val mchType: Int, // 0
    val modifyTime: Long // 1556528426000
)


data class MessageBean(
    val brief: String, // string
    val content: String, // 内容
    val createTime: Long, // 1563527866000
    val delState: Int, // 1
    val id: Int, // 26
    val mchType: Int, // 0
    val modifyTime: Long, // 1563527882000
    val msgHash: String, // umenga4195ce796614a448e1c2d8e2302a422
    val noticeState: Int, // 1
    val publishTime: Long, // 1563527852000
    val title: String // title
)


data class MessageContentBean(
    val content: String, // 小程序可以通过微信官方提供的登录能力方便地获取微信提供的用户身份标识，快速建立小程序内的用户体系。
    //图片->img, 文本-> text
    val type: String // text
)