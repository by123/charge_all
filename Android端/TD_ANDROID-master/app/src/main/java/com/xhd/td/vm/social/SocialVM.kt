package com.xhd.td.vm.social

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
import com.xhd.td.model.bean.TblUserUnionid
import com.xhd.td.utils.social.callback.SocialNetCallback
import com.xhd.td.vm.cb.social.SocialCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class SocialVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<SocialCB>(dataManager, scheduler), SocialNetCallback {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    override fun getUerInfo(url: String): String? {

        var result: String? = null
        setIsLoading(true)
        dataManager.httpService.getWechatInfo(url)
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
                        result = t.msg.toString()
                    } else {
                        mCallback?.getUserInfoFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
        return result
    }

    override fun getAccessToken(code: String): String? {

        setIsLoading(true)
        dataManager.httpService.getWechatAccessToken(code)
            .compose<BaseModel<TblUserUnionid>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<TblUserUnionid>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<TblUserUnionid>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getAccessTokenSuccess(it) }
                    } else {
                        //已经绑定微信
                        mCallback?.getAccessTokenFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
        //服务器直接返回了头像和昵称，所以不需要再使用accesstoken获取了，所以返回null
        return null

    }
}