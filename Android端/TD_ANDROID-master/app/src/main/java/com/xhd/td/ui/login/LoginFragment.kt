package com.xhd.td.ui.login

import android.view.View
import android.widget.Toast
import androidx.lifecycle.ViewModelProviders
import com.elvishew.xlog.XLog
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentLoginBinding
import com.xhd.td.ui.MainFragment
import com.xhd.td.ui.MainFragment.Companion.WAIT_TIME
import com.xhd.td.ui.mine.UserProtocolFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.LoginCallback
import com.xhd.td.vm.login.LoginVM
import kotlinx.android.synthetic.main.fragment_login.*
import javax.inject.Inject

/**
 * create by xuexuan
 * time 2019/3/18 19:28
 */
class LoginFragment : BaseFragment<FragmentLoginBinding, LoginVM, LoginCallback>(), LoginCallback {


    @Inject
    lateinit var factory: ViewModelProviderFactory

    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_login
    override val viewModel: LoginVM get() = ViewModelProviders.of(this, factory).get(LoginVM::class.java)
    override var mHasToolbar = false


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        setSwipeBackEnable(false)
        viewModel.mCallback = this
        edit_account.apply { setText(viewModel.getAccount()) }
        edit_pwd.apply { setText(viewModel.getPwd()) }
    }

    //忘记密码的回调函数
    fun forgetPwd(){
        start(ForgetPwdFragment.newInstance())
    }

    fun toUserProtocol(){
        start(UserProtocolFragment.newInstance())
    }

    override fun handleError(throwable: Throwable) {

    }

    override fun loginFail(msg:String) {
        //自动登陆失败，跳转到登录界面
        showToast(msg)
//        startWithPop(LoginFragment.newInstance())
    }

    override fun loginSuccess() {
        //登录成功，界面跳转
        startWithPopTo(MainFragment.newInstance(), LoginFragment::class.java, true)
    }

    private var TOUCH_TIME: Long = 0

    override fun onBackPressedSupport(): Boolean {

        if (System.currentTimeMillis() - TOUCH_TIME < WAIT_TIME) {
            _mActivity.finish()
        } else {
            TOUCH_TIME = System.currentTimeMillis()
            Toast.makeText(context, R.string.press_again_exit, Toast.LENGTH_SHORT).show()
        }
        XLog.d("调用了mainFragment的onBackPressedSupport")
        //返回true，表示已经处理，不会再回调上一级的onBackPressedSupport，在这里也就是不会再回调mainActivity的onBackPressedSupport
        return true
    }


    companion object {
        @JvmStatic
        fun newInstance(): LoginFragment = LoginFragment()
    }

}