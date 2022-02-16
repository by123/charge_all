package com.xhd.td.ui.income

import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import cn.droidlover.xrecyclerview.XRecyclerAdapter
import cn.droidlover.xrecyclerview.XRecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentAbstractLoadMoreBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.utils.calculateNextMonthFirstDay
import com.xhd.td.utils.parseMonth
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.income.AbstractLoadMoreCB
import com.xhd.td.vm.income.AbstractLoadMoreVM
import kotlinx.android.synthetic.main.fragment_abstract_load_more.*
import kotlinx.android.synthetic.main.view_stub_empty.*
import java.util.*
import javax.inject.Inject

/**
 *  create by xuexuan
 *  time 2019/4/3 17:21
 *
 *  抽象类，用于所有根据时间，来查询信息，并且是分页返回的
 *  默认显示当前月份1号到本月最后一天的数据
 *
 *  一、如果自定义的xml，但是必须要求
 *  1、有 XRecyclerView 控件且id为 recyclerView
 *  2、必须有viewStub，用于显示，在没有数据时
 *
 *  二、自定义vm，要求
 *  1、需要在网络请求返回后，调用getTotalSuccess，并传入正确的参数。这样才会保障分页的正确
 *
 *  三、实现类，要求
 *  1、如果实现类的xml差异很小，则使用抽象类的xml，必须实现AbstractLoadMoreCB 中的 returnDataToView接口用于接收数据。
 *     如果实现类使用各自的xml，可以考虑使用databinding在更新adapter
 *
 *  这个抽象类用于四个地方
 *  1、收益->收益明细
 *  2、收益->提现明细
 *  3、收益->收益明细->渠道收入
 *  4、收益->收益明细->设备使用
 *
 */
abstract class AbstractLoadMoreFragment<X, Y : RecyclerView.ViewHolder, F : AbstractLoadMoreVM> :
    BaseFragment<FragmentAbstractLoadMoreBinding, F, AbstractLoadMoreCB>(), AbstractLoadMoreCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_abstract_load_more
    override var mHasToolbar = false


    open lateinit var mXAdapter: XRecyclerAdapter

    protected abstract var mAdapter: SimpleRecAdapter<X, Y>

    var mLayoutEmpty: View? = null

    var mStartTime: String = ""
    var mEndTime: String = ""
    var mAtTime: String = ""

    abstract var mIsAtTime: Boolean

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        setSwipeBackEnable(false)

        viewModel?.mCallback = this

        swipeLayout.apply {
            setColorSchemeColors(
                resources.getColor(R.color.btn),
                resources.getColor(R.color.colorAccent),
                resources.getColor(R.color.colorPrimary)
            )
            setOnRefreshListener { initListData() }
        }
        registerEventBus()
        initRecyclerView()
        initListData()
    }


    private fun initListData() {
        if (mIsAtTime) {
            if (mAtTime.isEmpty()) {
                val year = Calendar.getInstance().get(Calendar.YEAR)
                val month = Calendar.getInstance().get(Calendar.MONTH) + 1
                val day = Calendar.getInstance().get(Calendar.DAY_OF_MONTH)
                mAtTime = "${year}-${parseMonth(month)}-${day}"
            }
            getDataAtTime(mAtTime)

        } else {
            if (mStartTime.isEmpty() && mEndTime.isEmpty()) {

                val year = Calendar.getInstance().get(Calendar.YEAR)
                val month = Calendar.getInstance().get(Calendar.MONTH) + 1
                mStartTime = "${year}-${parseMonth(month)}-01"
                mEndTime = calculateNextMonthFirstDay(year,month)
            }
            getDataInTime(mStartTime, mEndTime)

        }
    }

    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        viewModel?.compositeDisposable?.let {
            BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
                .subscribe { eventMessage ->
                    when (eventMessage.tag) {
                        EventKey.INCOME_TIME_CHANGE -> {
                            //时间发生变化，获取时间请求数据
                            var data = eventMessage.eventContent as List<Int>
                            getDataInTime(data[0], data[1])
                        }
                    }
                }.addTo(it)
        }
    }


    /**
     * 设置查询时间范围,并用新的时间去查询
     * 时间的格式，由各自实现该类的子类去控制
     */
    private fun getDataInTime(startTime: String, endTime: String) {
        mStartTime = startTime
        mEndTime = endTime
        mAdapter.clearData()
        //调用抽象方法，去请求数据
        getDataInTime(1, startTime, endTime)
    }


    private fun getDataInTime(year: Int, month: Int) {
        val startTime = "${year}-${parseMonth(month)}-01"
        val endTime = calculateNextMonthFirstDay(year, month)
        getDataInTime(startTime, endTime)
    }


    private fun getDataAtTime(time: String) {
        mAtTime = time
        mAdapter.clearData()
        //调用抽象方法，去请求数据
        getDataAtTime(0, time)
    }


    private fun getDataAtTime(year: Int, month: Int, day: Int) {

        var time = "${year}-${parseMonth(month)}-${day}"
        getDataAtTime(time)
    }


    private fun initRecyclerView() {
        val gridManager = LinearLayoutManager(context)
        recyclerView_load_more.layoutManager = gridManager
        mXAdapter = XRecyclerAdapter(mAdapter)
        recyclerView_load_more.adapter = mXAdapter
        recyclerView_load_more.onRefreshAndLoadMoreListener = object : XRecyclerView.OnRefreshAndLoadMoreListener {
            override fun onLoadMore(page: Int) {

                if (mIsAtTime) {
                    getDataAtTime(page, mAtTime)
                } else {
                    getDataInTime(page, mStartTime, mEndTime)
                }
            }

            override fun onRefresh() {
            }
        }
    }


    override fun getDataFail(msg: String?) {

        if (swipeLayout != null) {
            swipeLayout.isRefreshing = false
        }
        msg?.let { showToast(it) }
    }


    override fun getDataSuccess(currentPage: Int, totalPage: Int, totalCount: Int) {

        if (swipeLayout != null) {
            swipeLayout.isRefreshing = false
        }

        if (totalCount == 0) {
            try {
                mLayoutEmpty = viewStub.inflate()     //inflate 方法只能被调用一次，
            } catch (e: Exception) {
                if (mLayoutEmpty != null) {
                    mLayoutEmpty!!.visibility = View.VISIBLE
                }
            }
        } else {
            recyclerView_load_more.setPage(currentPage, totalPage)
            if (mLayoutEmpty != null) {
                mLayoutEmpty!!.visibility = View.GONE
            }
        }
    }


    open fun getDataInTime(pageId: Int, startTime: String, endTime: String) {}
    open fun getDataAtTime(pageId: Int, time: String) {}


}