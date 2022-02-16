package com.xhd.td.adapter.order

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.MchBean
import kotlinx.android.synthetic.main.item_order_merchant_name.view.*


class SelectMerchantForOrderAdapter(context: Context, var mItemClick: (mchName: String) -> Unit) : SimpleRecAdapter<MchBean, SelectMerchantForOrderAdapter.ViewHolder>(context){


    override val layoutId: Int get() = R.layout.item_order_merchant_name

    override fun newViewHolder(itemView: View): ViewHolder {

        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.merchantName.text = data[position].mchName
        holder.itemView.setOnClickListener {
            mItemClick(holder.merchantName.text.toString())
        }
    }



    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var merchantName = itemView.tv_type

    }
}
