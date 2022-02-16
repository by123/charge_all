package com.xhd.td.ui.income

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.AbstractMerchantCallback
import com.xhd.td.vm.home.AbstractMerchantVM
import kotlinx.android.synthetic.main.fragment_cash_help.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject

/**
 * create by xuexuan
 * time 2019/4/3 15:52
 */
class CapitalHelpFragment :
    BaseFragment<com.xhd.td.databinding.FragmentCashHelpBinding, AbstractMerchantVM, AbstractMerchantCallback>(),
    AbstractMerchantCallback {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_cash_help
    override val viewModel: AbstractMerchantVM
        get() = ViewModelProviders.of(this, factory).get(
            AbstractMerchantVM::class.java
        )

    lateinit var mAdapter: IncomeListAdapter

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "资金帮助"
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getConfig(Constants.CFG_CAPITAL_HELP)
    }


    override fun getConfigSuccess(key: String, data: String?) {
        tv_content.text = data
    }

    override fun getConfigFail(msg: String?) {
        msg?.let { showToast(it) }
    }

    companion object {
        fun newInstance() = CapitalHelpFragment()
    }

}

