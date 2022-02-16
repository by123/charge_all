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
import com.xhd.td.model.bean.ModifyBean
import com.xhd.td.vm.cb.mine.EditPwdCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class EditPwdVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<EditPwdCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    fun modifyPwd(oldPwd: String,newPwd: String,comfirePwd: String) {
        setIsLoading(true)
        val bean = ModifyBean(oldPwd, newPwd,comfirePwd)
        dataManager.httpService.modifyPwd(bean)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.modifySuccess(t.msg.toString())
                    } else {
                        mCallback?.modifyFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}