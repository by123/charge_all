package com.xhd.td.adapter.home

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.HomeItemBean
import kotlinx.android.synthetic.main.item_home.view.*
import kotlinx.android.synthetic.main.item_select_merchant_adapter.view.*

/**
 * create by xuexuan
 * time 2019/4/13 13:50
 */

class HomeAdapter(context: Context, var itemClick:(HomeItemBean)->Unit) :
    SimpleRecAdapter<HomeItemBean, HomeAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_home
    private var mCheckedPosition: Int = -1


    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView!!)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        var item = data[position]
        holder.bind(item, position)

        holder.itemView.setOnClickListener {
            itemClick(item)
        }


    }

    fun getSelectItem(): HomeItemBean? {
        return if (mCheckedPosition >= data.size) null else data[mCheckedPosition]
    }

    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var tvCheck = itemView.checkbox
        fun bind(info: HomeItemBean, position: Int) {
            itemView.tv_home_item.text = info.title
            itemView.img_home_item.setImageResource(info.imgResourceId)


        }
    }


}