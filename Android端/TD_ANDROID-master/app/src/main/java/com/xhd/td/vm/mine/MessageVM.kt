package com.xhd.td.vm.mine

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
import com.xhd.td.model.bean.MessageBean
import com.xhd.td.model.bean.PageBean
import com.xhd.td.vm.cb.mine.MessageCB

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class MessageVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<MessageCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()

    /**
     * 获取消息的列表
     *
     */
    fun queryNoticeMessageList(beginTime: String? = null, pageId: Int) {
        setIsLoading(true)

        dataManager.httpService.queryNoticeMessageList(beginTime = beginTime, pageId = pageId)
            .compose<BaseModel<PageBean<MessageBean>?>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<PageBean<MessageBean>?>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<PageBean<MessageBean>?>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getDataSuccess(it) }
                    } else {
                        mCallback?.getDataFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 获取消息的详细信息
     *
     */
    fun getNoticeMessageDetail(id: Int) {
        setIsLoading(true)

        dataManager.httpService.getNoticeMessageDetail(id)
            .compose<BaseModel<MessageBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<MessageBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<MessageBean>) {
                    setIsLoading(false)
//                    业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.getNoticeMessageDetailSuccess(it) }
                    } else {
                        mCallback?.getNoticeMessageDetailFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }

}