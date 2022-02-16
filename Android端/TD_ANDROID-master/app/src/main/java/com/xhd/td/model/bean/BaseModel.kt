package com.xhd.td.model.bean

import cn.xuexuan.mvvm.net.NetModel

/**
 * Created by Administrator on 2017/6/13.
 */
data class BaseModel<T>(
    /**
     * 接口返回状态码
     */
    var status: Int,
    /**
     * 接口返回的提示消息
     */
    var msg: String?,
    /**
     * 接口返回的数据
     */
    var data: T?,
    /**
     * 接口返回的状态标识
     * true -> 成功
     * false -> 失败
     */
    var success: Boolean
) :NetModel{


    override val isNull: Boolean = false
    override val isAuthError: Boolean = false
    override val isBizError: Boolean =  false
    override val errorMsg: String = ""

    override fun toString(): String {
        return "BaseModel{" +
                "code=" + status +
                ", msg='" + msg + '\''.toString() +
                ", data=" + data +
                ", success=" + success +
                '}'.toString()
    }
}
