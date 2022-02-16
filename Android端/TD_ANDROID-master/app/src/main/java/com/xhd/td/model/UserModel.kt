package com.xhd.td.model

import android.util.Log
import com.tencent.bugly.Bugly
import com.xhd.td.ApplicationLike
import com.xhd.td.constants.Constants
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.UserBean
import com.xhd.td.utils.gradeNameForMchTypeAndLevel

/**
 * create by xuexuan
 * time 2018/7/4 17:49
 */
object UserModel {

    var mchBean: MchBean? = null
    var userBean: UserBean? = null
    var incomeVisible = true //是否能显示收益界面

    //账号角色，userBean的roleType字段，//类型，0：超级管理员（admin），1:普通管理员 2：代理商业务员，3：商户业务员，4：客服业务员，5：仓库业务员，6：财务业务员
    //                0-> Constants.ROLY_TYPE_SUPER_ADMIN
    //                1-> Constants.ROLY_TYPE_ADMIN
    //                2-> Constants.ROLY_TYPE_SALESMAN
    var roleType = 1

    //账号类型，省代，市代，县代，连锁总店，商铺，连锁分店，业务员,这个字段是根据mchInfo中的mchType和level来进行赋值的
    var type = Constants.PROVINCIAL_AGENT
    var typeName = "未知"

    var whitelist = listOf<String>()

    var grayscaleUpdate:Boolean? = null
    var relativePercentWhitelist:Boolean = false

    var hasTaxi = false

    var TOKEN: String? = null

    fun initModel(userBean: UserBean, mchBean: MchBean, token: String) {
        //保存账号类型，
        UserModel.TOKEN = token
        UserModel.userBean = userBean
        UserModel.mchBean = mchBean
        UserModel.typeName = gradeNameForMchTypeAndLevel(UserModel.mchBean?.mchType, UserModel.mchBean?.level)
        UserModel.type = when (UserModel.mchBean?.mchType) {
            0 -> when (UserModel.mchBean?.level) {
                1 -> Constants.PROVINCIAL_AGENT
                2 -> Constants.MUNICIPAL_AGENT
                3 -> Constants.COUNTY_AGENT
                4 -> Constants.CHAIN_AGENT
                else -> Constants.AGENT
            }
            1 -> when (UserModel.mchBean?.level) {
                0 -> Constants.MERCHANT
                1 -> Constants.CHAIN_STORE
                else -> Constants.MERCHANT

            }
            else -> Constants.PLATFORM
        }


        //只有代理可以有出租车的选项
        UserModel.hasTaxi = when (UserModel.mchBean?.mchType) {
            0 -> when (UserModel.mchBean?.level) {
                1, 2, 3 -> true
                4 -> false
                else -> false
            }
            1 -> false
            2 -> true
            else -> false
        }
        UserModel.roleType = when (UserModel.userBean?.roleType) {
            0 -> Constants.ROLY_TYPE_SUPER_ADMIN
            1 -> Constants.ROLY_TYPE_ADMIN
            2, 3 -> Constants.ROLY_TYPE_SALESMAN

            else -> Constants.ROLY_TYPE_SALESMAN
        }

        UserModel.incomeVisible =
            UserModel.roleType == Constants.ROLY_TYPE_ADMIN || UserModel.roleType == Constants.ROLY_TYPE_SUPER_ADMIN

        Bugly.setUserId(ApplicationLike.instance, userBean.userId)

        Log.i(toString(),"数据保存完成")

    }

}