package com.xhd.td.ui

import android.Manifest
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import androidx.lifecycle.ViewModelProviders
import com.elvishew.xlog.XLog
import com.xhd.td.BR
import com.xhd.td.BuildConfig
import com.xhd.td.R
import com.xhd.td.base.BaseActivity
import com.xhd.td.databinding.ActivityMainBinding
import com.xhd.td.ui.login.SplashFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.LoginCallback
import com.xhd.td.vm.login.LoginVM
import me.yokeyword.fragmentation.anim.DefaultHorizontalAnimator
import me.yokeyword.fragmentation.anim.FragmentAnimator
import pub.devrel.easypermissions.AfterPermissionGranted
import pub.devrel.easypermissions.EasyPermissions
import javax.inject.Inject


/**
 * 主Activity，所以fragment都是在这个Activity基础上
 * Created by 薛瑄.
 */
class MainActivity : BaseActivity<ActivityMainBinding, LoginVM, LoginCallback>(), LoginCallback, EasyPermissions.PermissionCallbacks {

    @Inject
    lateinit var factory: ViewModelProviderFactory

    override val bindingVariable: Int get() = BR.viewModel
    override val layoutId: Int get() = R.layout.activity_main
    override val viewModel: LoginVM get() = ViewModelProviders.of(this, factory).get(LoginVM::class.java)

    override fun initView() {

        viewModel.mCallback = this

//        问题：小米手机，
//        1、把apk发到手机上，点击apk安装，然后弹出安装成功的界面，
//        2、点击打开，开启app
//        3、点击home
//        4、再次点击app图标打开app，
//        这时堆栈中会出现多个app的实例，返回的时候，需要多次退出
//        这段代码就是解决这个问题，
        if (!this.isTaskRoot) {
            val intent = intent
            if (intent != null) {
                val action = intent.action
                if (intent.hasCategory(Intent.CATEGORY_LAUNCHER) && Intent.ACTION_MAIN == action) {
                    finish()
                    return
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            //兼容5.0及以上支持全透明
            this.window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            this.window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            this.window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            this.window.statusBarColor = Color.TRANSPARENT
        }

        requestPermissions()
        //在内存发生重启的时候，findFragment 查找对应的fragment不为空，可以进行恢复,因为SplashFragment是会被退出的，
        // 所以不能根据SplashFragment判断内存是否重启
        if (findFragment(MainFragment::class.java) == null) {
            loadRootFragment(R.id.fl_container, SplashFragment.newInstance())
        }

    }


    override fun initData(savedInstanceState: Bundle?) {
        if (savedInstanceState != null) {
            if (savedInstanceState.getBoolean(MainActivity.FORCE_KILLED)) {
                XLog.i("程序被异常中断，恢复UserModel数据")
                viewModel.setUserModelForLocal()
                if (BuildConfig.DEBUG) {
                    showToast("程序异常中断恢复成功")
                }
            }
        }
    }



    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        //如果是被异常终止，这里给个标志，在再次打开的时候，主要把用户数据userModel重新找回
        XLog.d("程序被异常中断，设置标志位")
        outState.putBoolean(MainActivity.FORCE_KILLED, true)
    }


    override fun handleError(throwable: Throwable) {

    }

    override fun onBackPressedSupport() {
        // 对于 4个类别的主Fragment内的回退back逻辑,已经在其onBackPressedSupport里各自处理了
        super.onBackPressedSupport()
        XLog.d("调用了mainActivity的onBackPressedSupport")

    }

    override fun onCreateFragmentAnimator(): FragmentAnimator {
        // 设置横向(和安卓4.x动画相同)
        return DefaultHorizontalAnimator()
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this)
    }

    override fun onPermissionsGranted(requestCode: Int, perms: List<String>) {
    }

    override fun onPermissionsDenied(requestCode: Int, perms: List<String>) {
        finish()
    }

    @AfterPermissionGranted(Companion.REQUEST_CODE_PERMISSIONS)
    fun requestPermissions() {
        val perms = arrayOf(
            Manifest.permission.CAMERA,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.ACCESS_FINE_LOCATION
        )
        if (!EasyPermissions.hasPermissions(this, *perms)) {
            EasyPermissions.requestPermissions(this, "请授予APP权限", Companion.REQUEST_CODE_PERMISSIONS, *perms)
        }
    }


    companion object {
        private const val FORCE_KILLED = "force_killed"

        const val REQUEST_CODE_PERMISSIONS = 1
    }

}
