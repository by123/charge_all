package com.xhd.td.adapter.whitelist

import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.xhd.td.R
import com.xhd.td.model.bean.WhitelistBean
import me.texy.treeview.TreeNode
import me.texy.treeview.base.CheckableNodeViewBinder

/**
 * Created by zxy on 17/4/23.
 */

class SecondLevelNodeViewBinder(itemView: View?,var clickNodeCallback: MyNodeViewFactory.ClickNodeCallback) : CheckableNodeViewBinder<WhitelistBean>(itemView) {

    internal var textView: TextView
    internal var imageView: ImageView

    init {
        textView = itemView?.findViewById<View>(R.id.node_name_view) as TextView
        imageView = itemView.findViewById<View>(R.id.arrow_img) as ImageView
    }

    override fun getCheckableViewId(): Int {
        return R.id.check_button
    }

    override fun getLayoutId(): Int {
        return R.layout.item_second_level
    }

    override fun bindView(treeNode: TreeNode<WhitelistBean>) {
        textView.text = treeNode.value.mChName
        imageView.rotation = (if (treeNode.isExpanded) 180 else 0).toFloat()
    }

    override fun onNodeToggled(treeNode: TreeNode<WhitelistBean>, expand: Boolean) {
        if (expand) {
            imageView.animate().rotation(180f).setDuration(200).start()
            clickNodeCallback.clickNodeCallback(treeNode,expand)
        } else {
            imageView.animate().rotation(0f).setDuration(200).start()
        }
    }
}
