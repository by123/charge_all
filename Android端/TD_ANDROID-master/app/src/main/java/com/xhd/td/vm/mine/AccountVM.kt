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
import com.xhd.td.model.bean.AccountDetailBean
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.vm.cb.mine.AccountCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class AccountVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<AccountCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    /**
     * 获取用户的详细信息
     */
    fun getMyDetail() {
        setIsLoading(true)
        dataManager.httpService.getMyDetail()
            .compose<BaseModel<AccountDetailBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<AccountDetailBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<AccountDetailBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getMyDetailSuccess(it)}
                    } else {
                        mCallback?.getMyDetailFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}