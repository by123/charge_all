package com.xhd.td.vm.cb.home

import com.xhd.td.model.bean.DeviceInfo


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface AbstractScanQrCB {

    fun handleError(throwable: Throwable?)

    fun activateDeviceSuccess(sn: String){}
    fun activateDeviceFail(msg: String){}

    fun checkMerchantSuccess(){}
    fun checkMerchantFail(msg: String){}

    fun resetSuccess(result:String){}
    fun resetFail(msg: String){}

    fun confirmResetSuccess(result:String){}
    fun confirmResetFail(msg: String){}

    fun taxiActivateDeviceSuccess(sn: String){}
    fun taxiActivateDeviceFail(msg: String){}


    fun unbindDeviceSuccess(result:String){}
    fun unbindDeviceFail(msg: String){}

    fun getDeviceDetailBySnSuccess(deviceInfo: DeviceInfo){}
    fun getDeviceDetailBySnFail(msg: String){}
}