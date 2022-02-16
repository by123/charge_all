package com.xhd.td.vm.cb.order

import com.xhd.td.model.bean.*
import java.util.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface OrderCB {

    fun handleError(throwable: Throwable?)

    fun getConfigSuccess(data: CfgBean){}
    fun getConfigFail(msg:String){}



    fun getOrderListSuccess(data: OrderData,viewPageId:Int){}
    fun getOrderListFail(msg:String? = null){}

    //data的是代理的信息（id，name），名称用来显示，id用来提交数据
    fun getChildMchSuccess(data: ArrayList<ArrayList<String?>>){}
    fun getChildMchFail(msg:String? = null){}


    fun getAgentAndMerchantSuccess(data: PageBean<MchBean>){}
    fun getAgentAndMerchantFail(msg: String? = null){}

    fun getOrderDetailFail(msg: String){}
    fun getOrderDetailSuccess(bean: OrderDetailBean){}


    fun refundFail(msg: String){}
    fun refundSuccess(msg: String){}
}