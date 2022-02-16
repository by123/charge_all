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
import com.xhd.td.model.bean.*
import com.xhd.td.vm.cb.income.WithdrawCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class WithdrawVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<WithdrawCB>(dataManager, scheduler) {

    var mWithDrawHint: MutableLiveData<String> = MutableLiveData()
    fun getConfig(key:String,mchType: String?=null){
        setIsLoading(true)
        dataManager.httpService.getCfg(key,mchType)
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

                        mCallback?.getConfigSuccess(t.data?.cfgValue,key)
                    } else {
                        mCallback?.getConfigFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     * 获取商户、代理商、微信零钱、平台的提现规则
     */
    fun getWithdrawRuleAll(mchType: Int,channel:Int?=null){
        setIsLoading(true)
        dataManager.httpService.getWithdrawRuleByMchTypeAndChannel(mchType,channel)
            .compose<BaseModel<List<BankCardWithDrawRule>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<List<BankCardWithDrawRule>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<List<BankCardWithDrawRule>>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getWithdrawRuleAllSuccess(it) }
                    } else {
                        mCallback?.getWithdrawRuleAllFail("获取提现规则失败" + t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 获取商户、代理商提现规则，按照阶梯收费
     */
    fun getWithdrawRuleByMchType(mchType: Int?=null){
        setIsLoading(true)
        dataManager.httpService.getWithdrawRuleByMchType(mchType)
            .compose<BaseModel<List<WithDrawRule>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<List<WithDrawRule>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<List<WithDrawRule>>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getWithdrawRuleByMchTypeSuccess(it) }
                    } else {
                        mCallback?.getWithdrawRuleByMchTypeFail("获取提现规则失败" + t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     *
     * 提现手续费（银行收取）按照阶梯收费，支付手续费（支付收取），代扣税
     *
     */
    fun queryWithdrawTax(withdrawMoney:Double,mchType: Int?){
        setIsLoading(true)
        dataManager.httpService.queryWithdrawTax(withdrawMoney,mchType)
            .compose<BaseModel<WithDrawFee>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<WithDrawFee>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<WithDrawFee>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.queryWithdrawTaxSuccess(it) }
                    } else {
                        mCallback?.queryWithdrawTaxFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }




    /**
     * 申请提现
     */
    fun applyWithdrawal(bankId:String,number:Double){
        setIsLoading(true)
        dataManager.httpService.applyWithdrawal(WithdrawBean(bankId,number))
            .compose<BaseModel<WithDrawResultBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<WithDrawResultBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<WithDrawResultBean>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.applyWithdrawalSuccess(it)}
                    } else {
                        mCallback?.applyWithdrawalFail("申请提现失败" + t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 查询银行卡列表
     *
     */
    fun getBankListInfo() {
        setIsLoading(true)

        dataManager.httpService.getBankListInfo()
            .compose<BaseModel<BankListBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<BankListBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getListFail()
                }

                override fun success(t: BaseModel<BankListBean>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getListSuccess(it) }
                    } else {
                        mCallback?.getListFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


}