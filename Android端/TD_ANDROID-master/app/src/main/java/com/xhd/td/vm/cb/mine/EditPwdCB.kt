package com.xhd.td.vm.cb.mine


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface EditPwdCB {

    fun handleError(throwable: Throwable)

    fun modifyFail(msg: String)

    fun modifySuccess(msg: String)

}