package com.xhd.td.ui.income

import android.text.Html
import android.text.method.LinkMovementMethod
import android.view.View
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.constants.Constants
import com.xhd.td.model.bean.WithDrawResultBean
import kotlinx.android.synthetic.main.fragment_withdraw_detail.*
import kotlinx.android.synthetic.main.title_bar.*

/**
 * create by xuexuan
 * time 2019/4/4 16:24
 */
class WithdrawDetailFragment :
    BaseFragmentNoCb<com.xhd.td.databinding.FragmentWithdrawDetailBinding, BaseViewModelNoCb>() {

    private var mWithDrawResultBean: WithDrawResultBean? = null
    override val bindingViewModel: Int get() = 0
    override val layoutId: Int get() = R.layout.fragment_withdraw_detail
    override val viewModel: BaseViewModelNoCb? get() = null


    override val bindingFragment: Int = BR.fragment

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        toolBar.setNavigationOnClickListener { close() }
        title.text = "提现"
        mViewDataBinding.bean = mWithDrawResultBean

        if (mWithDrawResultBean?.isPublic == Constants.CARD_WECHAT_PAY){
            //如果微信零钱，

            tv_billing_number.visibility = View.GONE
            tv_billing_number_value.visibility = View.GONE

            tv_card.text = "提现方式"
            tv_card_no.text = mWithDrawResultBean?.bankName

            tv_account.text = "微信昵称"
            tv_account_value.text = mWithDrawResultBean?.accountName
        }else{
            //之所以在这里复制，没有在xml中使用databinding，是因为databinding的值会覆盖这里的值
            tv_card_no.text = mWithDrawResultBean?.bankId

        }

        tv_customer_service.text = Html.fromHtml("<font color='#76ADF0'><a href='tel:${getString(R.string.service_phone)}'>联系平台客服</a></font>")
        tv_customer_service.movementMethod = LinkMovementMethod.getInstance()

    }


    companion object {
        fun newInstance(bean: WithDrawResultBean) = WithdrawDetailFragment().apply {
            mWithDrawResultBean = bean
        }
    }
}