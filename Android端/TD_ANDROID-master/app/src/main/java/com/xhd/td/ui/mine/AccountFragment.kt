package com.xhd.td.ui.mine

import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentAccountBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.AccountDetailBean
import com.xhd.td.utils.TimeUtils.formatDataTime
import com.xhd.td.utils.gradeNameForMchTypeAndLevel
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.mine.AccountCB
import com.xhd.td.vm.mine.AccountVM
import kotlinx.android.synthetic.main.fragment_account.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class AccountFragment : BaseFragment<FragmentAccountBinding, AccountVM, AccountCB>(), AccountCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_account
    override val viewModel: AccountVM get() = ViewModelProviders.of(this, factory).get(AccountVM::class.java)


    override fun initView(view: View) {
        super.initView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "账户详情"

        //都不显示所属行业
        tv_industry_value.visibility = View.GONE
        tv_industry.visibility = View.GONE


        mViewDataBinding.userModel = UserModel

        if (UserModel.roleType != Constants.ROLY_TYPE_SALESMAN) {
            tv_account_type_value.text = UserModel.mchBean?.mchType?.let { gradeNameForMchTypeAndLevel(it, UserModel.mchBean?.level) }
            tv_industry_value.text = UserModel.mchBean?.industry
        }


        //业务员只用显示用户姓名 用户电话，

        //创建日期都显示
        tv_account_create_time.text =
            formatDataTime(UserModel.userBean?.createTime?.toLong() ?: return)
    }


    override fun handleError(throwable: Throwable) {

    }


    override fun getMyDetailSuccess(account: AccountDetailBean) {
        //该接口废弃中
    }

    override fun getMyDetailFail(msg: String) {
        //自动登陆失败，跳转到登录界面
        showToast(msg)
    }

    companion object {
        fun newInstance() = AccountFragment()
    }


}