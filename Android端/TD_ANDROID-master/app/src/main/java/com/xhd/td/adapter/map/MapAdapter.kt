package com.xhd.td.adapter.map

import android.content.Context
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.amap.api.services.core.PoiItem
import com.xhd.td.R
import kotlinx.android.synthetic.main.item_map_adapter.view.*


/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class MapAdapter(context: Context, var clickListener: (Int) -> Unit) :
    SimpleRecAdapter<PoiItem, MapAdapter.ViewHolder>(context) {
    override val layoutId: Int get() = R.layout.item_map_adapter
    private var selectPosition = -1

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView!!)
    }

    public fun setDataAndSelectPosition(data: List<PoiItem>?) {
        setData(data)
        this.selectPosition = -1

    }

    public fun setSelectPosition(position: Int) {
        this.selectPosition = position
        notifyDataSetChanged()
    }

    public fun getSelectPositon(): Int {
        return selectPosition
    }


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(data[position], position)
        holder.itemView.tag = position

        if (position == selectPosition){
            holder.itemView.img_check.setBackgroundResource(R.drawable.vector_item_selected)
        }else{
            holder.itemView.img_check.setBackgroundResource(R.drawable.vector_item_normal)
        }

        holder.itemView.setOnClickListener { view ->
            val position = view.tag as Int
            setSelectPosition(position)
//            clickListener(position)
            if (null != recItemClick) {
                recItemClick.onItemClick(position, data[position], 0, holder)
            }
        }

    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        fun bind(poiItem: PoiItem, position: Int) {
            // itemView.tv_number.text = info
            if (position == 0) {
                itemView.tv_title.text = poiItem.provinceName + poiItem.cityName + poiItem.adName + poiItem.snippet
                itemView.tv_message.visibility = View.GONE
            } else {
                itemView.tv_title.text = poiItem.title
                itemView.tv_message.text = poiItem.provinceName + poiItem.cityName + poiItem.adName + poiItem.snippet
            }
        }
    }

}