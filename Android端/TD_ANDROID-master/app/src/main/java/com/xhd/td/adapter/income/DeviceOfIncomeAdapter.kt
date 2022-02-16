package com.xhd.td.adapter.income

import android.content.Context
import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.databinding.ItemDeviceOfIncomeBinding
import com.xhd.td.model.bean.IncomeTopBeam

/**
 * create by xuexuan
 * time 2019/4/4 15:36
 */
class DeviceOfIncomeAdapter(context: Context) : SimpleRecAdapter<IncomeTopBeam, DeviceOfIncomeAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_device_of_income

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.binding?.bean = data[position]
    }

    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var binding: ItemDeviceOfIncomeBinding? = DataBindingUtil.bind(itemView)
        fun bind(info: IncomeTopBeam, position: Int) {
            // itemView.tv_number.text = info

        }
    }

}