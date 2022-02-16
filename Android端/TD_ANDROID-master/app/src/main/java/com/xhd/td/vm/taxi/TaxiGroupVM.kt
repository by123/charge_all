package com.xhd.td.vm.taxi

import androidx.lifecycle.MutableLiveData
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*
import com.xhd.td.vm.cb.taxi.TaxiGroupCB
import io.reactivex.Single

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class TaxiGroupVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<TaxiGroupCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    fun createOrModifyGroup(bean: TaxiGroupBean, isEdit: Boolean) {
        setIsLoading(true)

        val single: Single<BaseModel<TaxiGroupBean>> = if (isEdit) {
            dataManager.httpService.modGroup(bean)
        } else {
            dataManager.httpService.addGroup(bean)
        }

        single
            .compose<BaseModel<TaxiGroupBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<TaxiGroupBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<TaxiGroupBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.createGroupSuccess(t.data?.groupId.toString(), t.data?.groupName.toString())
                    } else {
                        mCallback?.createGroupFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    fun getSalesman(type:Int) {
        setIsLoading(true)

        dataManager.httpService.getAllUser(type)
            .compose<BaseModel<List<SalesmanBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<List<SalesmanBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

               override fun success(t: BaseModel<List<SalesmanBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.getSalesmanSuccess(t.data?:return)
                    } else {
                        mCallback?.getSalesmanFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 分页查询 出租车 分组数据
     */
    fun queryGroup(bean:QueryGroupBean) {
        setIsLoading(true)

        dataManager.httpService.queryGroup(bean)
            .compose<BaseModel<Pages<TaxiGroupBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<Pages<TaxiGroupBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<Pages<TaxiGroupBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.queryGroupSuccess(t.data?:return)
                    } else {
                        mCallback?.queryGroupFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}