package com.xhd.td.ui.mine.bank

import android.view.View
import android.widget.RadioButton
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentSelectBankAddCardBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.BankCardWithDrawRule
import com.xhd.td.ui.social.SocialFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.income.WithdrawCB
import com.xhd.td.vm.income.WithdrawVM
import kotlinx.android.synthetic.main.title_bar.*
import kotlinx.android.synthetic.yellow.fragment_select_bank_add_card.*
import javax.inject.Inject

/**
 * create by xuexuan
 * time 2019/4/4 17:12
 */

class SelectBankAddCardFragment : BaseFragment<FragmentSelectBankAddCardBinding, WithdrawVM, WithdrawCB>(), WithdrawCB {

    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = 0
    override val layoutId: Int get() = R.layout.fragment_select_bank_add_card
    override val viewModel: WithdrawVM? get() = ViewModelProviders.of(this, factory).get(WithdrawVM::class.java)

    override val bindingFragment: Int = BR.fragment

    var mRadioButtion: RadioButton? = null
    var mHasWechat = false
    var mHasPersonCard = false
    var mHasCompanyCard = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "添加银行卡"
        radio_button_company.setOnCheckedChangeListener { buttonView, isChecked ->  if (isChecked){mRadioButtion?.isChecked = false; mRadioButtion = radio_button_company}}
        radio_button_personal.setOnCheckedChangeListener { buttonView, isChecked ->  if (isChecked){mRadioButtion?.isChecked = false; mRadioButtion = radio_button_personal}}
        radio_button_wechat_pay.setOnCheckedChangeListener { buttonView, isChecked ->  if (isChecked){mRadioButtion?.isChecked = false; mRadioButtion = radio_button_wechat_pay}}
        viewModel?.mCallback = this
//        viewModel?.getWithdrawRuleAll(UserModel.mchBean?.mchType?:0)
        //获取起提金额
        viewModel?.getConfig(Constants.CFG_WITHDRAW_START_NUM, UserModel.mchBean?.mchType.toString())
    }


    fun addCard() {

        val type: Int
        when {
            radio_button_company.isChecked -> {
                type = Constants.CARD_COMPANY
                startWithPop(AddCardFragment.newInstance(type))

            }
            radio_button_personal.isChecked -> {
                type = Constants.CARD_PERSONAL
                startWithPop(AddCardFragment.newInstance(type))

            }
            radio_button_wechat_pay.isChecked -> {
                type = Constants.CARD_WECHAT_PAY
                //启动微信授权登录界面
                startWithPop(SocialFragment.newInstance(mMinLimitWithdraw))
            }

            else -> {
                showToast("请选择银行卡类型")
            }
        }
    }

    private var mMinLimitWithdraw:Double = 1.0

    override fun getConfigSuccess(data: String?, key: String) {

        when (key) {
            //获取起提金额
            Constants.CFG_WITHDRAW_START_NUM -> {
                mMinLimitWithdraw = data?.toDouble()?.div(100) ?: 0.0
                //新的配置，起提金额部分渠道，微信，对公，对私银行起提金额一样
                tv_wechat_pay_tip.text = mMinLimitWithdraw.toString() + "元起提，实时到账"
                tv_personal_tip.text = mMinLimitWithdraw.toString() + "元起提，3个工作日到账"
                tv_company_tip.text = mMinLimitWithdraw.toString() + "元起提，3个工作日到账"
            }
        }

    }

    override fun getConfigFail(msg: String?) {
        msg?.let { showToast(it) }
    }


    override fun getWithdrawRuleAllSuccess(bean: List<BankCardWithDrawRule>) {

        //channel == 1 是微信的提现规则
        //如果是平台的账号，是没有channel == 1的提现规则
        val wechatRule = bean.firstOrNull { it.channel == 1 }
        tv_wechat_pay_tip.text = wechatRule?.withdrawStartNumYuan?.toInt().toString() + "元起提，实时到账"

        //channel == 0 是连连的提现规则
        val bankCardWithDrawRule = bean.firstOrNull { it.channel == 0 }
        //对公和对私的起体金额是一样的
        tv_personal_tip.text = bankCardWithDrawRule?.withdrawStartNumYuan?.toInt().toString() + "元起提，3个工作日到账"
        tv_company_tip.text = bankCardWithDrawRule?.withdrawStartNumYuan?.toInt().toString() + "元起提，3个工作日到账"

    }

    override fun getWithdrawRuleAllFail(msg: String?) {
        msg?.let { showToast(it) }
    }

    companion object {
        fun newInstance(hasWechat: Boolean = false, hasPersonCard: Boolean = false, hasCompanyCard: Boolean = false) =
            SelectBankAddCardFragment().apply {
                mHasWechat = hasWechat
                mHasPersonCard = hasPersonCard
                mHasCompanyCard = hasCompanyCard
            }
    }
}