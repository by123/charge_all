package com.xhd.td.ui.home

import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.bingoogolapple.qrcode.core.BR
import com.xhd.td.vm.home.ScanVM
import kotlinx.android.synthetic.main.fragment_abstract_scan_qr.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class ScanActivateDeviceFragment : AbstractScanQRFragment<ScanVM>(){


    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment

    override val viewModel: ScanVM get() = ViewModelProviders.of(this, factory).get(ScanVM::class.java)

    lateinit var mMerchantId:String
    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        tv_activate_device_num.visibility = View.VISIBLE
        btn_finish.visibility = View.VISIBLE
        tv_activate_device_num.text = 0.toString()

    }


    override fun scanSuccess(result: String) {
        val sn = result.split("sn=")[1]
        if (!mScanResultList.contains(sn)) {
            dialog.showWithStatus("扫码成功，正在激活设备...")

            viewModel.activateDevice(sn,mMerchantId)

        } else {
            showToast("该二维码已扫描")
        }
    }


    override fun activateDeviceSuccess(sn: String) {
        //添加成功，则把这个sn添加到 已经扫描成功的
        dialog.dismiss()

        if (!mScanResultList.contains(sn)) {
            mScanResultList.add(sn)
            tv_activate_device_num.text = mScanResultList.size.toString()
            showToast("添加成功")
        } else{
            showToast(sn)
        }
    }

    override fun activateDeviceFail(msg: String) {
        dialog.dismiss()
        showToast(msg)
    }



    companion object {
        fun newInstance(mchId:String) = ScanActivateDeviceFragment().apply { mMerchantId = mchId }
    }


}