package com.xhd.td.vm.unbind

import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.model.bean.DeviceAmount
import com.xhd.td.model.bean.UnbindSuccessAmount
import com.xhd.td.vm.cb.unbind.UnbindMerchantDeviceCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class UnbindMerchantDeviceVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<UnbindMerchantDeviceCB>(dataManager, scheduler) {


    fun getTenantDeviceInfo(mchId: String) {
        setIsLoading(true)
        dataManager.httpService.getTenantDeviceInfo(mchId)
            .compose<BaseModel<DeviceAmount>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<DeviceAmount>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<DeviceAmount>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getTenantDeviceInfoSuccess(it) }
                    } else {
                        mCallback?.getTenantDeviceInfoFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    fun unbindByTenantId(mchId: String) {
        setIsLoading(true)
        dataManager.httpService.unbindByTenantId(mchId)
            .compose<BaseModel<UnbindSuccessAmount>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<UnbindSuccessAmount>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)

                }

                override fun success(t: BaseModel<UnbindSuccessAmount>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.unbindByTenantIdSuccess(it) }
                    } else {
                         mCallback?.unbindByTenantIdFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }



}