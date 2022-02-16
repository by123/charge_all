package com.xhd.td.adapter.home

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.utils.convertToWan
import kotlinx.android.synthetic.main.item_home_rc_performance.view.*

/**
 * create by xuexuan
 * time 2019/3/18 16:24
 */
class PerformanceAdapter(context: Context) : SimpleRecAdapter<String, PerformanceAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_home_rc_performance

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)

//        XLog.d("第"+position.toString()+ "数据是："+ holder.toString())
        if (position == 2 || position == 5){
            holder.itemView.line.visibility = View.GONE
        }else{
            holder.itemView.line.visibility = View.VISIBLE
        }

    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var line = itemView.line
        fun bind(info: String, position: Int) {
            itemView.tv_number.text = convertToWan(info)
            var typeNme = ""
            when (position) {
                0 -> typeNme = "今日开发商户"
                1 -> typeNme = "今日激活设备"
                2 -> typeNme = "今日设备收益"
                3 -> typeNme = "开发商户总数"
                4 -> typeNme = "激活设备总数"
                5 -> typeNme = "设备总收益"
            }
            itemView.tv_type.text = typeNme
        }
    }


}