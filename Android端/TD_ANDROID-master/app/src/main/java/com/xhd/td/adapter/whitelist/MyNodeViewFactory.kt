package com.xhd.td.adapter.whitelist

import android.view.View
import com.xhd.td.R
import com.xhd.td.model.bean.WhitelistBean
import me.texy.treeview.TreeNode
import me.texy.treeview.base.BaseNodeViewBinder
import me.texy.treeview.base.BaseNodeViewFactory


/**
 * Created by zxy on 17/4/23.
 */

class MyNodeViewFactory(var clickNodeCallback: ClickNodeCallback) : BaseNodeViewFactory() {
    override fun getLayoutId(level: Int): Int {
        when (level) {
            1 -> return R.layout.item_first_level
            2 -> return R.layout.item_second_level
            3 -> return R.layout.item_last_level
            else -> return R.layout.item_last_level
        }
    }

    override fun getNodeViewBinder(view: View?, level: Int): BaseNodeViewBinder<WhitelistBean>? {
        when (level) {
            1 -> return FirstLevelNodeViewBinder(view,clickNodeCallback)
            2 -> return SecondLevelNodeViewBinder(view,clickNodeCallback)
            3 -> return LastNodeViewBinder(view)
            else -> return null
        }
    }

    interface ClickNodeCallback {
        fun clickNodeCallback(treeNode: TreeNode<WhitelistBean>, expand:Boolean)
    }
}
