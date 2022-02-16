package com.xhd.td.vm.cb.mine


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface CardDetailCB {

    fun handleError(throwable: Throwable)

    fun loginFail(msg: String)

    fun loginSuccess(msg: String)

}