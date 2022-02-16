package com.xhd.td.adapter.home

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.EarningDetailDeveloperBeam
import com.xhd.td.utils.TimeUtils.formatData
import kotlinx.android.synthetic.main.item_device_income.view.*
import java.util.*

/**
 * create by xuexuan
 * time 2019/4/3 14:24
 */
class TotalDeviceIncomeAdapter(context: Context) :
    SimpleRecAdapter<EarningDetailDeveloperBeam, TotalDeviceIncomeAdapter.ViewHolder>(context) {

    override val layoutId: Int get() = R.layout.item_device_income

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)
    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind(info: EarningDetailDeveloperBeam, position: Int) {
            // itemView.tv_number.text = info
            itemView.tv_time.text = formatData(info.profitDate.toLong())
            itemView.tv_refund_status.text = if (Date().time > info.canWithDrawDate.toLong()) "可提现" else "不可提现"
            itemView.tv_income_value1.text = info.profitActualIncomeYuan + " 元"  //收益
            itemView.tv_profit_share_value.text = info.profitOrderYuan + " 元"   //分润

            itemView.tv_refund_value.text = info.profitRefundYuan + " 元" //退款

            itemView.tv_withdrawal_time_value.text = formatData(info.canWithDrawDate.toLong())
        }
    }

}