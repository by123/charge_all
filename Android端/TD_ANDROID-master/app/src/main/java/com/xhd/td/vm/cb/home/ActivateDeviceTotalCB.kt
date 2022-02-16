package com.xhd.td.vm.cb.home


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface ActivateDeviceTotalCB {

    fun handleError(throwable: Throwable)

    fun loginFail(msg: String)

    fun loginSuccess(msg: String)

}