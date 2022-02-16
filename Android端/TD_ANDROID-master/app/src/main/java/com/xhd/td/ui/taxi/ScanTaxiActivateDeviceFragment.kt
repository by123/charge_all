package com.xhd.td.ui.taxi

import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.bingoogolapple.qrcode.core.BR
import com.xhd.td.ui.home.AbstractScanQRFragment
import com.xhd.td.vm.home.ScanVM
import kotlinx.android.synthetic.main.fragment_abstract_scan_qr.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class ScanTaxiActivateDeviceFragment : AbstractScanQRFragment<ScanVM>(){


    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment

    override val viewModel: ScanVM get() = ViewModelProviders.of(this, factory).get(ScanVM::class.java)

    lateinit var mGroupId:String
    lateinit var mGroupName:String
    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        tv_activate_device_num.visibility = View.VISIBLE
        btn_finish.visibility = View.GONE
        tv_taxi_group.visibility = View.VISIBLE
        tv_taxi_group.text = mGroupName
        tv_activate_device_num.text = 0.toString()

        tv_title.text = "扫描添加设备"
        tv_scan_tip.text = "已添加设备"
    }


    override fun scanSuccess(result: String) {
        val sn = result.split("sn=")[1]
        if (!mScanResultList.contains(sn)) {
            dialog.showWithStatus("扫码成功，正在添加设备...")
            viewModel.taxiActivateDevice(mGroupId,sn)
        } else {
            showToast("该二维码已扫描")
        }
    }


    override fun taxiActivateDeviceSuccess(sn: String) {
        dialog.dismiss()
        //添加成功，则把这个sn添加到 已经扫描成功的
        if (!mScanResultList.contains(sn)) {
            mScanResultList.add(sn)
            tv_activate_device_num.text = mScanResultList.size.toString()
            showToast("添加成功")
        } else{
            showToast(sn)
        }
    }

    override fun taxiActivateDeviceFail(msg: String) {
        dialog.dismiss()
        showToast(msg)
    }



    companion object {
        fun newInstance(groupId:String,groupName:String) = ScanTaxiActivateDeviceFragment()
            .apply {
                mGroupId = groupId
                mGroupName = groupName
            }
    }


}