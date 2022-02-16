package com.xhd.td.vm.home

import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.AddMerchantBean
import com.xhd.td.model.bean.AddResponseBean
import com.xhd.td.model.bean.BaseModel
import com.xhd.td.model.bean.EditBeam
import com.xhd.td.ui.home.AbstractAddModifyFragment
import io.reactivex.Single

/**
 * create by xuexuan
 * time 2019/3/30 14:27
 */
class AgentAndChainVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    AbstractMerchantVM(dataManager, scheduler) {


    fun addChainAgent(p: AddMerchantBean, type: Int) {
        setIsLoading(true)

        var single: Single<BaseModel<AddResponseBean>>
        if (type == AbstractAddModifyFragment.CHAIN_AGENT) {
            single = dataManager.httpService.addChainAgent(p)
        } else {
            single = dataManager.httpService.addAgent(p)
        }

        single.compose<BaseModel<AddResponseBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess {}
            .subscribeWith(object : ApiSubscriber<BaseModel<AddResponseBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<AddResponseBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        //添加连锁总店成功，把账户密码返回到view，准备跳转界面
                        t.data?.let { mCallback?.addSuccess(it) }
                    } else {
                        mCallback?.addFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }





    fun editAgentAndChain(bean: EditBeam ) {
        setIsLoading(true)

        dataManager.httpService.modAgent(bean).compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess {}
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<String>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        //编辑连锁门店成功
                         mCallback?.modifyAgentSuccess(t.msg.toString())
                    } else {
                        mCallback?.modifyAgentFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


}