package com.xhd.td.vm.home

import androidx.lifecycle.MutableLiveData
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.model.bean.CfgBean
import com.xhd.td.model.bean.PriceBean
import com.xhd.td.vm.cb.AbstractMerchantCallback

/**
 * create by xuexuan
 * time 2019/3/23 11:27
 */

open class AbstractMerchantVM(dataManager: DataManager, scheduler: SchedulerProvider) : BaseViewModel<AbstractMerchantCallback>(dataManager, scheduler) {

    open var mBillingRuleLiveData: MutableLiveData<List<PriceBean>> = MutableLiveData()

    fun getConfig(key:String){
        setIsLoading(true)

        dataManager.httpService.getCfg(key)
            .compose<BaseModel<CfgBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<CfgBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<CfgBean>) {
                    setIsLoading(false)

//                    业务的成功与否
                    if (t.success) {
                        mCallback?.getConfigSuccess(key,t.data?.cfgValue)
                    } else {
                        mCallback?.getConfigFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }
}