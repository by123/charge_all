package com.xhd.td.vm.cb.whitelist

import com.xhd.td.adapter.whitelist.WhitelistRecordAdapter
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.WhitelistBean
import com.xhd.td.model.bean.WhitelistItemBean
import com.xhd.td.model.bean.WhitelistMerchantBean
import me.texy.treeview.TreeNode


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface WhitelistCB {

    fun handleError(throwable: Throwable)

    fun  createWhitelistSuccess(msg: String){}
    fun  createWhitelistFail(msg: String){}

    fun queryWhiteListNodeTreeSuccess(beans:List<WhitelistMerchantBean>,parentTreeNode: TreeNode<WhitelistBean>?){}
    fun queryWhiteListNodeTreeFail(msg: String){}

    fun queryGraduallyChildMchSuccess(beans:List<MchBean>, parentTreeNode: TreeNode<WhitelistBean>){}
    fun queryGraduallyChildMchFail(msg: String){}

    fun editOrderWhiteListSuccess(msg: String,holder: WhitelistRecordAdapter.ViewHolder?,position: Int?){}
    fun editOrderWhiteListFail(msg: String){}


    fun getWhitelistRecordSuccess(bean: WhitelistItemBean){}
    fun getWhitelistRecordFail(msg: String? = null){}


    fun getConfigSuccess(key:String,data: String?){}
    fun getConfigFail(msg:String?){}


}