package com.xhd.td.vm.home

import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*
import com.xhd.td.vm.cb.home.TotalCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
open class TotalVM(dataManager: DataManager, scheduler: SchedulerProvider) : BaseViewModel<TotalCB>(dataManager, scheduler) {

    /**
     *
     * 获取激活设备数报表
     */
    fun getActiveDeviceReport(
        startDate: String,
        endDate: String,
        mchId: String? = null,
        keyword: String? = null,
        pageId: Int,
        pageSize: Int = 100
    ) {
        setIsLoading(true)

        dataManager.httpService.getActiveDeviceReport(startDate, endDate, pageId, pageSize, mchId, keyword)
            .compose<BaseModel<PageBean<ActiveDeviceListBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<PageBean<ActiveDeviceListBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<PageBean<ActiveDeviceListBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {

                        mCallback?.getTotalSuccess(
                            t.data?.pageId ?: 0,
                            t.data?.pageCount ?: 0,
                            t.data?.totalCount ?: 0)
                        mCallback?.getActivateDeviceSuccess(t.data?.rows ?: arrayListOf())
                    } else {
                        mCallback?.getTotalFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     *
     * 获取激活设备数报表
     */
    fun getActiveDeviceSum(
        startDate: String,
        endDate: String,
        mchId: String? = null,
        keyword: String? = null) {

        setIsLoading(true)
        dataManager.httpService.getActiveDeviceSum(startDate, endDate, mchId, keyword)
            .compose<BaseModel<ActiveDeviceSum>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)

            .subscribeWith(object : ApiSubscriber<BaseModel<ActiveDeviceSum>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<ActiveDeviceSum>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.getActivateDeviceSumSuccess(t.data)
                    } else {
                        mCallback?.getTotalFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }





    /**
     *
     * 获取直属开发商户数
     */
    fun getDirectMchList(
        startDate: String,
        endDate: String,
        mchId: String? = null,
        keyword: String? = null,
        pageId: Int,
        pageSize: Int = 100
    ) {
        setIsLoading(true)

        dataManager.httpService.getDirectMchList(startDate, endDate, pageId, pageSize, mchId, keyword)
            .compose<BaseModel<PageBean<DevMchListBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<PageBean<DevMchListBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<PageBean<DevMchListBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {

                        mCallback?.getTotalSuccess(
                            t.data?.pageId ?: 0,
                            t.data?.pageCount ?: 0,
                            t.data?.totalCount ?: 0)
                        mCallback?.getDirectMchSuccess(t.data?.rows ?: arrayListOf())
                    } else {
                        mCallback?.getTotalFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     *
     * 首页业绩明细的设备收益列表
     * 收益界面的收益明细列表
     */
    fun getDeviceIncome(startDate: String, endDate: String, pageId: Int, pageSize: Int = 100) {
        setIsLoading(true)

        dataManager.httpService.getDeviceIncome(startDate, endDate, pageId, pageSize)
            .compose<BaseModel<EarningDetailBeam>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<EarningDetailBeam>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<EarningDetailBeam>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.getDeviceRevenueSuccess(t.data?.pages?.rows?: arrayListOf(),t.data?.tradeTotal?:0,t.data?.profitTotal?:"0")
                        mCallback?.getTotalSuccess(
                            t.data?.pages?.pageId ?: 0,
                            t.data?.pages?.pageCount ?: 0,
                            t.data?.pages?.totalCount ?: 0
                        )

                    } else {
                        mCallback?.getTotalFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     *
     * 获取下级开发商户数
     */
    fun getSubordinateMchList(
        startDate: String,
        endDate: String,
        mchId: String? = null,
        keyword: String? = null,
        pageId: Int,
        pageSize: Int = 100
    ) {
        setIsLoading(true)

        dataManager.httpService.getSubordinateMchList(startDate, endDate, pageId, pageSize, mchId, keyword)
            .compose<BaseModel<PageBean<DevMchListBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<PageBean<DevMchListBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<PageBean<DevMchListBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {

                        mCallback?.getTotalSuccess(
                            t.data?.pageId ?: 0,
                            t.data?.pageCount ?: 0,
                            t.data?.totalCount ?: 0)
                        mCallback?.getSubordinateMchSuccess(t.data?.rows ?: arrayListOf())
                    } else {
                        mCallback?.getTotalFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     *
     * 获取开发商户数统计
     */
    fun getDevMchTotal(
        startDate: String,
        endDate: String,
        mchId: String? = null) {

        setIsLoading(true)
        dataManager.httpService.getDevMchTotal(startDate, endDate, mchId)
            .compose<BaseModel<DevMchSum>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)

            .subscribeWith(object : ApiSubscriber<BaseModel<DevMchSum>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<DevMchSum>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.getDevMchTotalSuccess(t.data)
                    } else {
                        mCallback?.getTotalFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}