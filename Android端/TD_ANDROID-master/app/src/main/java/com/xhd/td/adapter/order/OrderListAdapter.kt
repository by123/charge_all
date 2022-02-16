package com.xhd.td.adapter.order

import android.content.Context
import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.OrderBean


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class OrderListAdapter(context: Context, var mViewDetail:(OrderBean)->Unit, var mRefund:(OrderBean)->Unit) : SimpleRecAdapter<OrderBean, OrderListAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_order_list

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.binding?.bean = data[position]
        holder.binding?.orderAdapter = this
//        holder.itemView.setOnClickListener { v ->
//            if (null != recItemClick) {
//                recItemClick.onItemClick(position, item, 0, holder)
//            }
//        }
    }

    fun refund(orderBean: OrderBean) {
        mRefund(orderBean)
    }

    fun toDetail(orderBean: OrderBean) {
        mViewDetail(orderBean)
    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var binding: com.xhd.td.databinding.ItemOrderListBinding? = DataBindingUtil.bind(itemView)

    }




}