package com.xhd.td.vm.cb

import com.xhd.td.model.bean.AddResponseBean

/**
 * create by xuexuan
 * time 2019/3/26 15:17
 */
interface AbstractMerchantCallback{

    fun getConfigSuccess(key:String,data: String?)
    fun getConfigFail(msg:String?)

    fun addSuccess(bean: AddResponseBean){}
    fun addFail(msg:String?){}


    fun submitSuccess(bean: AddResponseBean){}
    fun submitFail(msg:String?){}


    fun getChainStoreSuccess(chainStoreInfos:ArrayList<ArrayList<String>>){}
    fun getChainStoreFail(msg:String?){}

    fun setIsLoading(i:Boolean){}


    /**
     * 修改代理商和连锁门店成功
     */
    fun modifyAgentSuccess(msg:String){}
    fun modifyAgentFail(msg:String){}


    /**
     * 修改普通分店和连锁分店成功
     */
    fun modifyMerchantSuccess(msg:String){}
    fun modifyMerchantFail(msg:String){}

    /**
     * 修改计费规则成功
     */
    fun modifyBillingRulesSuccess(msg:String){}
    fun modifyBillingRulesFail(msg:String){}





}