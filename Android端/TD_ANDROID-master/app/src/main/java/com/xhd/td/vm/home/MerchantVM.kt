package com.xhd.td.vm.home

import androidx.lifecycle.MutableLiveData
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class MerchantVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    AbstractMerchantVM(dataManager, scheduler) {


    override var mBillingRuleLiveData: MutableLiveData<List<PriceBean>> = MutableLiveData()

    /**
     * 获取由当前账户添加的连锁总店
     * 调用的接口是查询 子商户，需要进行过滤，找出连锁总店
     */
    fun getChainStore() {
        setIsLoading(true)

        dataManager.httpService.queryChildMch()
            .compose<BaseModel<List<MchBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess {}
            .subscribeWith(object : ApiSubscriber<BaseModel<List<MchBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)

                }

                override fun success(t: BaseModel<List<MchBean>>) {
                    setIsLoading(false)

                    //业务的成功与否
                    if (t.success) {
                        //过滤出连锁总店，每条信息包含 ID，商户名称，行业，分润
                        mCallback?.getChainStoreSuccess(t.data?.filter { it.level == 4 }?.mapTo(arrayListOf()) {
                            arrayListOf(
                                it.mchId,
                                it.mchName?:"",
                                it.industry?:"",
                                it.totalPercent.toString()
                            )
                        } ?: arrayListOf())
                    } else {
                        mCallback?.addFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    fun addMerchant(bean: AddMerchantBean) {
        setIsLoading(true)
        dataManager.httpService.addTenant(bean)
            .compose<BaseModel<AddResponseBean>>(XNet.getSingleTransformer())
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
                        t.data?.let { mCallback?.addSuccess(it) }
                    } else {
                        mCallback?.addFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    fun addChainTenant(bean: AddMerchantBean) {
        setIsLoading(true)
        dataManager.httpService.addChainTenant(bean)
            .compose<BaseModel<AddResponseBean>>(XNet.getSingleTransformer())
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
                        t.data?.let { mCallback?.addSuccess(it) }
                    } else {
                        mCallback?.addFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    //获取计费规则
    fun getBillingRules() {
        setIsLoading(true)
        dataManager.httpService.getBillingRules()
            .compose<BaseModel<PriceListBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess {}
            .subscribeWith(object : ApiSubscriber<BaseModel<PriceListBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<PriceListBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mBillingRuleLiveData.value = t.data?.defaultPriceRule
                    } else {
                        mCallback?.addFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    //修改商户信息
    fun modifyMerchant(bean:EditBeam) {
        setIsLoading(true)
        dataManager.httpService.modTenant(bean)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
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
                        mCallback?.modifyMerchantSuccess(t.data.toString())
                    } else {
                        mCallback?.modifyMerchantFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    //修改计费规则
    fun modifyBillingRules(bean:ChangeRuleBeam) {
        setIsLoading(true)
        dataManager.httpService.changeRule(bean)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
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
                        mCallback?.modifyBillingRulesSuccess(t.data.toString())
                    } else {
                        mCallback?.modifyBillingRulesFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }
}