package com.xhd.td.ui.unbind

import android.view.View
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.databinding.FragmentUnbindingBinding
import com.xhd.td.ui.home.SelectMerchantFragment
import com.xhd.td.ui.home.SelectMerchantFragment.Companion.UNBINDING_MERCHANT_DEVICE
import kotlinx.android.synthetic.main.fragment_unbinding.*
import kotlinx.android.synthetic.main.title_bar.*

/**
 * create by xuexuan
 * time 2019/4/4 17:12
 */

class UnbindFragment : BaseFragmentNoCb<FragmentUnbindingBinding, BaseViewModelNoCb>() {


    override val viewModel: BaseViewModelNoCb? = null
    override val bindingViewModel: Int get() = 0
    override val layoutId: Int get() = R.layout.fragment_unbinding


    override val bindingFragment: Int = BR.fragment

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "设备解绑"
        card_scan_unbinding.setOnClickListener {start(ScanUnbindDeviceFragment.newInstance()) }
        card_merchant_device_unbinding.setOnClickListener { start(SelectMerchantFragment.newInstance(UNBINDING_MERCHANT_DEVICE)) }
    }

    companion object {
        fun newInstance() = UnbindFragment()
    }
}