package com.xhd.td.ui.unbind

import android.view.View
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.databinding.FragmentUnbindResultBinding
import com.xhd.td.ui.MainFragment
import kotlinx.android.synthetic.main.fragment_unbind_result.*
import kotlinx.android.synthetic.main.title_bar.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class UnbindResultFragment : BaseFragmentNoCb<FragmentUnbindResultBinding, BaseViewModelNoCb>() {


    override val bindingViewModel: Int get() = 0
    override val viewModel: BaseViewModelNoCb? get() = null
    override val bindingFragment: Int? get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_unbind_result


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "按商户解绑设备"

        if (mResult) {
            //成功
            imageView.setImageResource(R.drawable.ic_result_success)
            tv_result.text = "解绑成功"
            tv_result_details.text = "解绑成功设备个数：$mDevicesNum"
        } else {
            //失败
            imageView.setImageResource(R.drawable.ic_result_fail)
            tv_result.text = "解绑失败：" + mResultMsg
            tv_result_details.text = "解绑失败设备个数：$mDevicesNum"
        }
    }


    var mResult: Boolean = false
    var mDevicesNum: Int = 0
    var mResultMsg: String? = null

    fun backHome() {
        popTo(MainFragment::class.java, false)
    }


    companion object {
        fun newInstance(result: Boolean, devicesNum: Int, resultMsg: String? = null) = UnbindResultFragment().apply {
            mResult = result
            mDevicesNum = devicesNum
            mResultMsg = resultMsg
        }
    }


}