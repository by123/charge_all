package com.xhd.td.ui.income

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.EarningDetailDeveloperBeam
import com.xhd.td.utils.TimeUtils.formatData
import kotlinx.android.synthetic.main.item_income_list_adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class IncomeListAdapter(context: Context) :
    SimpleRecAdapter<EarningDetailDeveloperBeam, IncomeListAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_income_list_adapter

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        var item = data[position]
        holder.bind(data[position], position)


        holder.itemView.setOnClickListener { v ->
            if (null != recItemClick) {
                recItemClick.onItemClick(position, item, 0, holder)
            }
        }

    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind(info: EarningDetailDeveloperBeam, position: Int) {
            // itemView.tv_number.text = info
//            val proTime =
//            val timeTemp = proTime.split("-").toMutableList()
//            if (timeTemp[1].toInt() == 12) timeTemp[1] = "-01-" else {
//                timeTemp[1] = "-" + (timeTemp[1].toInt() + 1).toString() + "-"
//            }
//            timeTemp[2] = "01"
            itemView.tv_income_value1.text = info.profitActualIncomeYuan + "  元" //收益
            itemView.tv_time_value.text = formatData(info.profitDate.toLong())
            itemView.layout.setOnClickListener {
                //点击每一项，跳转界面
//                skipFragment(IncomeDetail.newInstance(proTime))
            }

        }
    }


}