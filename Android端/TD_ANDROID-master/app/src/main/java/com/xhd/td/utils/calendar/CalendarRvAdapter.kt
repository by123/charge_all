package com.xhd.td.utils.calendar

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.xhd.td.R

/**
 * Created by cracker on 2017/8/3.
 */

class CalendarRvAdapter(var mCompleteListener:CalendarCompleteistener) : RecyclerView.Adapter<CalendarRvHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CalendarRvHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.week_rv_item, null)
        return CalendarRvHolder(view,mCompleteListener)
    }

    override fun onBindViewHolder(holder: CalendarRvHolder, position: Int) {
        holder.txtv_yearmonth.text = DateUtils.getDate(position)
        holder.gv.setData(DateUtils.getList(position), this)
        holder.gv.setSelectBefore(true)
    }


    override fun getItemCount(): Int {
        return Integer.MAX_VALUE
    }
}
