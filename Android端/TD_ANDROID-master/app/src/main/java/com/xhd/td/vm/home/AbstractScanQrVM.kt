package com.xhd.td.vm.home

import androidx.lifecycle.MutableLiveData
import cn.xuexuan.mvvm.net.SchedulerProvider
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.vm.cb.home.AbstractScanQrCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
open class AbstractScanQrVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<AbstractScanQrCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

//    fun confirm(name: String, pwd: String) {
//        setIsLoading(true)
//        var loginBean = LoginBean(name, pwd)
//        dataManager.httpService.confirm(loginBean)
//            .compose<BaseModel<LoginResultBean>>(XNet.getSingleTransformer())
//            .performOnBackOutOnMain(scheduler)
//            .doAfterSuccess { }
//            .subscribeWith(object : ApiSubscriber<BaseModel<LoginResultBean>>() {
//                override fun onFail(error: NetError?) {
//                    //网络方面的错误
//                    setIsLoading(false)
//                }
//
//                override fun success(t: BaseModel<LoginResultBean>) {
//                    setIsLoading(false)
//                    //业务的成功与否
//                    if (t.success) {
//                        mCallback.resetSuccess(t.msg.toString())
//                    } else {
//                        mCallback.resetFail(t.msg.toString())
//                    }
//                }
//            })
//            .addTo(compositeDisposable)
//    }


}