package com.xhd.td.vm.cb.map

import com.xhd.td.model.bean.OrderData


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface MapCB {

    fun handleError(throwable: Throwable)

    fun getListSuccess(data: OrderData, viewPageId: Int) {}

    fun getListFail(msg: String?) {}


}