package com.xhd.td.vm

import android.content.Context
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import cn.xuexuan.mvvm.utils.ToastUtil
import com.elvishew.xlog.XLog
import com.umeng.message.UmengMessageHandler
import com.umeng.message.UmengNotificationClickHandler
import com.umeng.message.entity.UMessage
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.data.DataManager
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.BaseModel
import javax.inject.Inject

/**
 * create by xuexuan
 * time 2019/3/15 11:38
 */

class AppVM @Inject constructor(
    dataManager: DataManager,
    schedulerProvider: SchedulerProvider
) :
    BaseViewModelNoCb(dataManager, schedulerProvider) {

    val messageHandler = object : UmengMessageHandler() {

        /**
         * 通知的回调方法（通知送达时会回调）
         */
        override fun dealWithNotificationMessage(context: Context, msg: UMessage) {
            super.dealWithNotificationMessage(context, msg)

            //调用super，会展示通知，不调用super，则不展示通知。
            //{"display_type":"notification","msg_id":"umi01ms156352602145500","body":{"after_open":"go_app","ticker":"广东一核一带一区区域发展新格局一图看懂你家未来定位","text":"【深惠未来5条轨道交通相连，大湾区新CP如何加速同城化?】","title":"广东一核一带一区区域发展新格局一图看懂你家未来定位"},"random_min":0}
            //{"display_type":"notification","msg_id":"umgfzcn156351990205500","body":{"after_open":"go_app","ticker":"测试","text":"简要","title":"测试"},"random_min":0}

            if (Constants.APP_ALREADY_OPEN) {
                //当前app是在前台
                XLog.d("收到消息，应用前台，" + msg.text)
                BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.MESSAGE_RED_ICON, true))
            } else {
                //当前app不是在前台
                XLog.d("收到消息，应用后台，" + msg.text)
                dataManager.newMessageTag = true
            }

        }
    }

    /**
     * 自定义行为的回调处理，参考文档：高级功能-通知的展示及提醒-自定义通知打开动作
     * UmengNotificationClickHandler是在BroadcastReceiver中被调用，故
     * 如果需启动Activity，需添加Intent.FLAG_ACTIVITY_NEW_TASK
     * */
    val notificationClickHandler = object : UmengNotificationClickHandler() {

        override fun launchApp(context: Context, msg: UMessage?) {
            super.launchApp(context, msg)
            if (dataManager.accessToken != null) {

                val messageId = msg?.extra?.get("id")?.toInt()
                //当前是否处于登录状态
                if (Constants.APP_ALREADY_OPEN) {
                    //当前app是在前台
                    XLog.i("点击消息：应用前台，用户已经登录，打开消息界面")
                    BusProvider.getBus()?.post(EventMessage<Int>(EventKey.MESSAGE_DETAIL, messageId?:0))
                } else {
                    //当前app不是在前台
                    //设置一个全局静态变量，如果不为空，认为有推送
                    XLog.i("点击消息：应用后台，记录点击的消息id")
                    Constants.CLICK_NEW_MESSAGE_ID = messageId
                }
            } else {
                //当前不是登录状态
                XLog.i("点击消息：未登录APP")
                context?.let { ToastUtil.showLong(it, "请先登录APP") }
            }
        }

        override fun openUrl(context: Context, msg: UMessage) {
            super.openUrl(context, msg)
        }

        override fun openActivity(context: Context, msg: UMessage) {
            super.openActivity(context, msg)
        }

        override fun dealWithCustomAction(context: Context?, msg: UMessage) {
            //{"display_type":"notification","extra":{"x":"xx"},"msg_id":"umw2ucs156352650473710","body":{"after_open":"go_custom","play_lights":"false","ticker":"测试标题","play_vibrate":"false","custom":"消息点击后，自定义处理","text":"测试内容","title":"测试标题","play_sound":"true"},"random_min":0}
            //这里的msg.custom 是消息的id
            XLog.i("点击消息：自定义行为")
        }
    }

    fun addDeviceToken(deviceToken: String) {

        dataManager.httpService.addDeviceToken(deviceToken)
            .compose<BaseModel<String>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<BaseModel<String>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                }

                override fun success(t: BaseModel<String>) {
                    if (t.success) {
                        XLog.i("向服务器发送Token成功：")
                    }
                }
            })
            .addTo(compositeDisposable)
    }


}
