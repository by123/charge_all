package com.xhd.td.ui.login

import android.os.Bundle
import android.os.CountDownTimer
import android.text.InputType
import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.tencent.bugly.crashreport.BuglyLog
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentForgetPwdBinding
import com.xhd.td.model.bean.ChangePwdBean
import com.xhd.td.model.bean.VerifyCodeBean
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.ForgetPwdCallback
import com.xhd.td.vm.login.ForgetPwdVM
import kotlinx.android.synthetic.main.fragment_forget_pwd.*
import javax.inject.Inject

/**
 * create by xuexuan
 * time 2019/3/19 14:21
 */
class ForgetPwdFragment : BaseFragment<FragmentForgetPwdBinding, ForgetPwdVM, ForgetPwdCallback>(),
    ForgetPwdCallback {


    @Inject
    lateinit var factory: ViewModelProviderFactory

    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_forget_pwd
    override val viewModel: ForgetPwdVM get() = ViewModelProviders.of(this, factory).get(ForgetPwdVM::class.java)
    //用于标识当前界面是什么状态，0：输入账号，1：输入验证码  2：输入密码
    private var mCurrentPage = 0
    private var mTime: Int = 60
    private var mAccount: String? = null //获取验证码，修改密码都需要账号
    private lateinit var mVerifyResult: String //验证码验证成功后，得到的字段，用于修改密码用

    private var mTimer = MyTimeCount(60000, 1000)

    override fun onLazyInitView(savedInstanceState: Bundle?) {
        super.onLazyInitView(savedInstanceState)
        viewModel.mCallback = this
    }

    //获取验证码
    fun getSMSCode() {

        mAccount = edit_account.text?.trim().toString()

        if (mAccount.isNullOrEmpty()) {
            showToast("请输入账号")
        } else {
            viewModel.getSMSCode(mAccount!!)
        }
    }

    //验证短信验证码
    fun verifyCode() {

        if (edit_account.text?.isEmpty() == true) {
            showToast("请输入验证码")
            return
        }
        viewModel.verifyCode(VerifyCodeBean(edit_account.text?.trim().toString(), mAccount!!))
    }

    //修改密码
    fun changePwd() {


        if (edit_account.text?.isEmpty() == true || edit_pwd_again.text?.isEmpty() == true) {
            showToast("请输入新密码")
            return
        }
        if (edit_account.text.toString().trim() != edit_pwd_again.text.toString().trim()) {
            showToast("两次密码不一致")
            return
        }


        if (edit_account.text?.length ?: 0 < 6 || edit_pwd_again.text?.length ?: 0 < 6) {
            showToast("密码长度不能少于6位")
            return
        }

        viewModel.changePwd(
            ChangePwdBean(
                edit_account.text.toString(),
                edit_pwd_again.text.toString(),
                mVerifyResult,
                mAccount!!
            )
        )
    }

    //重新发送验证码
    fun resend() {
        getSMSCode()
    }


    //点击下一步的回调函数
    fun next(view: View) {
        when (mCurrentPage) {
            0 -> {
                getSMSCode()
            }
            1 -> {
                verifyCode()
            }
            2 -> changePwd()
        }
    }

    override fun getCodeSuccess(phone: String) {
        //获取验证码成功
        mViewDataBinding.displayHint = true
        tv_resend.visibility = View.VISIBLE
        tv_resend.isClickable = false
        tv_top_hint.text = "验证码已发送至账号关联手机($phone)"

        mTimer.start()
        input_layout_account.hint = "请输入验证码"
        edit_account.setText("")
        edit_account.requestFocus()
        mCurrentPage = 1
    }

    override fun getCodeFail(msg: String) {
        showToast("获取验证码失败:${msg}")
    }

    override fun verifyCodeSuccess(result: String) {
        mVerifyResult = result
        //改变状态，再次点击下一步，显示
        mCurrentPage = 2
        tv_resend.visibility = View.GONE
        tv_top_hint.text = "验证通过，请设置您的新密码"
        input_layout_account.hint = "请输入新密码，不少于六位"
        input_layout_account.isPasswordVisibilityToggleEnabled = true
        input_layout_pwd_again.visibility = View.VISIBLE
        input_layout_pwd_again.isPasswordVisibilityToggleEnabled = true
        tv_next.text = "完成"
        edit_account.setText("")
        edit_account.inputType = InputType.TYPE_TEXT_VARIATION_PASSWORD or InputType.TYPE_CLASS_TEXT
        edit_pwd_again.inputType = InputType.TYPE_TEXT_VARIATION_PASSWORD or InputType.TYPE_CLASS_TEXT

    }

    override fun verifyCodeFail(msg: String) {
        showToast("验证码校验失败:${msg}")
    }


    override fun modifyPwdSuccess() {
        //修改密码成功
        showToast("修改成功")
        pop()
    }

    override fun modifyPwdFail(msg: String) {
        //修改密码失败
        showToast("修改密码错误:${msg}")
    }


    override fun onDestroyView() {
        mTimer.cancel()
        super.onDestroyView()
    }

    companion object {
        @JvmStatic
        fun newInstance(): ForgetPwdFragment {
            val args = Bundle()
            val fragment = ForgetPwdFragment()
//        fragment.set(args)
            return fragment
        }
    }

    inner class MyTimeCount(millisInFuture: Long, countDownInterval: Long) :
        CountDownTimer(millisInFuture, countDownInterval) {

        override fun onTick(millisUntilFinished: Long) {
            tv_resend.isClickable = false
            tv_resend.text = (millisUntilFinished / 1000).toString() + "秒"
        }

        override fun onFinish() {
            tv_resend.text = "重新发送"
            tv_resend.isClickable = true
        }
    }


    //以下代码暂时没用
    val mTimerThread = object : Thread() {
        public override fun run() {
            try {
                timer()
            } catch (e: Exception) {
                //结束线程
                BuglyLog.i("forgetPwdFragment", "线程错误$e")
            }
        }
    }

    private tailrec fun timer() {//使用尾递归，实现一个倒计时
        if (--mTime != 0) {
            tv_resend.post { tv_resend.text = "${mTime}秒" }
            Thread.sleep(1000)
        } else {
            tv_resend.post { tv_resend.text = "重新发送";tv_resend.isClickable = true }
            mTime = 60

            return
        }
        timer()
    }

}