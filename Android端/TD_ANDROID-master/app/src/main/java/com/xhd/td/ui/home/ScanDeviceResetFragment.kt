package com.xhd.td.ui.home

import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.vm.home.ScanVM
import kotlinx.android.synthetic.main.fragment_abstract_scan_qr.*

/**
 * create by xuexuan
 * time 2019/4/2 13:44
 */
class ScanDeviceResetFragment : AbstractScanQRFragment<ScanVM>() {

    override val viewModel: ScanVM get() = ViewModelProviders.of(this, factory).get(ScanVM::class.java)

    var mSn:String = ""
    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        tv_activate_device_num.visibility = View.GONE
        btn_finish.visibility = View.GONE
        tv_title.text = "设备密码重置"
        tv_scan_tip.text = "请扫需要复位的设备二维码"
    }

    /**
     * 扫描设备二维码成功
     */
    override fun scanSuccess(result: String) {
        val sn = result.split("sn=")[1]
        mSn = sn
        dialog.showWithStatus("扫码成功，正在重置密码...")

        viewModel.deviceReset(sn)
    }


    override fun resetSuccess(result: String) {
        //跳转到密码重置界面
        dialog.dismiss()
        startWithPop(DeviceResetFragment.newInstance(result,mSn))
    }

    override fun resetFail(msg: String) {
        dialog.dismiss()
        showToast(msg)
    }

    companion object {
        fun newInstance() = ScanDeviceResetFragment()
    }

}