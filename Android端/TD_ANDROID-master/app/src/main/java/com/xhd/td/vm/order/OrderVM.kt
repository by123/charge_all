package com.xhd.td.vm.order

import androidx.lifecycle.MutableLiveData
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.base.BaseViewModel
import com.xhd.td.constants.Constants
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*
import com.xhd.td.ui.order.SearchOrderFragment
import com.xhd.td.vm.cb.order.OrderCB
import io.reactivex.Single

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class OrderVM(dataManager: DataManager, scheduler: SchedulerProvider) : BaseViewModel<OrderCB>(dataManager, scheduler) {


    var mWithDrawHint: MutableLiveData<String> = MutableLiveData()

    fun getConfig(key: String) {
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
                        if (key == Constants.CFG_ORDER_WITHDRAW) {
                            mWithDrawHint.value = t.data?.cfgValue
                        } else {
                            t.data?.let { mCallback?.getConfigSuccess(it) }
                        }
                    } else {
                        mCallback?.getConfigFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 获取订单列表
     */
    fun getOrderList(lstMchId: List<String>, orderState: Int, orderType:Int,startTime: String, endTime: String, lastOrderId: String?) {
        setIsLoading(true)
        dataManager.httpService.getOrderList(
            OrderQueryBean(
                lstMchId,
                orderState,
                orderType,
                endTime,
                startTime,
                null,
                pageSize = 20,
                lastOrderId = lastOrderId
            )
        )
            .compose<BaseModel<OrderData>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<OrderData>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getOrderListFail()
                }

                override fun success(t: BaseModel<OrderData>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getOrderListSuccess(it, orderState) }
                    } else {
                        mCallback?.getOrderListFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 根据查询类型和查询关键字，来搜扫订单
     *  查询类型有：商户、订单、设备
     */
    fun getOrderListByKey(type: Int, queryKey: String?, pageId: Int) {
        setIsLoading(true)

        val single: Single<BaseModel<OrderData>> = when (type) {
            SearchOrderFragment.QUERY_TYPE_ORDER_ID -> dataManager.httpService.queryOrderListByKey(
                orderId = queryKey,
                pageId = pageId
            )
            SearchOrderFragment.QUERY_MERCHANT -> dataManager.httpService.queryOrderListByKey(
                mchName = queryKey,
                pageId = pageId
            )
            SearchOrderFragment.QUERY_TYPE_DEVICE -> dataManager.httpService.queryOrderListByKey(
                deviceSn = queryKey,
                pageId = pageId
            )
            else -> dataManager.httpService.queryOrderListByKey(orderId = queryKey, pageId = pageId)
        }
        single.compose<BaseModel<OrderData>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<OrderData>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getOrderListFail()
                }

                override fun success(t: BaseModel<OrderData>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getOrderListSuccess(it, -1) }
                    } else {
                        mCallback?.getOrderListFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 获取子代理
     */
    fun getChildMch() {
        setIsLoading(true)
        dataManager.httpService.queryChildMch()
            .compose<BaseModel<List<MchBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<List<MchBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getChildMchFail()

                }

                override fun success(t: BaseModel<List<MchBean>>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {

                        //代理的信息（id，name），名称用来显示，id用来提交数据
                        t.data?.mapTo(arrayListOf()) { arrayListOf(it.mchId, it.mchName) }?.let {
                            mCallback?.getChildMchSuccess(it)
                        }
                    } else {
                        mCallback?.getChildMchFail(t.msg)
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    //模糊查找，如果不传入keyword，则查找全部，获取商户和连锁门店
//    fun getAgentAndMerchant(keyword: String = "",mchType:Int = 1) {
//        setIsLoading(true)
//        dataManager.httpService.queryBlurMch(keyword,mchType)
//            .compose<BaseModel<List<MchBean>?>>(XNet.getSingleTransformer())
//            .performOnBackOutOnMain(scheduler)
//            .doAfterSuccess { }
//            .subscribeWith(object : ApiSubscriber<BaseModel<List<MchBean>?>>() {
//                override fun onFail(error: NetError?) {
//                    //网络方面的错误
//                    setIsLoading(false)
//                    mCallback?.getAgentAndMerchantFail()
//
//                }
//
//                override fun success(t: BaseModel<List<MchBean>?>) {
//                    setIsLoading(false)
//                    //业务的成功与否
//                    if (t.success) {
//                        t.data?.let { mCallback?.getAgentAndMerchantSuccess(it) }
//                    } else {
//                        mCallback?.getAgentAndMerchantFail(t.msg.toString())
//                    }
//                }
//            })
//            .addTo(compositeDisposable)
//    }


    //模糊查找，如果不传入keyword，则查找全部，获取商户和连锁门店
    fun getAgentAndMerchant(queryAgentMch: QueryAgentMchBean) {
        setIsLoading(true)
        dataManager.httpService.querylistPost(queryAgentMch)
            .compose<BaseModel<PageBean<MchBean>?>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<PageBean<MchBean>?>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getAgentAndMerchantFail()
                }

                override fun success(t: BaseModel<PageBean<MchBean>?>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getAgentAndMerchantSuccess(it) }
                    } else {
                        mCallback?.getAgentAndMerchantFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    var bean: MutableLiveData<OrderDetailBean> = MutableLiveData()

    /**
     * 获取订单详情
     */
    fun getOrderDetails(orderId: String) {
        setIsLoading(true)
        dataManager.httpService.getOrderDetails(orderId)
            .compose<BaseModel<OrderDetailBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<OrderDetailBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<OrderDetailBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        bean.value = t.data
                    } else {
                        mCallback?.getOrderDetailFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

    /**
     * 申请退款
     */
    fun refund(refundBean: RefundBean) {
        setIsLoading(true)
        dataManager.httpService.refund(refundBean)
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
                        mCallback?.refundSuccess(t.data.toString())

                    } else {
                        mCallback?.refundFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}