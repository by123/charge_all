package com.xhd.td.vm.cb.income

import com.xhd.td.model.bean.IncomeTempBeam
import com.xhd.td.model.bean.IncomeTopBeam
import com.xhd.td.model.bean.AccountDetailBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface IncomeDetailCB {

    fun handleError(throwable: Throwable)


    fun getMyDetailSuccess(merchant:AccountDetailBean)
    fun getMyDetailFail(msg: String)


    fun getIncomeConditionSuccess()
    fun getIncomeConditionFail(msg: String)


    fun getIncomeDetailSuccess(bean: IncomeTempBeam<IncomeTopBeam>)
    fun getIncomeDetailFail(msg: String)


}