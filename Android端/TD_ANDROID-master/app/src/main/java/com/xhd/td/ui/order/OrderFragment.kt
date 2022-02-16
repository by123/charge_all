package com.xhd.td.ui.order

import android.app.Activity
import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.bigkoo.pickerview.builder.OptionsPickerBuilder
import com.bigkoo.pickerview.listener.OnOptionsSelectListener
import com.elvishew.xlog.XLog
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.order.OrderListAdapter
import com.xhd.td.adapter.order.OrderPagerAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.Constants.START_PAGE_ID
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentOrderBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.OrderBean
import com.xhd.td.model.bean.OrderData
import com.xhd.td.ui.MainFragment
import com.xhd.td.utils.TimeUtils.convertToStartEnd
import com.xhd.td.utils.TimeUtils.formatDateOnlyDay
import com.xhd.td.utils.calendar.CalendarFragment
import com.xhd.td.utils.convertToWan
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.order.OrderCB
import com.xhd.td.vm.order.OrderVM
import kotlinx.android.synthetic.main.fragment_order.*
import java.util.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class OrderFragment : BaseFragment<FragmentOrderBinding, OrderVM, OrderCB>(), OrderCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_order
    override val viewModel: OrderVM get() = ViewModelProviders.of(this, factory).get(OrderVM::class.java)
    override var mHasToolbar = false

    var mPageList = arrayListOf<LoadMoreView<OrderBean, OrderListAdapter.ViewHolder>>()

    //下面的三个变量是用来获取订单列表数据的,为什么这些变量不直接作为参数，传递呢？？因为分页查询，只传递第几页，就需要查询，其他参数只能从全局变量获取
    lateinit var mStartTime: String
    lateinit var mEndTime: String
    var mMchIdList = listOf<String>()
    var mOrderType = -1

    //代理的信息（id，name），名称用来显示，id用来提交数据。null, "全部代理商" 这样的数据是因为在选择了这个选项后，null 传入 mMchIdList 就是空数组

    var mInitialAgentList =
        if (UserModel.hasTaxi) {
            arrayListOf<ArrayList<String?>>(arrayListOf(null, "全部代理商"), arrayListOf(null, "出租车"))
        } else {
            arrayListOf<ArrayList<String?>>(arrayListOf(null, "全部代理商"))
        }

    private var mAgentIdName = arrayListOf<ArrayList<String?>>()


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        setSwipeBackEnable(false)

        viewModel.mCallback = this
        mAgentIdName.addAll(mInitialAgentList)
        val pageViewList = arrayListOf<View>()
        for (i in 7 downTo 1) {
            val orderListAdapter = OrderListAdapter(context!!,
                { orderBean ->
                    (parentFragment as MainFragment).startBrotherFragment(
                        OrderDetailFragment.newInstance(
                            orderBean
                        )
                    )
                },
                { orderBean ->
                    (parentFragment as MainFragment).startBrotherFragment(
                        RefundFragment.newInstance(
                            orderBean
                        )
                    )
                })
            val layout = LoadMoreView(context!!, orderListAdapter) { pageId: Int ->
                getOrderList(pageId)
            }
            mPageList.add(layout)
            pageViewList.add(layout.initView())
        }
        viewpager.adapter = OrderPagerAdapter(
            pageViewList,
            arrayOf("全部", "未支付", "已支付", "已完成", "已取消", "退款中", "已退款")
        )
        tapLayout.setupWithViewPager(viewpager)


        //初始化时间选择，默认当天时间
        val today = formatDateOnlyDay(Date().time)
        mStartTime = convertToStartEnd(today,true)
        mEndTime = convertToStartEnd(today,false)

        tv_start_time.text = today
        tv_end_time.text = today

        tv_start_time.setOnClickListener { showCalendar() }
        tv_end_time.setOnClickListener { showCalendar() }

        //初始化代理商选择，默认显示全部代理商
        mMchIdList = listOfNotNull(mAgentIdName[0][0])
        tv_select_agent.text = mAgentIdName[0][1].toString()

        tv_select_agent.setOnClickListener {
            hideKeyboard()
            //之所以放在这里，如果添加了新的商户，点击选择需要重新获取
            viewModel.getChildMch()
        }

        viewpager.addOnPageChangeListener(object : androidx.viewpager.widget.ViewPager.OnPageChangeListener {
            override fun onPageScrollStateChanged(p0: Int) {

            }

            override fun onPageScrolled(p0: Int, p1: Float, p2: Int) {

            }

            override fun onPageSelected(p0: Int) {
                //在获取订单列表的时候，会通过viewpage 的currentItem来获取当前的页面，这里只需要重新获取数据就好
                getOrderList(START_PAGE_ID)
            }
        })
        registerEventBus()

    }


    fun searchViewClick() {
        (parentFragment as MainFragment).startBrotherFragment(SearchOrderFragment.newInstance())
    }


    //代理商
    private fun showAgentList(
        activity: Activity,
        dataList: ArrayList<ArrayList<String?>>,
        cb: (ArrayList<String?>, Int) -> Unit
    ) {
        val agentNameList = arrayListOf<String>()
        for (beam in dataList) {
            agentNameList.add(beam[1] ?: "")
        }
        val builder = OptionsPickerBuilder(activity!!, OnOptionsSelectListener { options1, _, _, _ ->
            cb(dataList[options1], options1)
        })
        builder.setOutSideCancelable(false)
            .setLineSpacingMultiplier(2f)
            .isCenterLabel(false)
            .setTextColorCenter(activity!!.resources.getColor(R.color.btn))
            .setCancelColor(activity!!.resources.getColor(R.color.tv_color))
            .setSubmitColor(activity!!.resources.getColor(R.color.tv_color))
            .setContentTextSize(18)
            .setSubCalSize(16).build<String>().apply {
                setNPicker(agentNameList, null, null)
            }.show()
    }


    private fun showCalendar() {
        (parentFragment as MainFragment).startBrotherFragment(CalendarFragment.newInstance())
    }


    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!

            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.SELECT_CALENDAR_REQUEST -> {

                        try {
                            val data = eventMessage.eventContent as List<String?>
                            tv_start_time.text = data[0]
                            tv_end_time.text = data[1]
                            mStartTime = convertToStartEnd((data[0] ?: ""),true)
                            mEndTime = convertToStartEnd((data[1] ?: ""),false)
                            getOrderList(START_PAGE_ID)
                        } catch (e: Exception) {
                            XLog.d(e)
                        }
                    }

                    EventKey.REFRESH_ORDER_LIST -> {
                        getOrderList(START_PAGE_ID)
                    }
                }
            }.addTo(viewModel.compositeDisposable)

    }

    var mLastOrderId: String? = null
    private fun getOrderList(pageId: Int) {

        if (pageId == START_PAGE_ID) {
            mPageList[viewpager.currentItem].mAdapter.clearData()
            mLastOrderId = null
        }

        viewModel.getOrderList(mMchIdList, viewpager.currentItem, mOrderType, mStartTime, mEndTime, mLastOrderId)
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getConfig(Constants.CFG_ORDER_WITHDRAW)

        getOrderList(START_PAGE_ID)
    }


    override fun handleError(throwable: Throwable?) {
        mPageList[viewpager.currentItem].setRefreshState(false)

    }

    override fun getConfigFail(msg: String) {
        showToast(msg)

    }


    override fun getOrderListSuccess(data: OrderData, viewPageId: Int) {
        //根据分页的数量和总数据是否为0 ，显示不同的界面
        mPageList[viewPageId].setTotal(data.nextPage, data.totalCount)
        mPageList[viewPageId].mAdapter.addData(data.rows)
        //查询订单是根据最后一个订单id来查询的
        mLastOrderId = data.rows?.last()?.orderId
        tv_order_value.text = convertToWan(data.finishedOrderNum) + "笔"
        tv_order_amount_value.text = convertToWan(data.finishedOrderServiceSumYuan) + "元"
    }

    override fun getOrderListFail(msg: String?) {
        msg?.let { showToast(it) }
        mPageList[viewpager.currentItem].setRefreshState(false)
    }

    override fun getChildMchSuccess(data: ArrayList<ArrayList<String?>>) {

        mAgentIdName = data
//        mAgentIdName.add(0, arrayListOf(null, "全部代理商"))
        mAgentIdName.addAll(0, mInitialAgentList)

        showAgentList(_mActivity, mAgentIdName) { agent, position ->

            if (mAgentIdName[position][1] == "出租车") {
//                    因为初始选择的列表中，0位置是全部代理商  1 位置是出租车
//                    订单类型，-1,全部订单,0:共享充电线租用,1:出租车充电"
                mOrderType = 1
            } else {
                mOrderType = -1
            }


            mMchIdList = listOfNotNull(agent[0])
            tv_select_agent.text = agent[1].toString()
            getOrderList(START_PAGE_ID)
        }
    }

    override fun getChildMchFail(msg: String?) {
        msg?.let { showToast(it) }
    }

    companion object {
        fun newInstance() = OrderFragment()

    }


}