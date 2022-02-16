package com.xhd.td.vm.cb.mine

import com.xhd.td.model.bean.MessageBean
import com.xhd.td.model.bean.PageBean

/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface MessageCB {

    fun handleError(throwable: Throwable)

    //获取消息的列表
    fun getDataSuccess(data: PageBean<MessageBean>) {}

    fun getDataFail(msg: String?) {}


    //获取消息的详细信息
    fun getNoticeMessageDetailSuccess(bean:MessageBean){}

    fun getNoticeMessageDetailFail(msg: String?) {}

}