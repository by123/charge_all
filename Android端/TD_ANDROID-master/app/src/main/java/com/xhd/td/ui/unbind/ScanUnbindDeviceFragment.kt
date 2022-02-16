package com.xhd.td.ui.unbind

import android.view.View
import android.view.animation.AnimationUtils
import androidx.lifecycle.ViewModelProviders
import cn.bingoogolapple.qrcode.core.BR
import com.xhd.td.R
import com.xhd.td.model.bean.DeviceInfo
import com.xhd.td.ui.home.AbstractScanQRFragment
import com.xhd.td.vm.home.ScanVM
import kotlinx.android.synthetic.main.fragment_scan_unbind_device.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class ScanUnbindDeviceFragment : AbstractScanQRFragment<ScanVM>() {


    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_scan_unbind_device

    override val viewModel: ScanVM get() = ViewModelProviders.of(this, factory).get(ScanVM::class.java)

    var mCurrentDeviceSn: String? = null

    override fun scanSuccess(result: String) {
        val sn = result.split("sn=")[1]
        if (!mScanResultList.contains(sn)) {
            mCurrentDeviceSn = sn
            tv_device_sn.text = mCurrentDeviceSn
            dialog.showWithStatus("扫码成功，正在获取商户信息...")

            viewModel.getDeviceDetailBySn(mCurrentDeviceSn ?: "")
        } else {
            showToast("该二维码已扫描")
        }
    }


    fun unbind() {
        if (mCurrentDeviceSn != null) {
            viewModel.unbindDeviceBysnList(mCurrentDeviceSn ?: "")
        }else{
            showToast("请先扫描设备二维码")
        }
    }


    override fun getDeviceDetailBySnSuccess(deviceInfo: DeviceInfo) {
        dialog.dismiss()

        //这里是获取最后一个的信息，如果设备已经激活，最后一个是商户
        //如果设备未激活，最后一个是代理商
        tv_device_merchant_info.text = deviceInfo.deviceMach?.last()?.mchName

        layout_scan_info.startAnimation(AnimationUtils.loadAnimation(context, R.anim.scan_info_enter))
        layout_scan_info.visibility = View.VISIBLE
    }

    override fun getDeviceDetailBySnFail(msg: String) {
        dialog.dismiss()
    }


    override fun unbindDeviceSuccess(result: String) {
        showToast("$result 解绑成功")

        layout_scan_info.startAnimation(AnimationUtils.loadAnimation(context, R.anim.scan_info_exit))
        layout_scan_info.visibility = View.GONE
    }

    override fun unbindDeviceFail(msg: String) {
        showToast("解绑失败 $msg")
    }


    companion object {
        fun newInstance() = ScanUnbindDeviceFragment()
    }


}