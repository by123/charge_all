package com.xhd.td.ui.mine

import android.text.method.ScrollingMovementMethod
import android.view.View
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.databinding.FragmentUserProtocolBinding
import kotlinx.android.synthetic.main.fragment_user_protocol.*
import kotlinx.android.synthetic.main.title_bar.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class UserProtocolFragment : BaseFragmentNoCb<FragmentUserProtocolBinding, BaseViewModelNoCb>() {


    override val bindingViewModel: Int get() = 0
    override val viewModel: BaseViewModelNoCb? get() = null
    override val layoutId: Int get() = R.layout.fragment_user_protocol


    override fun initView(view: View) {
        super.initView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "用户协议"
        tv_content.movementMethod = ScrollingMovementMethod.getInstance()
    }

    companion object {
        fun newInstance() = UserProtocolFragment()
    }


}