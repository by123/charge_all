package com.xhd.td.ui.home


import android.view.View
import android.widget.RadioGroup
import android.widget.TextView
import androidx.appcompat.widget.SearchView
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.RecyclerView
import cn.droidlover.xrecyclerview.XRecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.elvishew.xlog.XLog
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.home.PerformanceTotalAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.ui.mine.AgentMerchantDetailFragment
import com.xhd.td.utils.TimeUtils
import com.xhd.td.utils.TimeUtils.convertToShortLine
import com.xhd.td.utils.TimeUtils.getPastDate
import com.xhd.td.utils.calendar.CalendarFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.home.TotalCB
import com.xhd.td.vm.home.TotalVM
import kotlinx.android.synthetic.main.fragment_total_merchant.*
import java.util.*
import javax.inject.Inject


/**
 * create by xuexuan
 * time 2019/4/3 10:20
 *
 * 这个抽象类用于三个地方
 * 1、首页 ——>收益明细->开发商户数  //四个条件：1、选中的代理商或商户 2、时间范围  3、直属拓展、下级拓展  4、搜索条件
 * 2、首页 ——>收益明细->激活设备数 //三个条件：1、选中的代理商或商户 2、时间范围  3、搜索条件
 * 3、首页 ——>收益明细->设备收益
 * 抽象类中提供xml，各自的子类中实现各自的adapter的xml
 */
abstract class AbstractTotalFragment<X, Y : RecyclerView.ViewHolder, T : ViewDataBinding> :
    BaseFragment<T, TotalVM, TotalCB>(), TotalCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_total_merchant

    override val viewModel: TotalVM
        get() = ViewModelProviders.of(this, factory).get(TotalVM::class.java)


    protected abstract var mAdapter: SimpleRecAdapter<X, Y>
    private lateinit var mPerformanceTotalAdapter: SimpleRecAdapter<String, PerformanceTotalAdapter.ViewHolder>

    var mLayoutEmpty: View? = null

    var selectedYear = Calendar.getInstance().get(Calendar.YEAR)
    var selectedMonth = Calendar.getInstance().get(Calendar.MONTH) + 1

    var mXRecyclerView: XRecyclerView? = null

    //搜索条件
    //起始和结束时间
    protected var mStartTime: String = ""
    protected var mEndTime: String = ""
    //商户id
    lateinit var mRadioGroupTime: RadioGroup
    lateinit var mSearchView: SearchView

    var mMerchantId: String? = UserModel.mchBean?.mchId
    //商户名称
    var mMerchantName: String? = null
    //是否是搜索查询
    protected var mIsSearch: Boolean? = false

    //该界面是否单独显示
    var mIsCurrentMerchant = false

    lateinit var mTvStartTime: TextView
    lateinit var mTvEndTime: TextView

    //30天前的时间戳
    private var mEarliestTimeStamp: Long = 0

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        initRecyclerView()
        registerEventBus()
        mTvStartTime = view.findViewById(R.id.tv_start_time)
        mTvEndTime = view.findViewById(R.id.tv_end_time)
        mRadioGroupTime = view.findViewById(R.id.radio_group_time)
        mSearchView = view.findViewById(R.id.search_view)

        if (mIsCurrentMerchant) {
            (view.findViewById(R.id.toolBar) as View).visibility = View.GONE
        }

        val textView = search_view.findViewById<SearchView.SearchAutoComplete>(R.id.search_src_text)
        textView.textSize = 14.0f

//        scroll_view.getViewTreeObserver().addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener {
//            swipeRefreshLayout.setEnabled(scroll_view.getScrollY() === 0)
//        })

        mEarliestTimeStamp = TimeUtils.dateToTimestamp(getPastDate(30))
        mTvStartTime.setOnClickListener { showCalendar() }
        mTvEndTime.setOnClickListener { showCalendar() }
        mRadioGroupTime.setOnCheckedChangeListener { group, checkedId ->

            if (checkedId == -1) {
                //清除clearCheck
                return@setOnCheckedChangeListener
            }

            //初始化时间选择，默认当天时间
            val today = TimeUtils.formatData(Date().time)
            mTvEndTime.text = today
            mEndTime = convertToShortLine(today)
            when (checkedId) {
                //今天
                R.id.btn_0 -> {
                    mTvStartTime.text = today
                }
                //最近7天
                R.id.btn_1 -> {
                    mTvStartTime.text = convertToShortLine(getPastDate(7))
                }
                //最近30天
                R.id.btn_2 -> {
                    mTvStartTime.text = convertToShortLine(getPastDate(30))

                }
            }
            mStartTime = convertToShortLine(mTvStartTime.text.toString())
            getTotalData(Constants.START_PAGE_ID)
        }

        mSearchView.setOnClickListener { mSearchView.onActionViewExpanded() }

        mSearchView.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean {

                hideSoftInput()
                getTotalData(Constants.START_PAGE_ID, query)
                return true
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                mSearchView.isSubmitButtonEnabled = !newText.isNullOrEmpty()
                if (newText.isNullOrEmpty()) {
                    getTotalData(Constants.START_PAGE_ID)
                }
                return false
            }
        })

        if (mIsCurrentMerchant) {
            //显示当前商户，时间默认当天
            val today = TimeUtils.formatData(Date().time)
            mStartTime = today
            mEndTime = today
            mTvStartTime.text = today
            mTvEndTime.text = today
        } else {
            //显示其他商户，时间是传递进来的
            mTvStartTime.text = mStartTime
            mTvEndTime.text = mEndTime
        }

//        search_view.setOnQueryTextFocusChangeListener { v, hasFocus ->
//            if (!hasFocus) {
//               close()
//            }
//        }

        getTotalData(Constants.START_PAGE_ID)
    }


    override fun onSupportVisible() {
        super.onSupportVisible()
        search_view.clearFocus()
    }


    private fun initRecyclerView() {

        //统计数据的recycleView
//        val gridManager = GridLayoutManager(context, 3)
//        rc_performance_total.layoutManager = gridManager
//        mPerformanceTotalAdapter = PerformanceTotalAdapter(context!!)
//        rc_performance_total.adapter = mPerformanceTotalAdapter

        recyclerContentLayout.refreshEnabled(false)

        //数据列表的recycleView
        mXRecyclerView = recyclerContentLayout.recyclerView
//        scroll_view.setSmoothScrollbarEnabled(true);
//        scroll_view.setAutoMeasureEnabled(true);
        mXRecyclerView?.isNestedScrollingEnabled = true
        mXRecyclerView?.setAdapter(mAdapter)
        mXRecyclerView?.verticalLayoutManager(context)

        mXRecyclerView?.onRefreshAndLoadMoreListener = object : XRecyclerView.OnRefreshAndLoadMoreListener {
            override fun onLoadMore(page: Int) {

                getTotalData(page)
            }

            override fun onRefresh() {
                getTotalData(Constants.START_PAGE_ID)
            }
        }
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
                            //选择时间后，取消日期的radio选择，
                            mRadioGroupTime.clearCheck()
                            val data = eventMessage.eventContent as List<String?>
                            val startTimestamp = TimeUtils.dateToTimestamp(data[0] ?: "")
                            val endTimestamp = TimeUtils.dateToTimestamp(data[1] ?: "")
                            if ((endTimestamp - startTimestamp) > 2678400000L) {
                                showToast("最多可选择31天")
                                return@subscribe
                            }
                            mStartTime = convertToShortLine((data[0] ?: ""))
                            mEndTime = convertToShortLine((data[1] ?: ""))
                            mTvStartTime.text = mStartTime
                            mTvEndTime.text = mEndTime
                            getTotalData(Constants.START_PAGE_ID)

                        } catch (e: Exception) {
                            XLog.d(e)
                        }
                    }
                }
            }.addTo(viewModel.compositeDisposable)

    }

    private fun showCalendar() {
        if (mIsCurrentMerchant) {
            (parentFragment as PerformanceFragment).start(CalendarFragment.newInstance())
        } else {
            start(CalendarFragment.newInstance())
        }
    }


    protected fun showMchInfo(mchId: String) {
        if (mIsCurrentMerchant) {
            (parentFragment as PerformanceFragment).start(AgentMerchantDetailFragment.newInstance(mchId))
        } else {
            start(AgentMerchantDetailFragment.newInstance(mchId))
        }
    }


    override fun handleError(throwable: Throwable) {

    }

    override fun getTotalFail(msg: String) {
        showToast(msg)
    }


    override fun getTotalSuccess(currentPage: Int, totalPage: Int, total: Int) {

        mXRecyclerView?.setPage(currentPage, totalPage)

//        if (total == 0) {
//            try {
//                mLayoutEmpty = viewStub.inflate()     //inflate 方法只能被调用一次，
//            } catch (e: Exception) {
//                if (mLayoutEmpty != null) {
//                    mLayoutEmpty!!.visibility = View.VISIBLE
//                }
//            }
//        } else {
//            if (mLayoutEmpty != null) {
//                mLayoutEmpty!!.visibility = View.GONE
//            }
//        }
    }


    protected var mPageId = Constants.START_PAGE_ID
    open fun getTotalData(pageId: Int, keyword: String? = null) {
        mPageId = pageId

        mIsSearch = keyword != null
    }


    protected fun setHideView(isEmpty: Boolean) {

        if (isEmpty && (mIsSearch == false)) {
            search_view.visibility = View.GONE
            view_search_view.visibility = View.GONE

        } else {
            search_view.visibility = View.VISIBLE
            view_search_view.visibility = View.VISIBLE
        }

    }

}