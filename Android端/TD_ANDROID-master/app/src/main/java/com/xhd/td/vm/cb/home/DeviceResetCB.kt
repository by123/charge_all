package com.xhd.td.vm.cb.home


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface DeviceResetCB {

    fun handleError(throwable: Throwable)

    fun resetFail(msg: String)

    fun resetSuccess(msg: String)

}