package com.xhd.td.adapter.mine

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.MessageBean
import com.xhd.td.utils.TimeUtils
import kotlinx.android.synthetic.main.item_message_list_adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class MessageListAdapter(context: Context, clickListener: (String) -> Unit) :
    SimpleRecAdapter<MessageBean, MessageListAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_message_list_adapter

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView!!)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)
        holder.itemView.setOnClickListener {
            if (null != recItemClick) {
                recItemClick.onItemClick(position, data[position], 0, holder)
            }
        }
    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind(info: MessageBean, position: Int) {
            // itemView.tv_number.text = info
            itemView.tv_title.text = info.title
            itemView.tv_brief.text = info.brief
            itemView.tv_time.text  = TimeUtils.formatDataTime(info.publishTime)
        }
    }


}