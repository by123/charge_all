package com.xhd.td

import android.annotation.TargetApi
import android.app.Application
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.Toast
import androidx.multidex.MultiDex
import cn.xuexuan.mvvm.log.XLogBuilder
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.NetProvider
import cn.xuexuan.mvvm.net.RequestHandler
import cn.xuexuan.mvvm.net.XNet
import cn.xuexuan.mvvm.utils.ToastUtil
import com.elvishew.xlog.XLog
import com.tencent.bugly.Bugly
import com.tencent.bugly.beta.Beta
import com.tencent.bugly.beta.interfaces.BetaPatchListener
import com.tencent.bugly.crashreport.CrashReport
import com.xhd.td.net.DataInterceptor
import me.yokeyword.fragmentation.Fragmentation
import okhttp3.CookieJar
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import java.util.*


/**
 * 自定义ApplicationLike类.
 *
 * 注意：这个类是Application的代理类，以前所有在Application的实现必须要全部拷贝到这里<br></br>
 *
 * @author wenjiewu
 * @since 2016/11/7
 */
class ApplicationLike(
    application: Application, tinkerFlags: Int,
    tinkerLoadVerifyFlag: Boolean, applicationStartElapsedTime: Long,
    applicationStartMillisTime: Long, tinkerResultIntent: Intent
) : com.tencent.tinker.entry.DefaultApplicationLike(
    application,
    tinkerFlags,
    tinkerLoadVerifyFlag,
    applicationStartElapsedTime,
    applicationStartMillisTime,
    tinkerResultIntent
) {


    companion object {
        lateinit var instance: Application
        fun instance() = instance
        val TAG = "Tinker.SampleApplicationLike"
    }

    override fun onCreate() {
        super.onCreate()
        instance = this.application
        initBugly()

        initNetConfig()
        initFragment()
        XLogBuilder.init()
    }

    private fun initFragment() {
        Fragmentation.builder()
            // 设置 栈视图 模式为 （默认）悬浮球模式   SHAKE: 摇一摇唤出  NONE：隐藏， 仅在Debug环境生效
            .stackViewMode(Fragmentation.BUBBLE)
            .debug(BuildConfig.DEBUG) // 实际场景建议.debug(BuildConfig.DEBUG)
            /**
             * 可以获取到[me.yokeyword.fragmentation.exception.AfterSaveStateTransactionWarning]
             * 在遇到After onSaveInstanceState时，不会抛出异常，会回调到下面的ExceptionHandler
             */
            .handleException {
                // 以Bugtags为例子: 把捕获到的 Exception 传到 Bugtags 后台。
                // Bugtags.sendException(e);
                CrashReport.postCatchedException(it)  // bugly会将这个throwable上报
            }
            .install()
    }

    /**
     * 网络请求初始化
     */
    private fun initNetConfig() {
        XNet.registerProvider(object : NetProvider {
            override fun configInterceptors(): Array<Interceptor> {
                return arrayOf(DataInterceptor())
            }

            override fun configHttps(builder: OkHttpClient.Builder) {
                if (BuildConfig.DEBUG) {
                    //如果是测试环境则，设置fiddler证书
                }
            }

            override fun configCookie(): CookieJar? {
                return null
            }

            override fun configHandler(): RequestHandler? {
                return null
            }

            override fun configConnectTimeoutSec(): Long {
                return 10
            }

            override fun configReadTimeoutSec(): Long {
                return 10
            }

            override fun configLogEnable(): Boolean {
                return BuildConfig.DEBUG
            }

            override fun handleError(error: NetError): Boolean {
                val msg: String
                when (error.type) {
//                    NetError.UnknownHostError -> { msg = "未知的主机地址" }
                    NetError.UnknownHostError -> {
                        msg = "网络链接不可用"
                    }
                    NetError.SocketTimeoutError -> {
                        msg = "网络连接超时"
                    }
                    NetError.ConnectErroe -> {
                        msg = "网络连接出错了"
                    }
                    NetError.ParseError -> {
                        msg = "解析数据出错了"
                    }

                    NetError.NullPointerException,
                    NetError.ArithmeticException,
                    NetError.IllegalAccessException,
                    NetError.StackOverflowError,
                    NetError.EOFException,
                    NetError.FileNotFoundException,
                    NetError.NumberFormatException,
                    NetError.IndexOutOfBoundsException -> {
                        //数据超界
                        msg = "程序出错了"
                    }
                    else -> {
                        msg = "未知错误"
                    }

                }
                ToastUtil.showShort(ApplicationLike.instance, msg)
                CrashReport.postCatchedException(error.exception)  // bugly会将这个throwable上报
                return false
            }
        })
    }


    private fun initBugly() {
        super.onCreate()
        // 设置是否开启热更新能力，默认为true
        Beta.enableHotfix = true
        // 设置是否自动下载补丁，默认为true
        Beta.canAutoDownloadPatch = true
        // 设置是否自动合成补丁，默认为true
        Beta.canAutoPatch = true
        // 设置是否提示用户重启，默认为false
        Beta.canNotifyUserRestart = BuildConfig.DEBUG
        // 补丁回调接口

        if (BuildConfig.DEBUG) {
            Beta.betaPatchListener = object : BetaPatchListener {
                override fun onPatchReceived(patchFile: String) {
                    Toast.makeText(application, "补丁下载地址$patchFile", Toast.LENGTH_SHORT).show()
                    XLog.d("补丁下载地址$patchFile")
                }

                override fun onDownloadReceived(savedLength: Long, totalLength: Long) {
                    Toast.makeText(
                        application,
                        String.format(
                            Locale.getDefault(), "%s %d%%",
                            Beta.strNotificationDownloading,
                            (if (totalLength == 0L) 0 else savedLength * 100 / totalLength).toInt()
                        ),
                        Toast.LENGTH_SHORT
                    ).show()
                }

                override fun onDownloadSuccess(msg: String) {
                    Toast.makeText(application, "补丁下载成功", Toast.LENGTH_SHORT).show()
                    XLog.d("补丁下载成功")

                }

                override fun onDownloadFailure(msg: String) {
                    Toast.makeText(application, "补丁下载失败", Toast.LENGTH_SHORT).show()
                    XLog.d("补丁下载失败")

                }

                override fun onApplySuccess(msg: String) {
                    Toast.makeText(application, "补丁应用成功", Toast.LENGTH_SHORT).show()
                    XLog.d("补丁应用成功")
                }

                override fun onApplyFailure(msg: String) {
                    Toast.makeText(application, "补丁应用失败", Toast.LENGTH_SHORT).show()
                    XLog.d("补丁应用失败")
                }

                override fun onPatchRollback() {

                }
            }
        }

        // 设置开发设备，默认为false，上传补丁如果下发范围指定为“开发设备”，需要调用此接口来标识开发设备
        Bugly.setIsDevelopmentDevice(application, BuildConfig.DEBUG)
        // 多渠道需求塞入
        // String channel = WalleChannelReader.getChannel(getApplication());
        // Bugly.setAppChannel(getApplication(), channel);
        // 这里实现SDK初始化，appId替换成你的在Bugly平台申请的appId
        Bugly.init(application, BuildConfig.BUGLY_ID, BuildConfig.DEBUG)
    }


    @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    override fun onBaseContextAttached(base: Context?) {
        super.onBaseContextAttached(base)
        // you must install multiDex whatever tinker is installed!
        MultiDex.install(base)

        Beta.installTinker(this)
    }

    @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun registerActivityLifecycleCallback(
        callbacks: Application.ActivityLifecycleCallbacks
    ) {
        application.registerActivityLifecycleCallbacks(callbacks)
    }

    override fun onTerminate() {
        super.onTerminate()
        Beta.unInit()
    }
}
