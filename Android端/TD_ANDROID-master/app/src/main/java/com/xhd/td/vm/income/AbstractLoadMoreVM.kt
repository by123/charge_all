package com.xhd.td.vm.income

import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*
import com.xhd.td.vm.cb.income.AbstractLoadMoreCB

/**
 * create by xuexuan
 * time 2019/4/3 17:40
 */
open class AbstractLoadMoreVM(dataManager: DataManager, scheduler: SchedulerProvider) : BaseViewModel<AbstractLoadMoreCB>(dataManager, scheduler) {


    /**
     * 获取资金明细，这个接口和主页中收益明细中的设备收益是一个接口
     */
    fun getIncomeDetail(startDate: String, endDate: String, pageId: Int, pageSize: Int = 100){
//        避免界面上出现多个进度圈
//        setIsLoading(true)
        dataManager.httpService.getDeviceIncome(startDate, endDate, pageId, pageSize)
            .compose<BaseModel<EarningDetailBeam>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<EarningDetailBeam>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getDataFail()
                }

                override fun success(t: BaseModel<EarningDetailBeam>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.returnDataToView(t.data?.pages?.rows?: arrayListOf())
                        mCallback?.getDataSuccess(
                            t.data?.pages?.pageId ?: 0,
                            t.data?.pages?.pageCount ?: 0,
                            t.data?.pages?.totalCount ?: 0
                        )

                    } else {
                        mCallback?.getDataFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 收益明细 提现明细的数据
     */
    fun getWithDrawList(startDate: String, endDate: String, pageId: Int, pageSize: Int = 100){
//        避免界面上出现多个进度圈
//        setIsLoading(true)
        dataManager.httpService.getWithDrawList(startDate, endDate, pageId, pageSize)
            .compose<BaseModel<WithDrawDetailBeam>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<WithDrawDetailBeam>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getDataFail()

                }

                override fun success(t: BaseModel<WithDrawDetailBeam>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.returnDataToView(t.data?.rows?: arrayListOf())
                        mCallback?.getDataSuccess(
                            t.data?.pageId ?: 0,
                            t.data?.pageCount ?: 0,
                            t.data?.totalCount ?: 0
                        )

                    } else {
                        mCallback?.getDataFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     * 获取收益详情界面中的渠道输入，设备使用两个界面的数据
     */
    fun getChildrenDeviceUsingScenes(date: String, pageId: Int, pageSize: Int = 100){
        setIsLoading(true)
        dataManager.httpService.getChildrenDeviceUsingScenes(date, pageId, pageSize)
            .compose<BaseModel<IncomeTempBeam<IncomeTopBeam>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<IncomeTempBeam<IncomeTopBeam>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getDataFail()

                }

                override fun success(t: BaseModel<IncomeTempBeam<IncomeTopBeam>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.returnDataToView(t.data?.rows?: arrayListOf())
                        mCallback?.getDataSuccess(
                            t.data?.pageId ?: 0,
                            t.data?.pageCount ?: 0,
                            t.data?.totalCount ?: 0
                        )

                    } else {
                        mCallback?.getDataFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}