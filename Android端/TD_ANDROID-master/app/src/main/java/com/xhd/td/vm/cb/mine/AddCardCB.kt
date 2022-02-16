package com.xhd.td.vm.cb.mine

import com.xhd.td.model.bean.BankCardBean
import com.xhd.td.model.bean.BankItemBean
import com.xhd.td.model.bean.CityBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface AddCardCB {

    fun handleError(throwable: Throwable)

    fun checkCardSuccess(bean: BankItemBean)
    fun checkCardFail(msg: String)

    fun addCardSuccess()
    fun addCardFail(msg: String)

    fun getCitySuccess(data:List<CityBean>)
    fun getCityFail(msg: String)

    fun getBankSuccess(data:List<BankCardBean>)
    fun getBankFail(msg: String)

}