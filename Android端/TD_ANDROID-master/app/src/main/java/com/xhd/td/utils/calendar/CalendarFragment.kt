package com.xhd.td.utils.calendar

import android.os.Bundle
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.Toolbar
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.R
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.utils.qmui.QMUIStatusBarHelper
import kotlinx.android.synthetic.main.title_bar.view.*
import me.yokeyword.fragmentation.SupportFragment


class CalendarFragment : SupportFragment() {
    private var calendar_rv: RecyclerView? = null
    private var adapter: CalendarRvAdapter? = null

//    override fun onWindowFocusChanged(hasFocus: Boolean) {
//        if (hasFocus) {
//            val width = toolBar!!.getChildAt(2).width
//            val toolBar_title = toolBar!!.findViewById<View>(R.id.toolBar_txtv)
//            toolBar_title.setPadding(
//                toolBar_title.paddingLeft,
//                toolBar_title.paddingTop,
//                width,
//                toolBar_title.paddingBottom
//            )
//        }
//    }


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        val view = inflater.inflate(R.layout.fragment_calendar_main, container, false)
        initView(view)
        val toolBar = view?.findViewById<Toolbar>(R.id.toolBar)
        if (toolBar != null) {
//                val lp = toolBar.layoutParams as ViewGroup.MarginLayoutParams
//                lp.setMargins(0, QMUIStatusBarHelper.getStatusbarHeight(_mActivity), 0, 0)
//                toolBar.layoutParams = lp

            val lp = toolBar.layoutParams
            lp.height = lp.height + QMUIStatusBarHelper.getStatusbarHeight(_mActivity)
            toolBar.setPadding(0, QMUIStatusBarHelper.getStatusbarHeight(_mActivity), 0, 0)
            toolBar.layoutParams = lp
        }
        return view
    }


    var mCompleteListener = object :CalendarCompleteistener{
        override fun onComplete(startTime: String?, endTime: String?) {
            pop()
            BusProvider.getBus()?.post(EventMessage<List<String?>>(EventKey.SELECT_CALENDAR_REQUEST, arrayListOf(startTime,endTime)))
        }

    }

    private fun initView(view:View) {
        //初始化Rv
        calendar_rv = view.findViewById<View>(R.id.calendar_rv) as RecyclerView
        adapter = CalendarRvAdapter(mCompleteListener)
        val manager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
        calendar_rv!!.layoutManager = manager
        calendar_rv!!.adapter = adapter
        calendar_rv!!.setWillNotDraw(false)
        //初始化toolbar
//        toolBar = findViewById<View>(R.id.toolBar) as Toolbar
//        setSupportActionBar(toolBar)
//        supportActionBar!!.setDisplayHomeAsUpEnabled(true)

        view.toolBar.setNavigationOnClickListener { pop() }
        view.title.text = "选择起始时间"
        calendar_rv!!.scrollToPosition(curPos)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> pop()
        }
        return true
    }

    companion object {
        fun newInstance() = CalendarFragment()
        var curPos = (DateUtils.curYear - 1970) * 12 + DateUtils.month
    }
}
