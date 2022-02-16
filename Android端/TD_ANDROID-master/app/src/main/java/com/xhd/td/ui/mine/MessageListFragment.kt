package com.xhd.td.ui.mine

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.droidlover.xrecyclerview.XRecyclerView
import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.mine.MessageListAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentMessageListBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.MessageBean
import com.xhd.td.model.bean.PageBean
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.mine.MessageCB
import com.xhd.td.vm.mine.MessageVM
import kotlinx.android.synthetic.main.fragment_message_list.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject



/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class MessageListFragment : BaseFragment<FragmentMessageListBinding, MessageVM, MessageCB>(),
    MessageCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_message_list
    override val viewModel: MessageVM
        get() = ViewModelProviders.of(this, factory).get(
            MessageVM::class.java)

    private var mAdapter: MessageListAdapter? = null
    private var mPageId = Constants.START_PAGE_ID
    private var mXRecyclerView: XRecyclerView? = null


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "消息"

        mAdapter = MessageListAdapter(context!!) {}

        initRecyclerView()
        //打开消息界面，就取消首页的消息红点
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.MESSAGE_RED_ICON, false))

    }


    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        getData(Constants.START_PAGE_ID)
    }

    private fun initRecyclerView() {

        //数据列表的recycleView
        mXRecyclerView = recyclerContentLayout.recyclerView
        mXRecyclerView?.useDefLoadMoreView()

        mAdapter?.recItemClick = object : RecyclerItemCallback<MessageBean, MessageListAdapter.ViewHolder>() {
            override fun onItemClick(
                position: Int,
                model: MessageBean?,
                tag: Int,
                holder: MessageListAdapter.ViewHolder?) {
                super.onItemClick(position, model, tag, holder)
                start(MessageDetailFragment.newInstance(model?.id))
            }
        }

        mXRecyclerView?.setAdapter(mAdapter)
        mXRecyclerView?.verticalLayoutManager(context)

        mXRecyclerView?.onRefreshAndLoadMoreListener = object : XRecyclerView.OnRefreshAndLoadMoreListener {
            override fun onLoadMore(page: Int) {
                getData(page)
            }

            override fun onRefresh() {
                getData(Constants.START_PAGE_ID)
            }
        }
    }


    private fun getData(pageId: Int) {

        mPageId = pageId
        viewModel.queryNoticeMessageList(pageId = pageId)
    }


    override fun getDataSuccess(data: PageBean<MessageBean>) {
        //根据分页的数量和总数据是否为0 ，显示不同的界面
        mXRecyclerView?.setPage(data.pageId, data.pageCount)

        if (mPageId == Constants.START_PAGE_ID) {
            mAdapter?.setData(data.rows)
        } else {
            mAdapter?.addData(data.rows)
        }
    }

    override fun getDataFail(msg: String?) {
        showToast(msg)
    }


    override fun handleError(throwable: Throwable) {

    }


    companion object {
        fun newInstance() = MessageListFragment()
    }


}