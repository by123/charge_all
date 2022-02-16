package com.xhd.td.adapter.home

import android.content.Context
import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.databinding.ItemReportMerchantAdapterBinding
import com.xhd.td.model.bean.DevMchListBean
import com.xhd.td.utils.TimeUtils
import com.xhd.td.utils.gradeNameForMchTypeAndLevel
import kotlinx.android.synthetic.main.item_report_merchant_adapter.view.*


/**
 * create by xuexuan
 * 开发商户数
 *
 */
class TotalMerchantAdapter(context: Context,var mchNameClick:(String)->Unit) :
    SimpleRecAdapter<DevMchListBean, TotalMerchantAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = com.xhd.td.R.layout.item_report_merchant_adapter


    override fun newViewHolder(itemView: View): ViewHolder {
        val binding :ItemReportMerchantAdapterBinding? = DataBindingUtil.bind(itemView)
        return ViewHolder(itemView,binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.binding?.bean = data[position]
        holder.binding?.type = mDevelopType
        holder.binding?.adapter = this
        holder.binding?.executePendingBindings()
        holder.bind(data[position], position)

        holder.itemView.setOnClickListener { view ->
            if (null != recItemClick && holder.isAgent) {
                recItemClick.onItemClick(position, data[position], 0, holder)
            }
        }
        holder.itemView.tv_agent_name_value.setOnClickListener { mchNameClick(data[position].mchId) }
    }

    var mDevelopType = DIRECT

    /**
     *  直属拓展显示项：
     *  1、代理商名称
     *  2、代理商类型
     *  3、联系人
     *  4、开通日期
     *  5、关联业务员
     *  6、查看详情，商户 不显示 ，代理 显示
     *
     *  下级拓展代理显示项：
     *  1、代理商名称
     *  2、代理商类型
     *  3、拓展代理数量
     *  4、拓展商户数量
     *  5、查看详情
     *
     *  下级拓展商户显示项：
     *  1、代理商名称
     *  2、代理商类型
     *  3、设备数量
     *  4、开通时间
     */
    inner class ViewHolder(itemView: View, var binding : ItemReportMerchantAdapterBinding?) : RecyclerView.ViewHolder(itemView) {


        var isAgent = false
        fun bind(info: DevMchListBean, position: Int) {

//            itemView.tv_agent_name_value.text = info.mchName
            itemView.tv_agent_type_value.text = gradeNameForMchTypeAndLevel(info.mchType ,info.level)

            //判断是否是代理商
             isAgent = info.mchType == 0
            if(mDevelopType == DIRECT){
                itemView.tv_contact_value.text = info.contactUser
                itemView.tv_time_value.text = TimeUtils.formatDataTime(info.createTime)
                itemView.tv_salesman_value.text = info.salesName
            }else if (mDevelopType == DESCENDANT){
                if (isAgent){
                    itemView.tv_agent_num_value.text = info.agentCount.toString()
                    itemView.tv_merchant_num_value.text = info.tenantCount.toString()
                }else{
                    itemView.tv_devices_num_value.text = info.deviceCount.toString()
                    itemView.tv_time_value.text = TimeUtils.formatDataTime(info.createTime)
                }
            }
        }
    }

    companion object{
        const val DIRECT = 1
        const val DESCENDANT  = 2
    }
}