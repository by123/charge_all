package com.xhd.td.ui.home

import android.text.Html
import android.view.View
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.adapter.home.TotalDeviceIncomeAdapter
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentTotalMerchantBinding
import com.xhd.td.model.bean.EarningDetailDeveloperBeam
import kotlinx.android.synthetic.main.fragment_total_merchant.*


/**
 * create by xuexuan
 * time 2019/4/3 15:01
 */

class TotalDeviceIncomeFragment :
    AbstractTotalFragment<EarningDetailDeveloperBeam, TotalDeviceIncomeAdapter.ViewHolder, FragmentTotalMerchantBinding>() {


    override lateinit var mAdapter: SimpleRecAdapter<EarningDetailDeveloperBeam, TotalDeviceIncomeAdapter.ViewHolder>

    override fun lazyInitView(view: View) {
        setSwipeBackEnable(false)
        mAdapter = TotalDeviceIncomeAdapter(context!!)
        tv_total_content.text = ""
        super.lazyInitView(view)

        search_view.visibility = View.GONE
        view_search_view.visibility = View.GONE
        view_top.visibility = View.GONE
        radio_group_subordinate_type.visibility = View.GONE
    }

    override fun getTotalData(pageId: Int,keyword:String?) {
        viewModel.getDeviceIncome("$mStartTime 00:00:00", "$mEndTime 23:59:59", pageId)

    }

    override fun getDeviceRevenueSuccess(list: List<EarningDetailDeveloperBeam>, orderNum: Int, income: String) {

        if (mPageId == Constants.START_PAGE_ID) {
            mAdapter.setData(list)
        } else {
            mAdapter.addData(list)
        }

        val string = "订单：${orderNum}笔   <font color='#DEDEDE'>丨</font>  设备收益：${income}元"
        tv_total_content.text = Html.fromHtml(string)
    }


    companion object {
        fun newInstance() = TotalDeviceIncomeFragment().apply {
            mIsCurrentMerchant = true
        }
    }


}