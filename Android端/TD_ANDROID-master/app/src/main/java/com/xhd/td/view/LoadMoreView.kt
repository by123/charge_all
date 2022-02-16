package com.xhd.td.view

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import cn.droidlover.xrecyclerview.XRecyclerAdapter
import cn.droidlover.xrecyclerview.XRecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.constants.Constants
import kotlinx.android.synthetic.main.fragment_order.view.*
import kotlinx.android.synthetic.main.view_stub_empty.view.*
import java.util.*

/**
 * create by xuexuan
 * time 2019/4/6 17:43
 */

class LoadMoreView<T, F : RecyclerView.ViewHolder>(var mContext: Context, var mAdapter: SimpleRecAdapter<T, F>, var getMoreData:(Int)->Unit){

    private lateinit var mViewGroup: View

    public lateinit var mXRecyclerView: XRecyclerView
    private lateinit var mSwipeRefreshLayout: SwipeRefreshLayout

    private lateinit var mXAdapter: XRecyclerAdapter
    private  var mLayoutEmpty: View? = null

    private var mStartTime: String = ""
    private var mEndTime: String = ""


    fun initView(): View {
        mViewGroup = LayoutInflater.from(mContext).inflate(R.layout.layout_load_more, null, false)
        mXRecyclerView = mViewGroup.findViewById(R.id.recyclerView)
        initSwipeLayout()
        initRecyclerView()
        return mViewGroup
    }



    fun displayTopHint(){
        mViewGroup.topHint.visibility = View.VISIBLE
    }


    private fun initSwipeLayout() {

        mSwipeRefreshLayout = mViewGroup.findViewById<SwipeRefreshLayout>(R.id.swipeLayout).apply {
            setColorSchemeColors(
                resources.getColor(R.color.btn),
                resources.getColor(R.color.colorAccent),
                resources.getColor(R.color.colorPrimary)
            )
            setOnRefreshListener { initListData() }
        }
    }


    private fun initRecyclerView() {
        val gridManager = LinearLayoutManager(mContext)
        mXRecyclerView.layoutManager = gridManager
        mXAdapter = XRecyclerAdapter(mAdapter)
        mXRecyclerView.adapter = mXAdapter
        mXRecyclerView.onRefreshAndLoadMoreListener = object : XRecyclerView.OnRefreshAndLoadMoreListener {
            override fun onLoadMore(page: Int) {

                getMoreData(page)
            }

            override fun onRefresh() {
            }
        }
    }

    public fun initListData() {

        if (mStartTime.isEmpty() && mEndTime.isEmpty()) {
            mStartTime = Calendar.getInstance().get(Calendar.YEAR).toString()
            mEndTime = (Calendar.getInstance().get(Calendar.MONTH) + 1).toString()
        }
        getMoreData(Constants.START_PAGE_ID)
    }


    fun clearData(){
        mAdapter.clearData()
    }

    /**
     * 设置查询时间范围,并用新的时间去查询
     * 时间的格式，由各自实现该类的子类去控制
     */
//    private fun getDataInTime(startTime: String, endTime: String) {
//        mStartTime = startTime
//        mEndTime = endTime
//        mAdapter.clearData()
//        getDataInTime(0, startTime, endTime)
//    }
//
//
//    private fun getDataInTime(year: Int, month: Int) {
//        val startTime = "${year}-${parseMonth(month)}-01"
//        val endTime = calculateMonthLastDay(year, month)
//        getDataInTime(startTime, endTime)
//    }


    fun setTotal( totalCount: Int){
        //没有分页的用这个函数
        setTotal(1,1,totalCount)
    }


    fun setTotal( nextPage:Boolean,totalCount: Int){
        //分页的页数不准的时候，使用这个.在获取的时候也不能使用xrecyclerview 自动计算的页数，因为不准确
        val currentPage = 1
        val totalPage = if (nextPage) currentPage+1 else currentPage
        setTotal(currentPage,totalPage,totalCount)
    }

    fun setTotal(currentPage: Int, totalPage: Int, totalCount: Int) {

        mSwipeRefreshLayout.isRefreshing = false

        if (totalCount == 0) {
            try {
                mLayoutEmpty = mViewGroup.viewStub.inflate()     //inflate 方法只能被调用一次，
            } catch (e: Exception) {
                if (mLayoutEmpty != null) {
                    mLayoutEmpty!!.visibility = View.VISIBLE
                }
            }
        } else {
            mXRecyclerView.setPage(currentPage, totalPage)
            if (mLayoutEmpty != null) {
                mLayoutEmpty!!.visibility = View.GONE
            }
        }
    }


    fun setRefreshState(boolean: Boolean){
        mSwipeRefreshLayout.isRefreshing = boolean
    }
}