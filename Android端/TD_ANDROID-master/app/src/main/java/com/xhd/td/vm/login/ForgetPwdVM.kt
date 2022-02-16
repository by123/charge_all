package com.xhd.td.vm.login

import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.model.bean.ChangePwdBean
import com.xhd.td.model.bean.VerifyCodeBean
import com.xhd.td.vm.cb.ForgetPwdCallback

/**
 * create by xuexuan
 * time 2019/3/19 14:29
 */
class ForgetPwdVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<ForgetPwdCallback>(dataManager, scheduler) {

    /**
     * 获取验证码
     */
    fun getSMSCode(userName: String) {
        setIsLoading(true)
        dataManager.httpService.getSMSCode(userName)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.getCodeSuccess(t.data!!)
                    } else {
                        mCallback?.getCodeFail(t.msg!!)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 验证验证码是否正确
     */
    fun verifyCode(verifyCodeBean: VerifyCodeBean) {
        setIsLoading(true)
        dataManager.httpService.vefifyCode(verifyCodeBean)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误或其他未知错误
                    setIsLoading(false)
                }
                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.verifyCodeSuccess(t.data?:"")
                    } else {
                        mCallback?.verifyCodeFail(t.msg!!)
                    }
                }
            })
            .addTo(compositeDisposable)
    }




    fun changePwd(changePwdBean: ChangePwdBean) {
        setIsLoading(true)
        dataManager.httpService.changePwd(changePwdBean)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误或其他未知错误
                    setIsLoading(false)
                }
                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.modifyPwdSuccess()
                    } else {
                        mCallback?.modifyPwdFail(t.msg!!)
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}