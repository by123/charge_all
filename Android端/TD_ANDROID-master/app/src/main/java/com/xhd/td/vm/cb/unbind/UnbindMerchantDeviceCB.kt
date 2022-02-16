package com.xhd.td.vm.cb.unbind

import com.xhd.td.model.bean.DeviceAmount
import com.xhd.td.model.bean.UnbindSuccessAmount


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface UnbindMerchantDeviceCB {

    fun handleError(throwable: Throwable)

    fun getTenantDeviceInfoFail(msg: String? = null)

    fun getTenantDeviceInfoSuccess(deviceAmount: DeviceAmount)


    fun unbindByTenantIdFail(msg: String?)

    fun unbindByTenantIdSuccess(unbindSuccessAmount: UnbindSuccessAmount)

}