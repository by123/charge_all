package com.xhd.td.ui.home


import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.os.Bundle
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import kotlinx.android.synthetic.main.title_bar.*

class AddMerchantSuccessFragment :
    BaseFragmentNoCb<com.xhd.td.databinding.FragmentAddMerchantSuccessBinding, BaseViewModelNoCb>() {

    override val viewModel: BaseViewModelNoCb? = null

    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment

    override val layoutId: Int get() = R.layout.fragment_add_merchant_success


    var account: ObservableField<String>? = ObservableField()
    var pwd: ObservableField<String>? = ObservableField()
    var isMerchant: ObservableBoolean = ObservableBoolean(false)
    var merchantName: ObservableField<String>? = ObservableField()

    var mIsCopy = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        toolBar.setNavigationOnClickListener { close() }
        title.text = "添加成功"
        arguments?.apply {
            account?.set(this.getString(PARAM_ACCOUNT))
            pwd?.set(this.getString(PARAM_PWD))
            isMerchant.set(this.getBoolean(PARAM_IS_MERCHANT))
            merchantName?.set(this.getString(PARAM_MERCHANT_NAME))
        }
    }

    override fun close() {
        if (!mIsCopy && !isMerchant.get()) {
            //没有复制过，并且是创建代理商，在返回或者点击确定的时候，也复制账号和密码
            copy()
        }
        pop()
    }


    fun copy() {
        (activity?.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager).primaryClip = ClipData.newPlainText(
            "simple text copy",
            "登录账号:${account?.get()}\r\n初始密码:${pwd?.get()}"
        )
        showToast("账号和密码复制成功")
        mIsCopy = true
    }

    companion object {
        @JvmStatic
        fun newInstance(account: String?, pwd: String, isMerchant: Boolean = false, merchantName: String = "") =
            AddMerchantSuccessFragment().apply {
                arguments = Bundle().apply {
                    putString(PARAM_ACCOUNT, account)
                    putString(PARAM_PWD, pwd)
                    putBoolean(PARAM_IS_MERCHANT, isMerchant)
                    putString(PARAM_MERCHANT_NAME, merchantName)
                }
            }


        val PARAM_ACCOUNT = "param1"
        val PARAM_PWD = "param2"
        val PARAM_IS_MERCHANT = "param3"
        val PARAM_MERCHANT_NAME = "param4"
    }
}
