package com.xhd.td.vm

import android.app.Notification
import android.content.Context
import cn.xuexuan.mvvm.net.SchedulerProvider
import com.umeng.message.UmengMessageHandler
import com.umeng.message.entity.UMessage
import com.xhd.td.data.DataManager
import javax.inject.Inject

/**
 * create by xuexuan
 * time 2019/7/19 11:24
 */

class MyPushMessageHandler @Inject
constructor(
    private val dataManager: DataManager,
    private val schedulerProvider: SchedulerProvider
) : UmengMessageHandler() {


    /**
     * 通知的回调方法（通知送达时会回调）
     */
    override fun dealWithNotificationMessage(context: Context, msg: UMessage) {
        //调用super，会展示通知，不调用super，则不展示通知。
        super.dealWithNotificationMessage(context, msg)
    }

    /**
     * 自定义通知栏样式的回调方法
     */
    override fun getNotification(context: Context?, msg: UMessage): Notification {

                //默认为0，若填写的builder_id并不存在，也使用默认。
                return super.getNotification(context, msg)
    }

}