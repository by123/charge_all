package com.xhd.td.vm.cb.whitelist

import com.xhd.td.model.bean.OrderData


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface WhitelistRecordCB {

    fun handleError(throwable: Throwable)

    fun getListSuccess(data: OrderData, viewPageId: Int) {}

    fun getListFail(msg: String) {}


}