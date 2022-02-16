package com.xhd.td.utils.calendar

import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.xhd.td.R

/**
 * Created by cracker on 2017/8/3.
 */

class CalendarRvHolder(itemView: View,var mCompleteListener:CalendarCompleteistener) : RecyclerView.ViewHolder(itemView) {
    var gv: CalendarView
    var txtv_yearmonth: TextView

    init {
        gv = itemView.findViewById<View>(R.id.calendar_rv_item_gv) as CalendarView
        txtv_yearmonth = itemView.findViewById<View>(R.id.calendar_rv_item_txtv_year) as TextView

        gv.setSelectListenner(object :CalendarSelectListener{
            override fun onSelected(type: Int, time: Array<String?>) {
                if (CalendarView.TYPE_START == type) {
                } else {
                    mCompleteListener.onComplete(time[0],time[1])
                }
            }

        })
//        gv.setSelectListenner { type, time ->
//            if (CalendarView.TYPE_START == type) {
//                Log.e("kk", "类型：" + type + "," + time[0])
//            } else {
//                Log.e("kk", "类型：" + type + "," + time[0] + "---->" + time[1])
//                (itemView.context as CalendarFragment).postResult(time[0] + "$" + time[1])
//            }
//        }
    }
}
