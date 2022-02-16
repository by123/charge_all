package com.xhd.td.adapter.income

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.constants.Constants
import com.xhd.td.model.bean.WithDrawResultBean
import com.xhd.td.utils.TimeUtils.formatDataTime
import kotlinx.android.synthetic.main.item_withdraw_adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class WithdrawListAdapter(context: Context) :
    SimpleRecAdapter<WithDrawResultBean, WithdrawListAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_withdraw_adapter

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
        fun bind(info: WithDrawResultBean, position: Int) {

            itemView.tv_time.text = formatDataTime(info.createTime)
            itemView.tv_withdraw_status.text = getStatus(info.withdrawState)
            itemView.tv_account_value.text = info.accountName
            itemView.tv_withdraw_amount_value.text = info.withdrawMoneyTotalYuan + " 元"
            itemView.tv_fail_reason.visibility = if (info.withdrawState != 3) View.GONE else View.VISIBLE
            itemView.line2.visibility = if (info.withdrawState != 3) View.GONE else View.VISIBLE
//            itemView.tv_fee_value.text = info.auxiliaryExpensesYuan + " 元"
            itemView.tv_arrival_amount_value.text = info.withdrawMoneyYuan + " 元"
            if (info.isPublic == Constants.CARD_WECHAT_PAY) {

                itemView.tv_card.text = "提现方式"
                itemView.tv_card_no.text = info.bankName
                itemView.tv_account.text = "微信昵称"
            } else {

                itemView.tv_card.text = "银行卡号"
                itemView.tv_account.text = "账户名称"
                itemView.tv_card_no.text = info.bankId
            }
        }
    }

    private fun getStatus(status: Int): String {
        return when (status) {
            3 -> "提现失败"
            2 -> "提现成功"
            else -> "提现中"
        }
    }

}