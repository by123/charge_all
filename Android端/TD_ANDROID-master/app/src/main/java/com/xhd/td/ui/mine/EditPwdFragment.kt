package com.xhd.td.ui.mine

import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentEditPwdBinding
import com.xhd.td.ui.MainFragment
import com.xhd.td.ui.login.LoginFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.mine.EditPwdCB
import com.xhd.td.vm.mine.EditPwdVM
import kotlinx.android.synthetic.main.fragment_edit_pwd.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class EditPwdFragment : BaseFragment<FragmentEditPwdBinding, EditPwdVM, EditPwdCB>(), EditPwdCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_edit_pwd
    override val viewModel: EditPwdVM get() = ViewModelProviders.of(this, factory).get(EditPwdVM::class.java)


    override fun initView(view: View) {
        super.initView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "修改密码"
    }


    fun submit(){

        //所有密码不为空
        val oldPwd = edit_old_pwd.text.toString()
        val newPwd = edit_new_pwd.text.toString()
        val newPwdAgain = edit_new_pwd_again.text.toString()

        if (oldPwd.isEmpty() || newPwd.isEmpty()|| newPwdAgain.isEmpty()){
            showToast("密码不能为空")
            return
        }
        //新密码和解密码相同
        if (newPwd != newPwdAgain){
            showToast("两次输入的密码不一致")
            return
        }
        viewModel.modifyPwd(oldPwd,newPwd,newPwdAgain)
    }


    override fun handleError(throwable: Throwable) {

    }


    override fun modifyFail(msg: String) {
        showToast(msg)
    }

    override fun modifySuccess(msg: String) {
        //修改成功，到登录界面，重新登录
        showToast("密码修改成功")
        startWithPopTo(LoginFragment.newInstance(), MainFragment::class.java, true)

    }

    companion object {
        fun newInstance() = EditPwdFragment()
    }


}