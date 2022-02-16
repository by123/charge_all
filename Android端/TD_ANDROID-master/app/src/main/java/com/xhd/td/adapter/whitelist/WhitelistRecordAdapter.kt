package com.xhd.td.adapter.whitelist

import android.content.Context
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.R
import com.xhd.td.model.bean.Row
import com.xhd.td.utils.loadCirclePic


/**
 * create by xuexuan
 * time 2019/3/21 11:06
 */

class WhitelistRecordAdapter( context: Context) :
    SimpleRecAdapter<Row, com.xhd.td.adapter.whitelist.WhitelistRecordAdapter.ViewHolder>(context) {


    lateinit var statusWhitelistClick: RecyclerItemCallback<Row, ViewHolder>
    lateinit var editWhitelistClick: RecyclerItemCallback<Row, ViewHolder>
    lateinit var copyWhitelistClick: RecyclerItemCallback<Row, ViewHolder>

    override val layoutId: Int get() = R.layout.item_whitelist

    override fun newViewHolder(itemView: View): WhitelistRecordAdapter.ViewHolder {

        return ViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        var whitelistItem = data[position]

        var imgUrl = whitelistItem.tblUserUnionid?.headUrl

        loadCirclePic(context, imgUrl, holder.portrait,R.drawable.ic_wechat_default_avatar)

//        Glide.with(topActivity!!)
//                .load(imgUrl)
//                .apply {RequestOptions.bitmapTransform(CircleCrop())}
//                .into(holder.portrait)
        holder.nickname.text = whitelistItem.tblOrderWhiteList.userName

        if (whitelistItem.tblOrderWhiteList.whiteListState == 1) {

            holder.textStatus.text = "正常"
            holder.imgStatus.setImageResource(R.drawable.ic_whitelist_enable)

            holder.openWhitelist.text = "禁用"

            val img = context.resources.getDrawable(R.drawable.ic_close_whitelist)
            // 调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
            img.setBounds(0, 0, img.minimumWidth, img.minimumHeight)
            holder.openWhitelist.setCompoundDrawables(img, null, null, null)


        } else if (whitelistItem.tblOrderWhiteList.whiteListState == 2) {
//            holder.openWhitelist.setbo
            holder.textStatus.text = "禁用"
            holder.imgStatus.setImageResource(R.drawable.ic_whitelist_disable)
            holder.openWhitelist.text = "启用"
            val img = context.resources.getDrawable(R.drawable.ic_open_whitelist)
            // 调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
            img.setBounds(0, 0, img.minimumWidth, img.minimumHeight)
            holder.openWhitelist.setCompoundDrawables(img, null, null, null)

        }

        holder.openWhitelist.setOnClickListener {
            //第三个参数，表示是否禁用和开启，如果禁用就去开启，如果开启就禁用
            statusWhitelistClick.onItemClick(
                position,
                whitelistItem,
                whitelistItem.tblOrderWhiteList.whiteListState,
                holder
            )
        }

        holder.scopeWhitelist.setOnClickListener {
            editWhitelistClick.onItemClick(position, whitelistItem, 1, holder)
        }

        holder.copyWhitelist.setOnClickListener {
            copyWhitelistClick.onItemClick(position, whitelistItem, 1, holder)
        }

    }



    fun openOrClose(holder:ViewHolder,position:Int){
        //修改成功
        var previousStatus = data[position].tblOrderWhiteList.whiteListState
        if (previousStatus == 2) {
            holder.textStatus.text = "开启"
            holder.imgStatus.setImageResource(R.drawable.ic_whitelist_enable)
            holder.openWhitelist.text = "禁用"
            val img = context.resources.getDrawable(R.drawable.ic_close_whitelist)
            // 调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
            img.setBounds(0, 0, img.minimumWidth, img.minimumHeight)
            holder.openWhitelist.setCompoundDrawables(img, null, null, null)
            data[position].tblOrderWhiteList.whiteListState = 1
        } else {
            holder.textStatus.text = "禁用"
            holder.imgStatus.setImageResource(R.drawable.ic_whitelist_disable)
            holder.openWhitelist.text = "启用"
            val img = context.resources.getDrawable(R.drawable.ic_open_whitelist)
            // 调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
            img.setBounds(0, 0, img.minimumWidth, img.minimumHeight)
            holder.openWhitelist.setCompoundDrawables(img, null, null, null)
            data[position].tblOrderWhiteList.whiteListState = 2
        }
    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val portrait = itemView.findViewById<ImageView>(R.id.img_portrait)
        val nickname = itemView.findViewById<TextView>(R.id.tv_nickname)
        val textStatus = itemView.findViewById<TextView>(R.id.tv_status_value)
        val imgStatus = itemView.findViewById<ImageView>(R.id.img_status)
        val openWhitelist = itemView.findViewById<TextView>(R.id.tv_open_whitelist)
        val scopeWhitelist = itemView.findViewById<TextView>(R.id.tv_scope_whitelist)
        val copyWhitelist = itemView.findViewById<TextView>(R.id.tv_copy_whitelist)
    }
}


interface RecyclerItemCallback<T, F> {
    /**
     * 单击事件
     *
     * @param position 位置
     * @param model    实体
     * @param tag      标签
     * @param holder   控件
     */
    fun onItemClick(position: Int, model: T, tag: Int, holder: F) {}

    /**
     * 长按事件
     *
     * @param position 位置
     * @param model    实体
     * @param tag      标签
     * @param holder   控件
     */
    fun onItemLongClick(position: Int, model: T, tag: Int, holder: F) {}
}
