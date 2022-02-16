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
import com.xhd.td.model.bean.AccountDetailBean
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.model.bean.IncomeTempBeam
import com.xhd.td.model.bean.IncomeTopBeam
import com.xhd.td.vm.cb.income.IncomeDetailCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class IncomeDetailVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<IncomeDetailCB>(dataManager, scheduler) {

    var mIncomeTopBean: MutableLiveData<IncomeTopBeam> = MutableLiveData()


    /**
     * 主要是获取提现周期，
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


    /**
     * 获取收益详情
     */
    fun getIncomeCondition(data :String) {
        setIsLoading(true)
        dataManager.httpService.getIncomeCondition(data)
            .compose<BaseModel<IncomeTopBeam>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<IncomeTopBeam>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<IncomeTopBeam>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mIncomeTopBean.value = t.data
//                        mCallback.getTenantDeviceInfoSuccess(t.msg.toString())
                    } else {
                        mIncomeTopBean.value = null
                        mCallback?.getIncomeConditionFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 获取收益详情界面中的渠道输入，设备使用
     */
    fun getChildrenDeviceUsingScenes(date: String, pageId: Int, pageSize: Int = 100){

        setIsLoading(true)
        dataManager.httpService.getChildrenDeviceUsingScenes(date, pageId, pageSize)
            .compose<BaseModel<IncomeTempBeam<IncomeTopBeam>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<IncomeTempBeam<IncomeTopBeam>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)

                }

                override fun success(t: BaseModel<IncomeTempBeam<IncomeTopBeam>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getIncomeDetailSuccess(it )}
                    } else {
                        mCallback?.getIncomeDetailFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}