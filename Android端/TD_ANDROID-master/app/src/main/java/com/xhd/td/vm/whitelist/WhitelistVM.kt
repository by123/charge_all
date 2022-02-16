package com.xhd.td.vm.whitelist

import androidx.lifecycle.MutableLiveData
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.adapter.whitelist.WhitelistRecordAdapter
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*
import com.xhd.td.vm.cb.whitelist.WhitelistCB
import me.texy.treeview.TreeNode

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class WhitelistVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<WhitelistCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    fun createOrderWhiteList(bean: CreateOrderWhiteListBean) {
        setIsLoading(true)
        dataManager.httpService.createOrderWhiteList(bean)
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
                        mCallback?.createWhitelistSuccess(t.data.toString())
                    } else {
                        mCallback?.createWhitelistFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     *  获取白名单使用范围,查询各个商户是否被选择了
     */
    fun queryWhiteListNodeTree(orderWhiteListId: String, mchId: String,treeNode: TreeNode<WhitelistBean>? = null) {
        setIsLoading(true)
        dataManager.httpService.queryWhiteListNodeTree(orderWhiteListId, mchId)
            .compose<BaseModel<List<WhitelistMerchantBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<List<WhitelistMerchantBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<List<WhitelistMerchantBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.queryWhiteListNodeTreeSuccess(it,treeNode)}
                    } else {
                        mCallback?.queryWhiteListNodeTreeFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     *  逐级查询下级商户，白名单选中情况
     */
    fun queryGraduallyChildMch( mchId: String,treeNode: TreeNode<WhitelistBean>) {
        setIsLoading(true)
        dataManager.httpService.queryGraduallyChildMch( mchId)
            .compose<BaseModel<List<MchBean>>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<List<MchBean>>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<List<MchBean>>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.queryGraduallyChildMchSuccess(it,treeNode) }
                    } else {
                        mCallback?.queryGraduallyChildMchFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     *  编辑白名单，商户是否被选中，是否启用白名单
     */
    fun editOrderWhiteList( bean: EditWhitelistBean,holder: WhitelistRecordAdapter.ViewHolder? = null,position:Int? = null) {
        setIsLoading(true)
        dataManager.httpService.editOrderWhiteList(bean)
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
                        mCallback?.editOrderWhiteListSuccess(t.msg.toString(),holder,position)
                    } else {
                        mCallback?.editOrderWhiteListFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }





    /**
     *  获取白名单记录列表
     */
    fun getWhitelistRecordPage(pageId:Int) {
        setIsLoading(true)
        dataManager.httpService.getOrderWhiteListPage( pageId)
            .compose<BaseModel<WhitelistItemBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<WhitelistItemBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getWhitelistRecordFail()
                }

                override fun success(t: BaseModel<WhitelistItemBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getWhitelistRecordSuccess(it) }
                    } else {
                        mCallback?.getWhitelistRecordFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }



    /**
     * 用来获取充电时长
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