package com.xhd.td.model.bean

import androidx.annotation.NonNull
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * create by xuexuan
 * time 2019/4/24 16:49
 */
@Entity(tableName = "users")
data class UserBean(
    @PrimaryKey
    @NonNull
    var userId: String,
    var mchId: String, //用户唯一id
    var mchType: Int, //'0:代理商， 1:普通商户, 2:平台
    var password: String,
    var roleType: Int, //类型，0：超级管理员（admin），1:普通管理员 2：代理商业务员，3：商户业务员，4：客服业务员，5：仓库业务员，6：财务业务员
    var name: String?,
    var cretype: Int, //证件类型, 0:身份证, 1:护照, 2:香港身份证, 3:军官证
    var creid: String?, //证件号码
    var mobile: String?, //联系手机
    var delState: Int,   //删除标志，是否有效，1有效，0无效'
    var createTime: String,
    var modifyTime: String
)