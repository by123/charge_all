package com.xhd.td.vm.cb.home

import com.xhd.td.model.bean.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface TotalCB {

    fun handleError(throwable: Throwable)

    fun getTotalFail(msg: String){}

    fun getTotalSuccess(currentPage:Int, totalPage:Int, total:Int){}

    fun getDirectMchSuccess(list:List<DevMchListBean>){}
    fun getSubordinateMchSuccess(list:List<DevMchListBean>){}
    fun getDevMchTotalSuccess(sum: DevMchSum?){}
    fun getMerchantFail(msg: String){}

    fun getActivateDeviceSuccess(list:List<ActiveDeviceListBean>){}
    fun getActivateDeviceSumSuccess(sum:ActiveDeviceSum?){}


    fun getDeviceRevenueSuccess(list:List<EarningDetailDeveloperBeam>, orderNum:Int,income :String){}



}