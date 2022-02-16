package com.xhd.td.adapter.mine

import android.content.Context
import android.view.View
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.constants.Constants
import com.xhd.td.model.bean.Bank
import com.xhd.td.model.bean.TblUserUnionid
import com.xhd.td.utils.loadCirclePic
import kotlinx.android.synthetic.main.item_card_list_adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class CardListAdapter(context: Context, var clickListener: (Bank) -> Unit) :
    SimpleRecAdapter<Bank, CardListAdapter.BankHolder>(context) {


    override val layoutId: Int get() = R.layout.item_card_list_adapter
    var mWechatInfo: TblUserUnionid? = null

    override fun newViewHolder(itemView: View): BankHolder {

        return BankHolder(itemView!!)
    }


    override fun onBindViewHolder(holder: CardListAdapter.BankHolder, position: Int) {
        val bank = data[position]
        holder.bind(bank, position)
        holder.itemView.setOnClickListener { clickListener(bank) }
    }


    inner class BankHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind(info: Bank, position: Int) {

            if (info.isPublic == Constants.CARD_WECHAT_PAY) {
                itemView.setBackgroundResource(R.drawable.bg_bank_wechat)
                val img = itemView.findViewById<ImageView>(R.id.img_portrait)
                val url = mWechatInfo?.headUrl
                loadCirclePic(context, url, img, R.drawable.ic_wechat_default_avatar)
                itemView.tv_bank_name.text = "微信零钱"
                itemView.tv_bank_type.text = mWechatInfo?.nickname
                itemView.tv_bank_card_no.visibility = View.GONE
            } else {
                itemView.setBackgroundResource(R.drawable.bg_bank_item)
                itemView.img_portrait.setImageResource(R.drawable.ic_bank_item)
                itemView.tv_bank_name.text = info.bankName
                itemView.tv_bank_type.text = if (info.isPublic == Constants.CARD_PERSONAL) context.resources.getString(R.string.person_card) else context.resources.getString(R.string.company_card)
                //如果没有设置可见，则可能会出现，银行卡号显示不出来的问题。item复用的问题
                itemView.tv_bank_card_no.visibility = View.VISIBLE
                itemView.tv_bank_card_no.text = "**** **** **** "+info.bankId.substring(info.bankId.length - 4, info.bankId.length)

            }
        }
    }


    fun setWechatInfo(wechat: TblUserUnionid) {
        mWechatInfo = wechat
    }

    companion object {
        var WECHAT_PAY = 1
        var BANK_CARD = 2
    }
}