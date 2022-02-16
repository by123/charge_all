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
import com.xhd.td.vm.cb.home.SelectMerchantCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class SelectMerchantVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<SelectMerchantCB>(dataManager, scheduler) {


    //模糊查找，如果不传入keyword，则查找全部，获取商户和连锁门店
    fun getAgentAndMerchant(queryAgentMch: QueryAgentMchBean) {
        setIsLoading(true)
        dataManager.httpService.querylistPost(queryAgentMch)
            .compose<BaseModel<PageBean<MchBean>?>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<PageBean<MchBean>?>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getAgentAndMerchantFail()
                }

                override fun success(t: BaseModel<PageBean<MchBean>?>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getAgentAndMerchantSuccess(it) }
                    } else {
                        mCallback?.getAgentAndMerchantFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    fun bindTenant(bind:BindMerchantBean) {
        setIsLoading(true)
        dataManager.httpService.bindTenant(bind)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.bindMerchantSuccess()
                    } else {
                        mCallback?.bindMerchantFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }




}