package cn.xuexuan.mvvm.adapter

/**
 * Created by xuexuan on 2016/12/1.
 */

abstract class ListItemCallback<T> {

    fun onItemClick(position: Int, model: T, tag: Int) {}

    fun onItemLongClick(position: Int, model: T, tag: Int) {}
}
