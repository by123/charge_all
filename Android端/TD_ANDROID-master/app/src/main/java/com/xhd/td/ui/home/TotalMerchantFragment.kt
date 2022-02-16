package com.xhd.td.ui.home

import android.text.Html
import android.view.View
import android.widget.RadioGroup
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.adapter.home.TotalMerchantAdapter
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentTotalMerchantBinding
import com.xhd.td.model.bean.DevMchListBean
import com.xhd.td.model.bean.DevMchSum
import kotlinx.android.synthetic.main.fragment_total_merchant.*
import kotlinx.android.synthetic.main.title_bar.*



/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 *
 * 开发商户数 统计
 */

class TotalMerchantFragment :
    AbstractTotalFragment<DevMchListBean, TotalMerchantAdapter.ViewHolder, FragmentTotalMerchantBinding>() {

    override lateinit var mAdapter: SimpleRecAdapter<DevMchListBean, TotalMerchantAdapter.ViewHolder>

    lateinit var mRadioGroupSubordinateType: RadioGroup

    //直属拓展、下级拓展
    var mDevMchType: Int = 1

    override fun lazyInitView(view: View) {
        setSwipeBackEnable(false)
        toolBar.setNavigationOnClickListener { close() }
        title.text = "开发商户数"

        mAdapter = TotalMerchantAdapter(context!!){ showMchInfo(it) }
        tv_total_content.text = ""
        super.lazyInitView(view)

        mRadioGroupSubordinateType = view.findViewById(R.id.radio_group_subordinate_type)
        mRadioGroupSubordinateType.setOnCheckedChangeListener { group, checkedId ->

            when (checkedId) {
                R.id.radio_btn_subordinate_type_1 -> {
                    mDevMchType = TotalMerchantAdapter.DIRECT
                    (mAdapter as TotalMerchantAdapter).mDevelopType = TotalMerchantAdapter.DIRECT
                }

                R.id.radio_btn_subordinate_type_2 -> {
                    mDevMchType = TotalMerchantAdapter.DESCENDANT
                    (mAdapter as TotalMerchantAdapter).mDevelopType = TotalMerchantAdapter.DESCENDANT

                }
            }
            getTotalData(Constants.START_PAGE_ID)
        }

        mAdapter.recItemClick = object : RecyclerItemCallback<DevMchListBean, TotalMerchantAdapter.ViewHolder>() {
            override fun onItemClick(
                position: Int, model: DevMchListBean?,
                tag: Int, holder: TotalMerchantAdapter.ViewHolder?
            ) {
                super.onItemClick(position, model, tag, holder)
                if (mIsCurrentMerchant) {
                    (parentFragment as PerformanceFragment).start(
                        TotalMerchantFragment.newInstance(
                            false,
                            model?.mchId,
                            model?.mchName,
                            mStartTime,
                            mEndTime
                        )
                    )
                } else {
                    start(
                        TotalMerchantFragment.newInstance(
                            false, model?.mchId, model?.mchName,
                            mStartTime, mEndTime
                        )
                    )
                }
            }
        }
    }

    override fun getTotalData(pageId: Int,keyword:String?) {
        super.getTotalData(pageId,keyword)

        when (mDevMchType) {
            TotalMerchantAdapter.DIRECT -> viewModel.getDirectMchList(
                mStartTime, mEndTime,
                mMerchantId, keyword, pageId
            )

            TotalMerchantAdapter.DESCENDANT -> viewModel.getSubordinateMchList(
                mStartTime, mEndTime,
                mMerchantId, keyword, pageId
            )
        }
        viewModel.getDevMchTotal(mStartTime, mEndTime, mMerchantId)
    }


    override fun getDirectMchSuccess(list: List<DevMchListBean>) {

        setHideView(list.isEmpty())
        if (mPageId == Constants.START_PAGE_ID) {
            mAdapter.setData(list)
        } else {
            mAdapter.addData(list)
        }
    }

    override fun getSubordinateMchSuccess(list: List<DevMchListBean>) {

        setHideView(list.isEmpty())
        if (mPageId == Constants.START_PAGE_ID) {
            mAdapter.setData(list)
        } else {
            mAdapter.addData(list)
        }
    }


    override fun getDevMchTotalSuccess(sum: DevMchSum?) {

        var string = "直属拓展代理商:${sum?.directAgent}家   <font color='#DEDEDE'>丨</font>   直属拓展商户:${sum?.directTenant}家 <br/>" +
                "下级拓展代理商:${sum?.subordinateAgent}家   <font color='#DEDEDE'>丨</font>   下级拓展商户:${sum?.subordinateTenant}家"
        tv_total_content.text = Html.fromHtml(string)

    }

    override fun getMerchantFail(msg: String) {
        showToast(msg)
    }


    companion object {

        fun newInstance(
            isCurrentMerchant: Boolean, merchantId: String? = null, merchantName: String? = null,
            startTime: String? = null, endTime: String? = null
        ) = TotalMerchantFragment().apply {
            mIsCurrentMerchant = isCurrentMerchant
            merchantId?.let { mMerchantId = it }
            merchantName?.let { mMerchantName = it }
            startTime?.let { mStartTime = it }
            endTime?.let { mEndTime = it }

        }
    }
}