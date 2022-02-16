package com.xhd.td.vm.home

import androidx.databinding.ObservableField
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.AddSalesmanBean
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.model.bean.SalesmanResultBean
import com.xhd.td.vm.cb.home.AddSalesmanCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class AddSalesmanVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<AddSalesmanCB>(dataManager, scheduler) {

    var name: ObservableField<String>? = ObservableField<String>()
    var phone: ObservableField<String>? = ObservableField<String>()

    fun addSalesman(name:String,phone:String) {
        setIsLoading(true)
        var bean = AddSalesmanBean(phone,name)
        dataManager.httpService.addSalesman(bean)
            .compose<BaseModel<SalesmanResultBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<SalesmanResultBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<SalesmanResultBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        //添加成功，跳转到商户密码，显示页面
                        t.data?.let { mCallback?.addSuccess(it) }
                    } else {
                        mCallback?.addFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


}