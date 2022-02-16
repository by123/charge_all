package com.xhd.td.vm.cb.income

import com.xhd.td.model.bean.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface WithdrawCB {

    fun handleError(throwable: Throwable){}

    fun getConfigSuccess(data: String?,key:String){}
    fun getConfigFail(msg:String?){}

    fun applyWithdrawalSuccess(withdrawalResultBean: WithDrawResultBean){}
    fun applyWithdrawalFail(msg:String?){}

    fun getWithdrawRuleAllSuccess(bean: List<BankCardWithDrawRule>){}
    fun getWithdrawRuleAllFail(msg:String?){}

    //获取阶梯提现手续费
    fun getWithdrawRuleByMchTypeSuccess(bean: List<WithDrawRule>){}
    fun getWithdrawRuleByMchTypeFail(msg:String?){}


    //获取阶梯提现手续费
    fun queryWithdrawTaxSuccess(bean: WithDrawFee){}
    fun queryWithdrawTaxFail(msg:String?){}

    //获取银行卡列表回调
    fun getListSuccess(data: BankListBean) {}
    fun getListFail(msg: String?=null) {}

}