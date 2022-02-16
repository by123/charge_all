package com.xhd.td.ui.mine

import android.view.View
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.data.DataManager
import com.xhd.td.model.UserModel
import com.xhd.td.ui.MainFragment
import com.xhd.td.ui.login.LoginFragment
import com.xhd.td.vm.ViewModelProviderFactory
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class SettingFragment : BaseFragmentNoCb<com.xhd.td.databinding.FragmentSettingBinding, BaseViewModelNoCb>() {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_setting
    override val viewModel: BaseViewModelNoCb? get() = null

    @Inject
    lateinit  var dataManager:DataManager

    override fun initView(view: View) {
        super.initView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "APP设置"
    }

    /**
     * 修改密码
     */
    fun editPwd(){
        start(EditPwdFragment.newInstance())
    }


    /**
     * 关于我们
     */
    fun about(){
        start(AboutFragment.newInstance())
    }


    /**
     * 退出登录
     */
    fun signOut(){

        //是否自动登录
        UserModel.grayscaleUpdate = null
        dataManager.setUserAsLoggedOut()
        startWithPopTo(LoginFragment.newInstance(), MainFragment::class.java, true)

    }



    companion object {
        fun newInstance() = SettingFragment()
    }


}