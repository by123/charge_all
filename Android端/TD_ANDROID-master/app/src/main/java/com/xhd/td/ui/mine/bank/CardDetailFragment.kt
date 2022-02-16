package com.xhd.td.ui.mine.bank

import android.view.View
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentCardDetailBinding
import com.xhd.td.model.bean.Bank
import kotlinx.android.synthetic.main.fragment_card_detail.*
import kotlinx.android.synthetic.main.title_bar.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class CardDetailFragment : BaseFragmentNoCb<FragmentCardDetailBinding, BaseViewModelNoCb>() {


    override val bindingViewModel: Int get() = 0
    override val viewModel: BaseViewModelNoCb? get() = null
    override val layoutId: Int get() = R.layout.fragment_card_detail

    private lateinit var mBankCardBean: Bank

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "银行卡详情"
        mViewDataBinding.bean = mBankCardBean
        mViewDataBinding.isCompany = mBankCardBean.isPublic == Constants.CARD_COMPANY

        if (mBankCardBean.isPublic == Constants.CARD_WECHAT_PAY){
            //如果微信零钱
            cardTypeValue.text = "微信零钱"
            cardName.text = "微信昵称："

        }else{
            //之所以在这里复制，没有在xml中使用databinding，是因为databinding的值会覆盖这里的值
            cardName.text = "账户名称："
            cardTypeValue.text = if (mBankCardBean.isPublic == Constants.CARD_COMPANY)getString(R.string.company_card) else getString(R.string.person_card)
        }

    }


    companion object {
        fun newInstance(cardInfoBean: Bank) = CardDetailFragment().apply {
            mBankCardBean = cardInfoBean
        }
    }


}