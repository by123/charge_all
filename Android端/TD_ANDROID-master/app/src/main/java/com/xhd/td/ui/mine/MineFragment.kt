package com.xhd.td.ui.mine

import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentMineBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.Bank
import com.xhd.td.ui.MainFragment
import com.xhd.td.ui.mine.bank.CardDetailFragment
import com.xhd.td.ui.mine.bank.CardListFragment
import com.xhd.td.ui.unbind.UnbindFragment
import com.xhd.td.ui.whitelist.WhitelistFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.AbstractMerchantCallback
import com.xhd.td.vm.home.AbstractMerchantVM
import com.xhd.td.vm.home.AgentAndChainVM
import kotlinx.android.synthetic.yellow.fragment_mine.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class MineFragment : BaseFragment<FragmentMineBinding, AbstractMerchantVM, AbstractMerchantCallback>(),AbstractMerchantCallback {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val viewModel: AgentAndChainVM
        get() = ViewModelProviders.of(this, factory).get(AgentAndChainVM::class.java)
    override val bindingViewModel: Int get() = 0
    override val bindingFragment: Int = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_mine
    override var mHasToolbar = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        setSwipeBackEnable(false)

        viewModel.mCallback = this
        if (UserModel.roleType == Constants.ROLY_TYPE_ADMIN) {//普通管理员，就是代理的账号
            mine_name.text = UserModel.mchBean?.mchName
            mine_count.text = resources.getText(R.string.mine).toString() + UserModel.mchBean?.mchId
        } else {

            mine_name.text = UserModel.userBean?.name
            mine_count.text = resources.getText(R.string.mine).toString() + UserModel.userBean?.mobile
        }

        if (UserModel.roleType == Constants.ROLY_TYPE_SALESMAN) {
            //业务员，不显示银行卡
            layout_bank_card.visibility = View.GONE
        }


        layout_account.setOnClickListener { (parentFragment as MainFragment).startBrotherFragment(AccountFragment.newInstance()) }
        layout_bank_card.setOnClickListener { (parentFragment as MainFragment).startBrotherFragment(CardListFragment.newInstance(CardListFragment.TYPE_VIEW_CARD_LIST){params: Bank,wechatInfo -> (parentFragment as MainFragment).startBrotherFragment(CardDetailFragment.newInstance(params))})}
        layout_agent.setOnClickListener { (parentFragment as MainFragment).startBrotherFragment(AgentManageFragment.newInstance()) }
        layout_whitelist.setOnClickListener { (parentFragment as MainFragment).startBrotherFragment(WhitelistFragment.newInstance()) }
        layout_message_center.setOnClickListener { (parentFragment as MainFragment).startBrotherFragment(MessageListFragment.newInstance()) }
        layout_setting.setOnClickListener {  (parentFragment as MainFragment).startBrotherFragment(SettingFragment.newInstance())  }
        layout_unbinding.setOnClickListener {  (parentFragment as MainFragment).startBrotherFragment(UnbindFragment.newInstance())  }
    }


    override fun getConfigSuccess(key:String,data: String?) {
        UserModel.whitelist = Gson().fromJson<List<String>>(data, object : TypeToken<List<String>>() {}.type)
        if (UserModel.whitelist.contains(UserModel.mchBean?.mchId)){
            layout_whitelist.visibility = View.VISIBLE
        }else{
            layout_whitelist.visibility = View.GONE
        }
    }

    override fun getConfigFail(msg: String?) {

    }

    companion object {
        fun newInstance() = MineFragment()
    }


}