package com.xhd.td.vm.cb.taxi

import com.xhd.td.model.bean.Pages
import com.xhd.td.model.bean.SalesmanBean
import com.xhd.td.model.bean.TaxiGroupBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface TaxiGroupCB {

    fun handleError(throwable: Throwable)

    fun createGroupFail(msg: String){}
    fun createGroupSuccess(groupId: String,groupName: String){}

    fun getSalesmanSuccess(pages: List<SalesmanBean>){}
    fun getSalesmanFail(msg: String){}


    fun queryGroupSuccess(pages: Pages<TaxiGroupBean>){}
    fun queryGroupFail(msg: String){}

}