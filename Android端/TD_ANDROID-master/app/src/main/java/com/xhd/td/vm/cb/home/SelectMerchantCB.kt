package com.xhd.td.vm.cb.home

import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.PageBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface SelectMerchantCB {

    fun handleError(throwable: Throwable)

    fun getAgentAndMerchantSuccess(data:PageBean<MchBean>)
    fun getAgentAndMerchantFail(msg: String? = null)

    fun bindMerchantSuccess(){}
    fun bindMerchantFail(msg: String){}

}