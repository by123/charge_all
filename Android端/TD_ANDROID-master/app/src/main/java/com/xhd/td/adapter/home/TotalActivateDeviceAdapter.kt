package com.xhd.td.ui.home

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.ActiveDeviceListBean
import com.xhd.td.utils.gradeNameForMchTypeAndLevel
import kotlinx.android.synthetic.main.item_report_activate_device__adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class TotalActivateDeviceAdapter(context: Context,var mchNameClick:(String)->Unit) :
    SimpleRecAdapter<ActiveDeviceListBean, TotalActivateDeviceAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_report_activate_device__adapter

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)

        holder.itemView.setOnClickListener { view ->
            if (null != recItemClick && holder.isAgent) {
                recItemClick.onItemClick(position, data[position], 0, holder)
            }
        }
        holder.itemView.tv_agent_name_value.setOnClickListener { mchNameClick(data[position].mchId) }
    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var isAgent = false
        fun bind(info: ActiveDeviceListBean, position: Int) {

            itemView.tv_agent_name_value.text = info.mchName
            itemView.tv_agent_type_value.text = gradeNameForMchTypeAndLevel(info.mchType,info.level)
            itemView.tv_contact_value.text = info.contactUser
            itemView.tv_num_value.text = info.activeNum.toString()

            if (info.mchType == 0) {
                //0：代理  1  ：商户
                itemView.tv_detail.visibility = View.VISIBLE
                isAgent = true
            }else if (info.mchType == 1){
                itemView.tv_detail.visibility = View.GONE
                isAgent = false
            }
        }
    }


}