package com.xhd.td.vm.map

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
import com.xhd.td.model.bean.OrderData
import com.xhd.td.vm.cb.map.MapCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class MapVM(dataManager: DataManager, scheduler: SchedulerProvider) : BaseViewModel<MapCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    /**
     * 根据查询类型和查询关键字，
     *
     */
    fun getListByKey(type: Int = -1, pageId: Int) {
        setIsLoading(true)

        dataManager.httpService.queryOrderListByKey(orderId = "1", pageId = pageId)
            .compose<BaseModel<OrderData>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<OrderData>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<OrderData>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getListSuccess(it, -1) }
                    } else {
                        mCallback?.getListFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


}