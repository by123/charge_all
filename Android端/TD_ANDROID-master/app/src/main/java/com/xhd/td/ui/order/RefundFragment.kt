package com.xhd.td.ui.order

import android.app.Activity
import android.os.Bundle
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import com.bigkoo.pickerview.builder.OptionsPickerBuilder
import com.bigkoo.pickerview.listener.OnOptionsSelectListener
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentRefundBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.CfgBean
import com.xhd.td.model.bean.OrderBean
import com.xhd.td.model.bean.RefundBean
import com.xhd.td.model.bean.RefundReasonBean
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.order.OrderCB
import com.xhd.td.vm.order.OrderVM
import kotlinx.android.synthetic.main.fragment_refund.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class RefundFragment : BaseFragment<FragmentRefundBinding, OrderVM, OrderCB>(), OrderCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_refund
    override val viewModel: OrderVM get() = ViewModelProviders.of(this, factory).get(OrderVM::class.java)

    var showReason: ObservableBoolean = ObservableBoolean(false)

    var mRefundReasonList = mutableListOf<String>()
    var mRefundReason: String = ""

    //退款订单

    private var mOrderBan: OrderBean? = null


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "申请退款"

        mViewDataBinding.bean = mOrderBan
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getConfig(Constants.CFG_REFUND_REASON)

    }


    //退款原因
    private fun showRefundReason(activity: Activity, dataList: MutableList<String>, cb: (beam: String) -> Any) {
//    val reasonList = arrayListOf("输入密码亮红灯无法充电", "设备全部灯不亮", "设备按键不灵", "设备其他损坏", "工作人员测试", "其它")
        val builder = OptionsPickerBuilder(activity, OnOptionsSelectListener { options1, _, _, _ ->
            cb(dataList[options1])
        })
        builder.setOutSideCancelable(false)
            .setLineSpacingMultiplier(2f)
            .isCenterLabel(false)
            .setTextColorCenter(activity.resources.getColor(R.color.btn))
            .setCancelColor(activity.resources.getColor(R.color.tv_color))
            .setSubmitColor(activity.resources.getColor(R.color.tv_color))
            .setContentTextSize(18)
            .setSubCalSize(16).build<String>().apply {
                setPicker(dataList)
            }.show()
    }


    fun refund() {
        val sum = refundValue.text?.toString()

        when{
            sum.isNullOrEmpty() -> {
                showToast("金额不能为空")
                return
            }
            mOrderBan != null -> {
                if (sum.toFloat() >  mOrderBan?.servicePriceYuan?: 0f) {
                    showToast("不能超过最大可退款金额")
                    return
                }
            }
            mOrderBan == null ->{
                showToast("获取订单信息失败，请重新打开界面")
                return
            }

        }

        if (mRefundReason.isEmpty() || (showReason.get() && refundReasonValue.text?.toString().isNullOrEmpty())){
            showToast("请输入退款原因")
            return
        }

        viewModel.refund(
            RefundBean(
                mOrderBan?.orderId?:"",
                if (showReason.get()) refundReasonValue.text?.toString() ?: "" else mRefundReason,
                sum?.toFloat()?:0f
            )
        )
    }

    override fun handleError(throwable: Throwable?) {

    }

    override fun getConfigSuccess(data: CfgBean) {
        //获取退款原因成功
//        mRefundReasonList  =
        Gson().fromJson<List<RefundReasonBean>>(
            data.cfgValue,
            object : TypeToken<ArrayList<RefundReasonBean>>() {}.type
        )
            .forEach { (dataInfo) ->
                mRefundReasonList.add(dataInfo)
            }

        tv_select_refund_reason.setOnClickListener {
            hideSoftInput()
            showRefundReason(_mActivity, mRefundReasonList) { reasonInfoStr: String ->
                mRefundReason = reasonInfoStr
                showReason.set(reasonInfoStr.trim() == "其他")
                tv_select_refund_reason.setText(reasonInfoStr)
            }
        }

    }

    override fun getConfigFail(msg: String) {
        //获取退款原因失败
        showToast(msg)
    }

    override fun refundFail(msg: String) {
        //退款失败
        showToast(msg)
    }

    override fun refundSuccess(msg: String) {
        //退款成功
        showToast("退款成功")
        //退款成功，通知主界面更新
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.REFRESH_ORDER_LIST, true))
        close()
    }

    companion object {
        fun newInstance(orderBan: OrderBean?) = RefundFragment().apply {
            mOrderBan = orderBan
        }
    }


}