package com.xhd.td.vm.home

import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*

/**
 * create by xuexuan
 * time 2019/4/2 10:55
 *
 * 该类用于扫码界面的，每个扫码界面的数据操作，都在这个vm中
 *
 */
class ScanVM(dataManager: DataManager, scheduler: SchedulerProvider) : AbstractScanQrVM(dataManager, scheduler) {


    /**
     * 绑定商户
     * 检测商户是否被绑定
     */
    fun checkTenant(openId: String, type: String) {
        setIsLoading(true)

        dataManager.httpService.checkTenant(openId, type)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error?.exception)
                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.checkMerchantSuccess()
                    } else {
                        mCallback?.checkMerchantFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 激活设备
     * 扫码后，去激活设备
     */
    fun activateDevice(deviceSn: String, mchId: String) {
        setIsLoading(true)

        dataManager.httpService.activeDev(ActiveDeviceBean(deviceSn, mchId))
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error?.exception)

                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.activateDeviceSuccess(deviceSn)
                    } else {
                        mCallback?.activateDeviceFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 出租车激活设备
     * 扫码后，去激活设备
     */
    fun taxiActivateDevice(groupId: String, deviceSn: String) {
        setIsLoading(true)

        dataManager.httpService.taxiActiveDev(TaxiActivateDevice(groupId, arrayListOf(deviceSn)))
            .compose<BaseModel<List<BatchOperationDeviceBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<List<BatchOperationDeviceBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error?.exception)

                }

                override fun success(t: BaseModel<List<BatchOperationDeviceBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        if (t.data?.get(0)?.result == true) {
                            mCallback?.taxiActivateDeviceSuccess(deviceSn)
                        } else {
                            mCallback?.taxiActivateDeviceFail(t.data?.get(0)?.errMsg.toString())
                        }
                    } else {
                        mCallback?.taxiActivateDeviceFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 设备密码重置
     * 扫码后，获取到
     */
    fun deviceReset(deviceSn: String) {
        setIsLoading(true)

        dataManager.httpService.getResetCode(deviceSn)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error?.exception)
                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.resetSuccess(t.data.toString())
                    } else {
                        mCallback?.resetFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 扫码后，页面跳转了，设备重置密码，之所以把这个函数放在这里，是为了统一
     */
    fun confirmReset(deviceSn: String) {
        setIsLoading(true)

        dataManager.httpService.confirmReset(deviceSn)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error?.exception)
                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.confirmResetSuccess(deviceSn)
                    } else {
                        mCallback?.confirmResetFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 根据设备的sn号，获取设备的商户信息，用于显示在扫码成功后的界面
     */
    fun getDeviceDetailBySn(deviceSn: String) {
        setIsLoading(true)

        dataManager.httpService.getDeviceDetailBySn(deviceSn)
            .compose<BaseModel<DeviceInfo>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<DeviceInfo>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error?.exception)
                }

                override fun success(t: BaseModel<DeviceInfo>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getDeviceDetailBySnSuccess(it) }
                    } else {
                        mCallback?.getDeviceDetailBySnFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 扫码解绑设备
     */
    fun unbindDeviceBysnList(deviceSn: String) {
        setIsLoading(true)

        dataManager.httpService.unbindDeviceBysnList(DeviceSnList(listOf(deviceSn)))
            .compose<BaseModel<List<BatchOperationDeviceBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<List<BatchOperationDeviceBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error?.exception)
                }

                override fun success(t: BaseModel<List<BatchOperationDeviceBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.data?.get(0) != null) {

                        if (t.data?.get(0)?.result == true) {
                            mCallback?.unbindDeviceSuccess(deviceSn)
                        } else {
                            mCallback?.unbindDeviceFail(t.data?.get(0)?.errMsg.toString())
                        }
                    }
                }
            })
            .addTo(compositeDisposable)
    }


}