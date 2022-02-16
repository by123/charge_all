package com.xhd.td.vm.cb.mine

import com.xhd.td.model.bean.MchBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface AgentDetailCB {

    fun handleError(throwable: Throwable)

    fun getAgentAndMerchantFail(msg: String)

    fun getAgentAndMerchantSuccess(bean: MchBean)

}