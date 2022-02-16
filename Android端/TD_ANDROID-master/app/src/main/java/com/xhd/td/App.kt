package com.xhd.td

import android.app.Activity
import androidx.fragment.app.Fragment
import com.elvishew.xlog.XLog
import com.tencent.tinker.loader.shareutil.ShareConstants
import com.umeng.commonsdk.UMConfigure
import com.umeng.message.IUmengRegisterCallback
import com.umeng.message.PushAgent
import com.xhd.td.di.component.DaggerAppComponent
import com.xhd.td.vm.AppVM
import dagger.android.AndroidInjector
import dagger.android.DispatchingAndroidInjector
import dagger.android.HasActivityInjector
import dagger.android.support.HasSupportFragmentInjector
import javax.inject.Inject

/**
 * 自定义Application.
 *
 * 注意：这个类集成TinkerApplication类，这里面不做任何操作，所有Application的代码都会放到ApplicationLike继承类当中<br></br>
 * <pre>
 * 参数解析：
 * 参数1：int tinkerFlags 表示Tinker支持的类型 dex only、library only or all suuport，default: TINKER_ENABLE_ALL
 * 参数2：String delegateClassName Application代理类 这里填写你自定义的ApplicationLike
 * 参数3：String loaderClassName  Tinker的加载器，使用默认即可
 * 参数4：boolean tinkerLoadVerifyFlag  加载dex或者lib是否验证md5，默认为false
</pre> *
 * @author wenjiewu
 * @since 2016/11/15
 */
class App : HasActivityInjector, HasSupportFragmentInjector, com.tencent.tinker.loader.app.TinkerApplication(
    ShareConstants.TINKER_ENABLE_ALL,
    "com.xhd.td.ApplicationLike",
    "com.tencent.tinker.loader.TinkerLoader",
    false
) {
    @Inject
    lateinit var fragmentDispatchingAndroidInjector: DispatchingAndroidInjector<Fragment>
    @Inject
    lateinit var activityDispatchingAndroidInjector: DispatchingAndroidInjector<Activity>

    @Inject
    lateinit var viewModel: AppVM

    override fun supportFragmentInjector(): AndroidInjector<Fragment> {
        return fragmentDispatchingAndroidInjector
    }

    override fun activityInjector(): AndroidInjector<Activity> {
        return activityDispatchingAndroidInjector
    }

    override fun onCreate() {
        super.onCreate()
        initDI()
        initUPush()
    }

    private fun initDI() {
//        Components.appComponent = DaggerAppComponent.builder()
////
////            .baseModule(AppModule())
////            .baseModule(NetworkModule())
//
//            .coreComponent(MVVMApp.mCoreComponent).build()

        DaggerAppComponent.builder()
            .application(this)
            .build()
            .inject(this)

    }


    private fun initUPush() {
        //设置LOG开关，默认为false
        UMConfigure.setLogEnabled(BuildConfig.DEBUG)

        // 在此处调用基础组件包提供的初始化函数 相应信息可在应用管理 -> 应用信息 中找到 http://message.umeng.com/list/apps
        // 参数一：当前上下文context；
        // 参数二：应用申请的Appkey（需替换）；
        // 参数三：渠道名称；
        // 参数四：设备类型，必须参数，传参数为UMConfigure.DEVICE_TYPE_PHONE则表示手机；传参数为UMConfigure.DEVICE_TYPE_BOX则表示盒子；默认为手机；
        // 参数五：Push推送业务的secret 填充Umeng Message Secret对应信息（需替换）
        UMConfigure.init(
            ApplicationLike.instance,
            "5d00600d0cafb2ff67000edb",
            "Umeng",
            UMConfigure.DEVICE_TYPE_PHONE,
            "6b0b62b007c73051face8de7acd58757"
        )

        //获取消息推送代理示例
        val mPushAgent = PushAgent.getInstance(ApplicationLike.instance)
        mPushAgent.resourcePackageName = "com.xhd.td"
        mPushAgent.messageHandler = viewModel.messageHandler
        //使用自定义的NotificationHandler
        mPushAgent.notificationClickHandler = viewModel.notificationClickHandler
        //注册推送服务，每次调用register方法都会回调该接口
        mPushAgent.register(object : IUmengRegisterCallback {
            override fun onSuccess(deviceToken: String) {
                //注册成功会返回deviceToken deviceToken是推送消息的唯一标志
                XLog.i("注册成功：deviceToken：-------->  $deviceToken")

                viewModel.addDeviceToken(deviceToken)
            }

            override fun onFailure(s: String, s1: String) {
                XLog.e("注册失败：-------->  s:$s,s1:$s1")

            }
        })

    }

}
