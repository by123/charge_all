package cn.xuexuan.mvvm.net

/**
 * Created by xuexuan on 2016/12/26.
 */

interface NetModel {
    val isNull: Boolean       //空数据

    val isAuthError: Boolean  //验证错误

    val isBizError: Boolean   //业务错误

    val errorMsg: String   //后台返回的错误信息
}
