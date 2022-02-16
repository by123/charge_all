package com.xhd.td.adapter.taxi

import android.content.Context
import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.TaxiGroupBean


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class TaxiListAdapter(context: Context, var editTaxiGroup: (TaxiGroupBean) -> Unit, var addDevice: (String,String) -> Unit) :
    SimpleRecAdapter<TaxiGroupBean, TaxiListAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_taxi_list_adapter

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
//        holder.bind(data[position], position)
        holder.binding?.bean = data[position]

        holder.binding?.adapter = this

    }


    fun btnEdit(bean:TaxiGroupBean){
        editTaxiGroup(bean)
    }


    fun btnAddDevice(bean:TaxiGroupBean){
        bean.groupId?.let { addDevice(it,bean.groupName) }
    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var binding: com.xhd.td.databinding.ItemTaxiListAdapterBinding? = DataBindingUtil.bind(itemView)
        fun bind(info: TaxiGroupBean, position: Int) {
            // itemView.tv_number.text = info

        }
    }


}