package com.xhd.td.vm.cb.mine

import com.xhd.td.model.bean.MchBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface ManageAgentCB {

    fun handleError(throwable: Throwable)


    fun getMerchantSuccess(data:List<MchBean>)

    fun getMerchantFail(msg: String)


}