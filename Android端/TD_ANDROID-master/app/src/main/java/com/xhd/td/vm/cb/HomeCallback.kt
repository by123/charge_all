package com.xhd.td.vm.cb

/**
 * create by xuexuan
 * time 2019/3/26 15:54
 */
interface HomeCallback{

    fun handleError(throwable: Throwable?)

    fun getPerformanceFail(msg:String?)
    fun getPerformanceSuccess()

    fun getConfigSuccess(key:String,data: String?){}
    fun getConfigFail(msg:String?){}
}