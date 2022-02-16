package com.xhd.td.ui.unbind

import android.text.Html
import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentUnbindMerchantDeviceBinding
import com.xhd.td.model.bean.DeviceAmount
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.UnbindSuccessAmount
import com.xhd.td.view.CustomDialog
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.unbind.UnbindMerchantDeviceCB
import com.xhd.td.vm.unbind.UnbindMerchantDeviceVM
import kotlinx.android.synthetic.main.fragment_unbind_merchant_device.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class UnbindMerchantDeviceFragment :
    BaseFragment<FragmentUnbindMerchantDeviceBinding, UnbindMerchantDeviceVM, UnbindMerchantDeviceCB>(),
    UnbindMerchantDeviceCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_unbind_merchant_device
    override val viewModel: UnbindMerchantDeviceVM get() = ViewModelProviders.of(this, factory).get(UnbindMerchantDeviceVM::class.java)

    var mMchBean: MchBean? = null
    var mDeviceNum = 0
    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "按商户解绑设备"

        tv_merchant_name.text = mMchBean?.mchName
        tv_merchant_id_value.text = mMchBean?.mchId
        tv_contact_name_value.text = mMchBean?.contactUser
        viewModel.getTenantDeviceInfo(mMchBean?.mchId?:"")
    }


    fun unbind() {
        //弹窗确认
        showDialog("解绑设备", "", object : CustomDialog.ClickBack {
            override fun determine() {
                //调用批量取消绑定的接口
                viewModel.unbindByTenantId(mMchBean?.mchId?:"")
            }
        })
    }


    private fun showDialog(title: String, content: String, callback: CustomDialog.ClickBack) {
        val customDialog = CustomDialog(context!!)
        customDialog.setContentText(content)
        customDialog.setTitleText(title)
        customDialog.back = callback
        customDialog.show()
        customDialog.mTvContent?.text = Html.fromHtml("确认是否批量解绑，操作后不可恢复 <br> <font color='#353648' size= 16 >设备数量：${tv_devices_amount_value.text}个</font>")
    }

    override fun handleError(throwable: Throwable) {

    }

    override fun getTenantDeviceInfoFail(msg: String?) {
        //获取商户的激活设备数量失败
        showToast(msg)
    }

    override fun getTenantDeviceInfoSuccess(deviceAmount: DeviceAmount) {
        //获取商户的激活设备数量成功
        tv_devices_amount_value.text = deviceAmount.total.toString()
        mDeviceNum = deviceAmount.total
    }


    override fun unbindByTenantIdFail(msg: String?) {
        //解绑失败，跳转到失败界面
        startWithPop(UnbindResultFragment.newInstance(false,mDeviceNum,msg))
    }

    override fun unbindByTenantIdSuccess(unbindSuccessAmount: UnbindSuccessAmount) {
        //解绑成功，跳转到成功界面

        startWithPop(UnbindResultFragment.newInstance(true,unbindSuccessAmount.count))
    }

    companion object {
        fun newInstance(model: MchBean?) = UnbindMerchantDeviceFragment().apply {
            mMchBean = model
        }
    }

}