package com.xhd.td.adapter.whitelist

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.WhitelistTimeBean
import com.xhd.td.utils.TimeUtils
import kotlinx.android.synthetic.main.item_map_adapter.view.img_check
import kotlinx.android.synthetic.main.item_select_whitelist_time_adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class SelectWhitelistTimeAdapter(context: Context, clickListener: (WhitelistTimeBean) -> Unit) :
    SimpleRecAdapter<WhitelistTimeBean, SelectWhitelistTimeAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_select_whitelist_time_adapter
    private var selectPosition = -1

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView!!)
    }

    public fun setSelectPosition(position: Int) {
        this.selectPosition = position
        notifyDataSetChanged()
    }

    public fun getSelectPositon(): Int {
        return selectPosition
    }


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)
        holder.itemView.tag = position

        if (position == selectPosition) {
            holder.itemView.img_check.setBackgroundResource(R.drawable.vector_item_selected)
        } else {
            holder.itemView.img_check.setBackgroundResource(R.drawable.vector_item_normal)
        }

        holder.itemView.setOnClickListener { view ->
            val position = view.tag as Int
            setSelectPosition(position)
            if (null != recItemClick) {
                recItemClick.onItemClick(position, data[position], 0, holder)
            }
        }

    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        fun bind(bean: WhitelistTimeBean, position: Int) {
            itemView.tv_time.text = TimeUtils.minuteToHour(bean.time).toString() + "小时"
        }
    }

}