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
import com.xhd.td.model.bean.BankListBean
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.vm.cb.mine.CardListCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class CardListVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<CardListCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    /**
     * 查询银行卡列表
     *
     */
    fun getBankListInfo() {
        setIsLoading(true)

        dataManager.httpService.getBankListInfo()
            .compose<BaseModel<BankListBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<BankListBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<BankListBean>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getListSuccess(it) }
                    } else {
                        mCallback?.getListFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


}