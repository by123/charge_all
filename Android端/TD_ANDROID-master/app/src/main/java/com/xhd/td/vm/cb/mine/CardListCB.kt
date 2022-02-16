package com.xhd.td.vm.cb.mine

import com.xhd.td.model.bean.BankListBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface CardListCB {

    fun handleError(throwable: Throwable)

    fun getListSuccess(data: BankListBean) {}

    fun getListFail(msg: String) {}


}