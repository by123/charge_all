package com.xhd.td.ui.home

import android.view.View
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.home.FragmentTitleAdapter
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.databinding.FragmentPerformanceBinding
import kotlinx.android.synthetic.main.fragment_performance.*
import kotlinx.android.synthetic.main.title_bar.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class PerformanceFragment : BaseFragmentNoCb<FragmentPerformanceBinding, BaseViewModelNoCb>() {



    override val viewModel: BaseViewModelNoCb?
        get() = null

    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_performance


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        toolBar.setNavigationOnClickListener { close() }
        title.text = "业绩明细"

        viewPager.adapter = FragmentTitleAdapter(
            childFragmentManager,
            arrayOf(TotalActivateDeviceFragment.newInstance(true),TotalMerchantFragment.newInstance(true),TotalDeviceIncomeFragment.newInstance()),
            arrayOf( "激活设备数","开发商户数","设备收益")
        )
        //  设置tablayout 用来切换当前显示的fragment
        tabLayout_performance.setupWithViewPager(viewPager)
    }

    companion object {
        fun newInstance() = PerformanceFragment()
    }


}