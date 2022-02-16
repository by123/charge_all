package com.xhd.td.ui.order

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentOrderDetailBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.OrderBean
import com.xhd.td.model.bean.OrderDetailBean
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.order.OrderCB
import com.xhd.td.vm.order.OrderVM
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class OrderDetailFragment : BaseFragment<FragmentOrderDetailBinding, OrderVM, OrderCB>(), OrderCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_order_detail
    override val viewModel: OrderVM get() = ViewModelProviders.of(this, factory).get(OrderVM::class.java)

    var mOrderBean: OrderBean? = null
    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        registerEventBus()
        toolBar.setNavigationOnClickListener { close() }
        title.text = "订单详情"
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getOrderDetails(mOrderBean?.orderId?:"")
    }


    fun refund() {
//        退款
        start(RefundFragment.newInstance(mOrderBean))
    }


    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!

            .subscribe { eventMessage ->
                when (eventMessage.tag) {

                    EventKey.REFRESH_ORDER_LIST ->{
                        viewModel.getOrderDetails(mOrderBean?.orderId?:"")
                    }
                }
            }.addTo(viewModel.compositeDisposable)

    }


    override fun handleError(throwable: Throwable?) {

    }


    override fun getOrderDetailFail(msg: String) {
        showToast(msg)

    }

    override fun getOrderDetailSuccess(bean: OrderDetailBean) {
    }

    companion object {
        fun newInstance(orderBean: OrderBean) = OrderDetailFragment().apply {
            mOrderBean = orderBean
        }
    }


}