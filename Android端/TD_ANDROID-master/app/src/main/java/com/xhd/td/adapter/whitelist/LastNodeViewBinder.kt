package com.xhd.td.adapter.whitelist

import android.view.View
import android.widget.TextView
import com.xhd.td.R
import com.xhd.td.model.bean.WhitelistBean
import me.texy.treeview.TreeNode
import me.texy.treeview.base.CheckableNodeViewBinder


/**
 * create by xuexuan
 * time 2019/3/19 19:10
 */

class LastNodeViewBinder(itemView: View?) : CheckableNodeViewBinder<WhitelistBean>(itemView) {
    internal var textView: TextView

    init {
        textView = itemView?.findViewById<View>(R.id.node_name_view) as TextView
    }

    override fun getCheckableViewId(): Int {
        return R.id.check_button
    }

    override fun getLayoutId(): Int {
        return R.layout.item_last_level
    }

    override fun bindView(treeNode: TreeNode<WhitelistBean>) {
        textView.text = treeNode.value.mChName

    }
}
