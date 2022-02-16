package com.xhd.td.vm.login

import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.BuildConfig
import com.xhd.td.base.BaseViewModel
import com.xhd.td.constants.Constants
import com.xhd.td.data.DataManager
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.*
import com.xhd.td.vm.cb.LoginCallback
import io.reactivex.Flowable
import io.reactivex.functions.BiFunction

/**
 * create by xuexuan
 * time 2019/3/18 19:36
 */
class LoginVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<LoginCallback>(dataManager, scheduler) {


    var name: ObservableField<String>? = ObservableField<String>()
    var pwd1: ObservableField<String>? = ObservableField<String>()
    var checkbox: ObservableBoolean? = ObservableBoolean(true)

    fun login(name: String, pwd: String) {
        setIsLoading(true)
        val loginBean = LoginBean(name, pwd)
        dataManager.httpService.login(loginBean)
            .compose<BaseModel<LoginResultBean>>(XNet.getSingleTransformer())
            .doOnSuccess { comments -> setToken(comments.data, loginBean) }
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<LoginResultBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    error?.let { mCallback?.handleError(it) }
                }

                override fun success(t: BaseModel<LoginResultBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.loginSuccess()
                    } else {
                        mCallback?.loginFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    fun getAccount(): String? {
        return dataManager.currentAccount
    }

    fun getPwd(): String? {
        return dataManager.currentPassword
    }


    fun getToken(): String? {
        return dataManager.accessToken

    }

    fun setToken(bean: LoginResultBean?, loginBean: LoginBean) {
        Constants.IS_ALREADY_SIGN_OUT = false
        if (bean != null) {
            //保存账号密码
            dataManager.updateUserInfo(
                accessToken = bean.token,
                mchId = bean.tblMch.mchId,
                userId = bean.user.userId
            )
            dataManager.currentAccount = loginBean.userName
            dataManager.currentPassword = null
            dataManager.insertUser(bean.user)
            dataManager.insertMerchant(bean.tblMch)
            UserModel.initModel(bean.user, bean.tblMch, bean.token)
        }
    }


    fun setUserModelForLocal() {

        Flowable.zip(
            dataManager.findUserBeanByUserId(dataManager.userId ?: ""),
            dataManager.findMchBeanByMchId(dataManager.mchId ?: ""),
            BiFunction<UserBean, MchBean, LoginResultBean> { i1, i2 ->
                LoginResultBean(i1, i2, dataManager.accessToken ?: "")
            })
            .doOnNext { UserModel.initModel(it.user, it.tblMch, it.token) }
            .performOnBackOutOnMain(scheduler)
            .subscribe({mCallback?.jumpToMain()},{it.toString()})
            .addTo(compositeDisposable)
    }


    fun checkVersion(grayscale:Boolean) {
        setIsLoading(true)

        dataManager.httpService.getVersion(BuildConfig.VERSION_CODE,if (grayscale)2 else 0 )
            .compose<BaseModel<List<VersionBeam>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribe(object : ApiSubscriber<BaseModel<List<VersionBeam>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getVersionFail("检测版本失败")

                }

                override fun success(t: BaseModel<List<VersionBeam>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getVersionSuccess(it) }
                    } else {
                        mCallback?.getVersionFail(t.msg.toString())
                    }
                }
            })

    }


    /**
     * 这里主要是获取灰度更新的用户列表
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


}