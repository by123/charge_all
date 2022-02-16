package com.xhd.td.adapter.mine

import android.content.Context
import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.databinding.ItemManageAgentBinding
import com.xhd.td.model.bean.MchBean


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class ManageAgentAdapter(context: Context,var clickListen:(String)->Unit) : SimpleRecAdapter<MchBean, ManageAgentAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_manage_agent

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
//        holder.bind(data[position], position)
        holder.binding?.bean = data[position]

        holder.itemView.setOnClickListener { clickListen(holder.binding?.bean?.mchId?:"") }

    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var binding: ItemManageAgentBinding? = DataBindingUtil.bind(itemView)

    }


}