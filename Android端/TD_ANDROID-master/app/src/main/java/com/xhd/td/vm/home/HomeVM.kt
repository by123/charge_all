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
import com.xhd.td.model.bean.PerformanceDTO
import com.xhd.td.vm.cb.HomeCallback

/**
 * create by xuexuan
 * time 2019/3/18 12:35
 */
class HomeVM(dataManager: DataManager, scheduler: SchedulerProvider) : BaseViewModel<HomeCallback>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()


    fun loadPerformanceData() {
        setIsLoading(true)
        dataManager.httpService.getPerformanceInfo()
            .compose<BaseModel<PerformanceDTO>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<PerformanceDTO>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.handleError(error)
                }

                override fun success(model: BaseModel<PerformanceDTO>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (model.success) {
                        val result = model.data?: return
                        mPerformanceListLiveData.value = listOf(
                            result.todayMchCount,
                            result.todayDeviceCount,
                            result.todayAmount,
                            result.allMchCount,
                            result.allDeviceCount,
                            result.allAmount
                        )
                        mCallback?.getPerformanceSuccess()
                    } else {
                        mCallback?.getPerformanceFail(model.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 这里是获取，可以配置相对分润的代理账号
     */
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

    fun getHasNewMessage():Boolean{
        return dataManager.newMessageTag?:false
    }

    fun setHasNewMessage(b:Boolean){
         dataManager.newMessageTag = b
    }

}