package com.xhd.td.vm.income

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
import com.xhd.td.model.bean.IncomeBean
import com.xhd.td.vm.cb.income.IncomeCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class IncomeVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<IncomeCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()


    var incomeBean:MutableLiveData<IncomeBean> = MutableLiveData()

    fun getIncomeOverview() {
        setIsLoading(true)
        dataManager.httpService.getTop()
            .compose<BaseModel<IncomeBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<IncomeBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<IncomeBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { incomeBean.value = it;mCallback?.getIncomeOverviewSuccess(it) }

                    } else {
                        mCallback?.getIncomeOverviewFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }




}