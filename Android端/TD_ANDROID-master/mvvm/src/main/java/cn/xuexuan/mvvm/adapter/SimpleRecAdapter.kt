package cn.xuexuan.mvvm.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import cn.droidlover.xrecyclerview.RecyclerAdapter


/**
 * Created by xuexuan on 2016/11/29.
 */

abstract class SimpleRecAdapter<T, F : RecyclerView.ViewHolder>(context: Context) : RecyclerAdapter<T, F>(context) {

    abstract val layoutId: Int

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): F {
        val view = LayoutInflater.from(parent.context).inflate(layoutId, parent, false)
        return newViewHolder(view)
    }

    abstract fun newViewHolder(itemView: View): F



}
