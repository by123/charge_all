package com.xhd.td.ui.whitelist

import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.whitelist.MyNodeViewFactory
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.WhitelistBean
import com.xhd.td.model.bean.WhitelistMerchantBean
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.whitelist.WhitelistCB
import com.xhd.td.vm.whitelist.WhitelistVM
import kotlinx.android.synthetic.main.fragment_select_whitelist.*
import kotlinx.android.synthetic.main.title_bar.*
import me.texy.treeview.TreeNode
import me.texy.treeview.TreeView
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class SelectWhitelistFragment :
    BaseFragment<com.xhd.td.databinding.FragmentSelectWhitelistBinding, WhitelistVM, WhitelistCB>(),
    WhitelistCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_select_whitelist
    override val viewModel: WhitelistVM
        get() = ViewModelProviders.of(
            this,
            factory
        ).get(WhitelistVM::class.java)

    private lateinit var root: TreeNode<WhitelistBean>
    private var treeView: TreeView<WhitelistBean>? = null

    private var mIsEdit: Boolean = false
    private var mWhitelistId: String? = null
    //是否是第一次获取根数据，第一次获取根节点下面的数据，是由代码自动获取的
    private var mIsFirstRoot: Boolean = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "使用范围"

        root = TreeNode.root()
        buildTree()

        treeView = if (mIsEdit) {
            TreeView(root!!, activity!!, MyNodeViewFactory(mEditNodeCallback))
        } else {
            TreeView(root!!, activity!!, MyNodeViewFactory(mClickNodeCallback))
        }
        val view = treeView!!.getView()
        view.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT
        )
        container.addView(view)

    }


    private fun buildTree() {

        var rootNode = TreeNode<WhitelistBean>(WhitelistBean(UserModel.mchBean?.mchName, UserModel.mchBean?.mchId?:""))
        rootNode.level = 1
        rootNode.isSelected = false
//        if (mIsEdit) {
//            rootNode.isPartialSelected = true
//        }

        root.addChild(rootNode)
        if (mWhitelistId != null) {
            viewModel.queryWhiteListNodeTree(mWhitelistId!!, rootNode.value.mchId, rootNode)
        }else{
            //获取根节点下面的数据
            viewModel.queryGraduallyChildMch(rootNode.value.mchId, rootNode)
        }

        mIsFirstRoot = true
    }


    //新建白名单，点击查询子商户或者子代理，没有是否选中的状态
    var mClickNodeCallback: MyNodeViewFactory.ClickNodeCallback = object : MyNodeViewFactory.ClickNodeCallback {
        override fun clickNodeCallback(treeNode: TreeNode<WhitelistBean>, expand: Boolean) {
            if (!treeNode.isLoad) {
                viewModel.queryGraduallyChildMch(treeNode.value.mchId, treeNode)

            }
        }
    }


    //修改白名单，点击查询子商户或者子代理，查看是否选中，并标记
    var mEditNodeCallback: MyNodeViewFactory.ClickNodeCallback = object : MyNodeViewFactory.ClickNodeCallback {
        override fun clickNodeCallback(treeNode: TreeNode<WhitelistBean>, expand: Boolean) {
            if (!treeNode.isLoad) {
                if (mWhitelistId != null) {
                    viewModel.queryWhiteListNodeTree(mWhitelistId!!, treeNode.value.mchId, treeNode)
                }

                if (mIsFirstRoot) {
                    treeView?.toggleNode(treeNode)
                    mIsFirstRoot = false
                }

            }
        }
    }


    fun confirm() {

        //白名单范围选择成功，回到上一个界面
        var selectNodes = treeView?.selectedParentNodes?.map { WhitelistBean(it.value.mChName, it.value.mchId) }

        if (selectNodes != null && selectNodes.isEmpty()) {
            showToast("请选择免费充电的商家")
            return
        }


        if (mIsEdit) {
            //修改白名单范围，bus发送选中的商户结点
            val selectNodesMchId = treeView?.selectedParentNodes?.map { it.value.mchId }
            BusProvider.getBus()
                ?.post(EventMessage<List<WhitelistBean>>(EventKey.WHITELIST_EDIT_RANGE, selectNodes ?: return))
        } else {
            BusProvider.getBus()
                ?.post(EventMessage<List<WhitelistBean>>(EventKey.WHITELIST_SELECT, selectNodes ?: return))
        }
        close()
    }


    override fun handleError(throwable: Throwable) {

    }


    //查询商户，逐级查询
    override fun queryGraduallyChildMchSuccess(beans: List<MchBean>, parentTreeNode: TreeNode<WhitelistBean>) {

        val nodeList = arrayListOf<TreeNode<WhitelistBean>>()
        beans.forEach {
            //添加到treeNode
            var treeNode = TreeNode<WhitelistBean>(WhitelistBean(it.mchName.toString(), it.mchId.toString()))
            //如果是商户，设置level为3

            //商户或者是代理商
            if (it.mchType == 1) treeNode.level = 3 else treeNode.level = 2
            //加到nodelist
            nodeList.add(treeNode)
        }
        treeView?.addNodes(parentTreeNode, nodeList)
        if (parentTreeNode.isSelected) {
            treeView?.selectNodes(nodeList)
        }
        parentTreeNode.isLoad = true


        if (mIsFirstRoot) {
            treeView?.toggleNode(parentTreeNode)
            mIsFirstRoot = false
        }

    }

    override fun queryGraduallyChildMchFail(msg: String) {
        showToast(msg)

    }


    //逐级查询商户\代理，其中包括是否选中白名单，用于编辑的时候展示
    override fun queryWhiteListNodeTreeSuccess(
        beans: List<WhitelistMerchantBean>,
        parentTreeNode: TreeNode<WhitelistBean>?
    ) {

        if (parentTreeNode == null) return
        //修改成功
        val nodeList = arrayListOf<TreeNode<WhitelistBean>>()
        beans.forEach {
            //添加到treeNode
            var treeNode = TreeNode<WhitelistBean>(WhitelistBean(it.mchName, it.mchId))
            //如果是商户，设置level为3

            //商户或者是代理商
            if (it.mchType == 1) treeNode.level = 3 else treeNode.level = 2
            //加到nodelist
            nodeList.add(treeNode)
            if (it.selected == 1) {
                treeNode.isSelected = true
//                            treeView?.selectNode(treeNode)
            } else if (it.selected == 0) {
                treeNode.isSelected = false

            } else if (it.selected == 2) {
                treeNode.isPartialSelected = true
            }

            if (parentTreeNode.isSelected) {
                treeNode.isSelected = true
            }
        }
        treeView?.addNodes(parentTreeNode, nodeList)
        for (node in nodeList) {
            if (node.isSelected) {
                treeView?.selectNode(node)
            }
        }

        parentTreeNode.isLoad = true


        if (mIsFirstRoot) {
            treeView?.toggleNode(parentTreeNode)
            mIsFirstRoot = false
        }

    }

    override fun queryWhiteListNodeTreeFail(msg: String) {
        showToast(msg)

    }


    companion object {
        fun newInstance(isEdit: Boolean = false, whitelistId: String? = null) = SelectWhitelistFragment().apply {
            mIsEdit = isEdit
            mWhitelistId = whitelistId
        }
    }


}