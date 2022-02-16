package com.xhd.td.ui.home

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.MchBean
import com.xhd.td.ui.home.SelectMerchantFragment.Companion.ACTIVATE_DEVICE
import com.xhd.td.ui.home.SelectMerchantFragment.Companion.BIND_MERCHANT
import com.xhd.td.ui.home.SelectMerchantFragment.Companion.UNBINDING_MERCHANT_DEVICE
import kotlinx.android.synthetic.main.item_select_merchant_adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 * 这个类，目前存在两种形态
 * 1、激活设备、绑定商户，有选择按钮的，点击选择商户
 * 2、解绑设备，点击直接跳转界面
 */
class SelectMerchantAdapter(context: Context, var mType: Int) :
    SimpleRecAdapter<MchBean, SelectMerchantAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_select_merchant_adapter
    var mCheckedPosition: Int = -1

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)
        when (mType) {
            ACTIVATE_DEVICE, BIND_MERCHANT -> {
                hasSelectButtonViewHolder(holder, position)
            }

            UNBINDING_MERCHANT_DEVICE -> {
                noSelectButtonViewHolder(holder, position)
            }
        }

    }

    /**
     * 激活设备、绑定商户，有选择按钮的，点击选择商户
     */
    private fun hasSelectButtonViewHolder(holder: ViewHolder, position: Int) {
        if (data[position].isSelected) {
            holder.tvCheck.setBackgroundResource(R.drawable.vector_item_selected)
        } else {
            holder.tvCheck.setBackgroundResource(R.drawable.vector_item_normal)
        }

        holder.itemView.setOnClickListener {
            val checkStatus = !data[position].isSelected
            if (checkStatus) {

                if (mCheckedPosition != position) {
//                    holder.tvCheck.postDelayed({

                    if (mCheckedPosition != -1) {
                        //先取消上个item的勾选状态
                        data[mCheckedPosition].isSelected = false
                        notifyItemChanged(mCheckedPosition)
                    }

                    mCheckedPosition = position
                }
            }

            data[position].isSelected = checkStatus

            if (null != recItemClick) {
                recItemClick.onItemClick(position, data[position], 0, holder)
            }

            notifyItemChanged(position)

        }
    }

    /**
     * 解绑商户的设备，选择直接跳转界面
     */
    private fun noSelectButtonViewHolder(holder: ViewHolder, position: Int) {
        holder.itemView.setOnClickListener {
            if (null != recItemClick) {
                recItemClick.onItemClick(position, data[position], 0, holder)
            }
        }

    }


    fun getSelectItem(): MchBean? {
        return if (mCheckedPosition >= data.size) null else data[mCheckedPosition]
    }

    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var tvCheck = itemView.checkbox
        fun bind(info: MchBean, position: Int) {
            itemView.tv_merchant_name.text = info.mchName

            when (mType) {
                ACTIVATE_DEVICE, BIND_MERCHANT -> {
                    itemView.checkbox.visibility = View.VISIBLE
                    itemView.img_arrow.visibility = View.GONE
                }

                UNBINDING_MERCHANT_DEVICE -> {
                    itemView.checkbox.visibility = View.GONE
                    itemView.img_arrow.visibility = View.VISIBLE
                }
            }
        }


    }


}
