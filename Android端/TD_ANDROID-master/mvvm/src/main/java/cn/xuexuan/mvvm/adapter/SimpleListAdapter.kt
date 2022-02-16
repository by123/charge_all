package cn.xuexuan.mvvm.adapter

import android.content.Context
import android.view.View
import android.view.ViewGroup

/**
 * Created by xuexuan on 2016/12/1.
 */

abstract class SimpleListAdapter<T, H> : XListAdapter<T> {

    protected abstract val layoutId: Int

    constructor(context: Context) : super(context)

    constructor(context: Context, callback: ListItemCallback<T>) : super(context, callback)

    constructor(context: Context, data: List<T>) : super(context, data)

    override fun getView(position: Int, convertView: View, parent: ViewGroup): View {

        var convertView = convertView
        var holder: H? = null
        val item = data[position]

        if (convertView == null) {
            convertView = View.inflate(context, layoutId, null)
            holder = newViewHolder(convertView)

            convertView.tag = holder
        } else {
            holder = convertView.tag as H
        }

        convert(holder, item, position)

        return convertView
    }

    protected abstract fun newViewHolder(convertView: View?): H

    protected abstract fun convert(holder: H?, item: T, position: Int)
}
