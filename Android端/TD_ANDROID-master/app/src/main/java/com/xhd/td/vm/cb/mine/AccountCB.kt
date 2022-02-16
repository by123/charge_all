package com.xhd.td.vm.cb.mine

import com.xhd.td.model.bean.AccountDetailBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface AccountCB {

    fun handleError(throwable: Throwable)

    fun getMyDetailSuccess(account: AccountDetailBean)
    fun getMyDetailFail(msg: String)

}