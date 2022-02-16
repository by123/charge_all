package com.xhd.td.vm.mine

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
import com.xhd.td.model.bean.MchBean
import com.xhd.td.vm.cb.mine.AgentDetailCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class AgentDetailVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<AgentDetailCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    fun queryDetail(mchID: String) {
        setIsLoading(true)
        dataManager.httpService.queryDetail(mchID)
            .compose<BaseModel<MchBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<MchBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<MchBean>) {
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

}