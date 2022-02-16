package com.xhd.td.vm.cb.home

import com.xhd.td.model.bean.SalesmanResultBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface AddSalesmanCB {

    fun handleError(throwable: Throwable)

    fun addSuccess(bean: SalesmanResultBean)
    fun addFail(msg:String?)

}