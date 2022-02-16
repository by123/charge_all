package cn.xuexuan.mvvm.adapter

import android.content.Context
import android.graphics.drawable.Drawable
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import java.util.*

/**
 * Created by xuexuan on 2016/12/1.
 */

abstract class XListAdapter<T> : BaseAdapter {
    protected var data: MutableList<T> = ArrayList()
        set(value) {
            if (data != null) {
                this.data.clear()
                this.data.addAll(data)
            } else {
                this.data.clear()
            }
            notifyDataSetChanged()
        }

    var callback: ListItemCallback<T>? = null
    protected var context: Context


    val dataSource: List<T>?
        get() = data


    val size: Int
        get() = if (data == null) 0 else data.size

    constructor(context: Context) {
        this.context = context
    }

    constructor(context: Context, callback: ListItemCallback<T>) : this(context) {
        this.callback = callback
    }

    constructor(context: Context, data: List<T>) {
        this.context = context
        this.data.clear()
        this.data.addAll(data)
        notifyDataSetChanged()
    }

//    fun setData(data: List<T>?) {
//
//    }


//    fun setData(data: Array<T>?) {
//        if (data != null && data.size > 0) {
//            setData(Arrays.asList(*data))
//        }
//    }


    fun addData(data: List<T>?) {
        if (data != null && data.size > 0) {
            if (this.data == null) {
                this.data = ArrayList()
            }
            this.data.addAll(data)
            notifyDataSetChanged()
        }
    }


    fun addData(data: Array<T>) {
        addData(Arrays.asList(*data))
    }

    fun removeElement(element: T) {
        if (data.contains(element)) {
            data.remove(element)
            notifyDataSetChanged()
        }
    }

    fun removeElement(position: Int) {
        if (data != null && data.size > position) {
            data.removeAt(position)
            notifyDataSetChanged()
        }
    }

    fun removeElements(elements: List<T>?) {
        if (data != null && elements != null && elements.size > 0
            && data.size >= elements.size
        ) {

            for (element in elements) {
                if (data.contains(element)) {
                    data.remove(element)
                }
            }

            notifyDataSetChanged()
        }
    }

    fun removeElements(elements: Array<T>?) {
        if (elements != null && elements.size > 0) {
            removeElements(Arrays.asList(*elements))
        }
    }

    fun updateElement(element: T, position: Int) {
        if (position >= 0 && data.size > position) {
            data.removeAt(position)
            data.add(position, element)
            notifyDataSetChanged()
        }
    }

    fun addElement(element: T?) {
        if (element != null) {
            if (this.data == null) {
                this.data = ArrayList()
            }
            data.add(element)
            notifyDataSetChanged()
        }
    }

    fun clearData() {
        if (this.data != null) {
            this.data.clear()
            notifyDataSetChanged()
        }
    }

    protected fun visible(flag: Boolean, view: View) {
        if (flag)
            view.visibility = View.VISIBLE
    }


    protected fun gone(flag: Boolean, view: View) {
        if (flag)
            view.visibility = View.GONE
    }

    protected fun inVisible(view: View) {
        view.visibility = View.INVISIBLE
    }


    protected fun getDrawable(resId: Int): Drawable {
        return context.resources.getDrawable(resId)
    }


    protected fun getString(resId: Int): String {
        return context.resources.getString(resId)
    }


    protected fun getColor(resId: Int): Int {
        return context.resources.getColor(resId)
    }

    override fun getCount(): Int {
        return if (data == null || data.isEmpty()) 0 else data.size
    }

    override fun getItem(position: Int): Any? {
        return if (data != null) data[position] else null
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    abstract override fun getView(
        position: Int, convertView: View,
        parent: ViewGroup
    ): View


}
