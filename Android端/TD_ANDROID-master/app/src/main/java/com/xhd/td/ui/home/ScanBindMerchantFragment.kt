package com.xhd.td.ui.home

import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.elvishew.xlog.XLog
import com.google.gson.Gson
import com.xhd.td.model.bean.BindMerchantBean
import com.xhd.td.ui.home.SelectMerchantFragment.Companion.BIND_MERCHANT
import com.xhd.td.vm.home.ScanVM
import kotlinx.android.synthetic.main.fragment_abstract_scan_qr.*

/**
 * create by xuexuan
 * time 2019/4/2 10:37
 */
class ScanBindMerchantFragment : AbstractScanQRFragment<ScanVM>() {


    override val viewModel: ScanVM get() = ViewModelProviders.of(this, factory).get(ScanVM::class.java)

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        tv_activate_device_num.visibility = View.GONE
        btn_finish.visibility = View.GONE
        tv_title.text = "绑定商户"
        tv_scan_tip.text = "请扫描商户二维码"
    }

    var mBindMerchantBean: BindMerchantBean? = null


    /**
     *扫描商户的公众号二维码成功
     */
    override fun scanSuccess(result: String) {

        try {
            mBindMerchantBean = Gson().fromJson<BindMerchantBean>(result, BindMerchantBean::class.java)
        } catch (e: Exception) {
            XLog.d("解析出错$result")
        }

        if (mBindMerchantBean != null) {
            dialog.showWithStatus("扫码成功，正在绑定商户...")
            viewModel.checkTenant(mBindMerchantBean!!.openid, mBindMerchantBean!!.type)
        } else {
            showToast("未检测到商户二维码")
        }
    }


    override fun checkMerchantSuccess() {
        dialog.dismiss()
        //检测成功，跳转到选择商户界面
        if (mBindMerchantBean != null) {
            startWithPop(
                SelectMerchantFragment.newInstance(
                    BIND_MERCHANT,
                    mBindMerchantBean!!.openid,
                    mBindMerchantBean!!.unionid,
                    mBindMerchantBean!!.type
                )
            )
        }

    }

    override fun checkMerchantFail(msg: String) {
        dialog.dismiss()
        showToast(msg)
    }

    companion object {
        fun newInstance() = ScanBindMerchantFragment()
    }


}
