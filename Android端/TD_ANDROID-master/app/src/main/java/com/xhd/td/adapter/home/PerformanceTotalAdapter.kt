package com.xhd.td.adapter.home

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import kotlinx.android.synthetic.main.item_home_rc_performance.view.line
import kotlinx.android.synthetic.main.item_performance_total.view.*

/**
 * create by xuexuan
 * time 2019/3/18 16:24
 */
class PerformanceTotalAdapter(context: Context) : SimpleRecAdapter<String, PerformanceTotalAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_performance_total

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)

//        XLog.d("第"+position.toString()+ "数据是："+ holder.toString())
        if (position == 1 || position == 3){
            holder.itemView.line.visibility = View.GONE
        }else{
            holder.itemView.line.visibility = View.VISIBLE
        }

    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var line = itemView.line
        fun bind(info: String, position: Int) {
            itemView.tv_content.text = info
        }
    }


}