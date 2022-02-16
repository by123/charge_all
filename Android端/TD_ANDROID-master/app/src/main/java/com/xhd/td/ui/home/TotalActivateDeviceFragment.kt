package com.xhd.td.ui.home

import android.view.View
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentTotalMerchantBinding
import com.xhd.td.model.bean.ActiveDeviceListBean
import com.xhd.td.model.bean.ActiveDeviceSum
import kotlinx.android.synthetic.main.fragment_total_merchant.*
import kotlinx.android.synthetic.main.title_bar.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 *
 * 激活设备数统计
 */

class TotalActivateDeviceFragment :
    AbstractTotalFragment<ActiveDeviceListBean, TotalActivateDeviceAdapter.ViewHolder, FragmentTotalMerchantBinding>() {


    override lateinit var mAdapter: SimpleRecAdapter<ActiveDeviceListBean, TotalActivateDeviceAdapter.ViewHolder>

    override fun lazyInitView(view: View) {
        setSwipeBackEnable(false)
        toolBar.setNavigationOnClickListener { close() }
        title.text = "激活设备数"
        mAdapter = TotalActivateDeviceAdapter(context!!) { showMchInfo(it) }
        tv_total_content.text = ""
        super.lazyInitView(view)
        radio_group_subordinate_type.visibility = View.GONE


        mAdapter.recItemClick =
            object : RecyclerItemCallback<ActiveDeviceListBean, TotalActivateDeviceAdapter.ViewHolder>() {
                override fun onItemClick(
                    position: Int,
                    model: ActiveDeviceListBean?,
                    tag: Int,
                    holder: TotalActivateDeviceAdapter.ViewHolder?
                ) {
                    super.onItemClick(position, model, tag, holder)
                    if (mIsCurrentMerchant) {
                        (parentFragment as PerformanceFragment).start(
                            TotalActivateDeviceFragment.newInstance(
                                false,
                                model?.mchId,
                                model?.mchName,
                                mStartTime,
                                mEndTime
                            )
                        )
                    } else {
                        start(
                            TotalActivateDeviceFragment.newInstance(
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

        viewModel.getActiveDeviceReport(mStartTime, mEndTime, mMerchantId, keyword, pageId)
        viewModel.getActiveDeviceSum(mStartTime, mEndTime, mMerchantId, keyword)
    }

    override fun getActivateDeviceSuccess(list: List<ActiveDeviceListBean>) {

        setHideView(list.isEmpty())

        if (mPageId == Constants.START_PAGE_ID) {
            mAdapter.setData(list)
        } else {
            mAdapter.addData(list)
        }
    }


    override fun getActivateDeviceSumSuccess(sum: ActiveDeviceSum?) {
        super.getActivateDeviceSumSuccess(sum)
        tv_total_content.text = "设备激活总数：${sum?.sum}个"
    }

    companion object {

        fun newInstance(
            isCurrentMerchant: Boolean, merchantId: String? = null, merchantName: String? = null,
            startTime: String? = null, endTime: String? = null
        ) = TotalActivateDeviceFragment().apply {
            mIsCurrentMerchant = isCurrentMerchant
            merchantId?.let { mMerchantId = it }
            merchantName?.let { mMerchantName = it }
            startTime?.let { mStartTime = it }
            endTime?.let { mEndTime = it }

        }

    }


}