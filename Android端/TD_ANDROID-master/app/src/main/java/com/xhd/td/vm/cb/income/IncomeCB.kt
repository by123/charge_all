package com.xhd.td.vm.cb.income

import com.xhd.td.model.bean.IncomeBean


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface IncomeCB {

    fun handleError(throwable: Throwable){}


    fun getIncomeOverviewSuccess(income:IncomeBean){}
    fun getIncomeOverviewFail(msg: String){}

}