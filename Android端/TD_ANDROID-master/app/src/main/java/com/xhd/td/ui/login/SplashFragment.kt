package com.xhd.td.ui.login

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.elvishew.xlog.XLog
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentSplashBinding
import com.xhd.td.ui.MainFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.LoginCallback
import com.xhd.td.vm.login.LoginVM
import javax.inject.Inject
import kotlin.properties.Delegates
import kotlin.reflect.KProperty

/**
 * create by xuexuan
 * time 2019/3/19 13:44
 */

class SplashFragment : BaseFragment<FragmentSplashBinding, LoginVM, LoginCallback>(), LoginCallback {

    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val layoutId: Int get() = R.layout.fragment_splash
    override val viewModel: LoginVM get() = ViewModelProviders.of(this, factory).get(LoginVM::class.java)
    override var mHasToolbar = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
    }

    var mJumpType by Delegates.observable(-1) { kProperty: KProperty<*>, s: Int, s1: Int ->
        jumpUI()
    }


    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)

        XLog.i("$this + initdata")

        val account = viewModel.getAccount()
        val pwd = viewModel.getPwd()
        XLog.i("账号:${account},密码:${pwd},自动登录")

        if (account != null && pwd != null) {
            //如果账号密码不为空，自动登录
            viewModel.login(account, pwd)
        } else if (viewModel.getToken() != null) {
            XLog.i("Token 不为空，跳转到主界面")
            viewModel.setUserModelForLocal()
        } else {
            //账号密码任意一个为空，跳转到登录界面
            XLog.i("跳到登陆界面")
            mJumpType = TO_LOGIN
        }
    }


    override fun handleError(throwable: Throwable) {
        mJumpType = TO_LOGIN
    }

    override fun loginFail(msg: String) {
        //自动登陆失败，跳转到登录界面
        XLog.i("自动登录失败，跳转到登录界面")
        mJumpType = TO_LOGIN
    }

    override fun loginSuccess() {
        //登录成功，界面跳转
        XLog.i("自动登录成功，跳转到主界面")
        mJumpType = TO_MAIN
    }


    override fun jumpToMain() {
        mJumpType = TO_MAIN
    }

    fun jumpUI() {

        when (mJumpType) {
            TO_LOGIN -> {
                XLog.i("启动登录界面")
                //很奇怪的问题，使用下面这两个语句，很大情况会出现，栈已经更新了，ui跳转不了
//                startWithPop(LoginFragment.newInstance())
//                startWithPopTo(LoginFragment.newInstance(), SplashFragment::class.java, true)
//                pop()
                start(LoginFragment.newInstance())
            }
            TO_MAIN -> {
                XLog.i("启动主界面")
                startWithPopTo(MainFragment.newInstance(), SplashFragment::class.java, true)
            }
            else -> {
                XLog.i("启动登录界面")
//                pop()
                start(LoginFragment.newInstance())
            }

        }

    }


    companion object {
        @JvmStatic
        fun newInstance(): SplashFragment {
            val args = Bundle()
            val fragment = SplashFragment()
//        fragment.set(args)
            return fragment
        }

        val TO_LOGIN = 1
        val TO_MAIN = 2
    }


}