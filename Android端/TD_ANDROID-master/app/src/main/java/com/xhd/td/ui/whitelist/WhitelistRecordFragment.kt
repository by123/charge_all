package com.xhd.td.ui.whitelist

import android.os.Bundle
import android.view.View
import android.widget.RelativeLayout
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.whitelist.RecyclerItemCallback
import com.xhd.td.adapter.whitelist.WhitelistRecordAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentWhitelistRecordBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.EditWhitelistBean
import com.xhd.td.model.bean.Row
import com.xhd.td.model.bean.TblOrderWhiteList
import com.xhd.td.model.bean.WhitelistItemBean
import com.xhd.td.view.CustomDialog
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.whitelist.WhitelistCB
import com.xhd.td.vm.whitelist.WhitelistVM
import kotlinx.android.synthetic.main.fragment_whitelist_record.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class WhitelistRecordFragment : BaseFragment<FragmentWhitelistRecordBinding, WhitelistVM, WhitelistCB>(),
    WhitelistCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_whitelist_record
    override val viewModel: WhitelistVM
        get() = ViewModelProviders.of(
            this,
            factory
        ).get(WhitelistVM::class.java)


    lateinit var mListLayout: LoadMoreView<Row, WhitelistRecordAdapter.ViewHolder>

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        registerEventBus()
        toolBar.setNavigationOnClickListener { close() }
        title.text = "白名单记录"

        //创建adapter，并设置点击回调事件
        val listAdapter = WhitelistRecordAdapter(context!!)

        listAdapter.statusWhitelistClick = object : RecyclerItemCallback<Row, WhitelistRecordAdapter.ViewHolder> {
            override fun onItemClick(position: Int, model: Row, tag: Int, holder: WhitelistRecordAdapter.ViewHolder) {
                super.onItemClick(position, model, tag, holder)
//                showDialog("启用白名单", "是否启用白名单", )
                var status = tag
                var text = ""
                if (tag == 1) {
                    status = 2
                    text = "禁用"
                } else if (tag == 2) {
                    status = 1
                    text = "启用"
                }

                showDialog("${text}白名单", "请确认是否${text}该用户为白名单", object : CustomDialog.ClickBack {
                    override fun determine() {
                        openOrCloseWhitelist(status,model.tblOrderWhiteList.orderWhiteListId, position, holder)
                    }
                })

            }
        }
        listAdapter.editWhitelistClick = object : RecyclerItemCallback<Row, WhitelistRecordAdapter.ViewHolder> {
            override fun onItemClick(position: Int, model: Row, tag: Int, holder: WhitelistRecordAdapter.ViewHolder) {
                super.onItemClick(position, model, tag, holder)

                start(EditWhitelistFragment.newInstance(model.tblOrderWhiteList))

                //跳转到树形结点选择界面
            }
        }

        listAdapter.copyWhitelistClick = object : RecyclerItemCallback<Row, WhitelistRecordAdapter.ViewHolder> {
            override fun onItemClick(position: Int, model: Row, tag: Int, holder: WhitelistRecordAdapter.ViewHolder) {
                super.onItemClick(position, model, tag, holder)

                showDialog("复制白名单", "新的白名单客户将复制此客户的使用范围", object : CustomDialog.ClickBack {
                    override fun determine() {
                        //使用白名单id，和白名单名称，
                        BusProvider.getBus()?.post(EventMessage<TblOrderWhiteList>(EventKey.WHITELIST_COPY, model.tblOrderWhiteList))
                        pop()
                    }
                })
            }
        }


        mListLayout = LoadMoreView(context!!, listAdapter) { pageId: Int -> getList(pageId) }

        val view = mListLayout.initView()
        val lp = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT
        )

        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT)//与父容器的左侧对齐
        lp.addRule(RelativeLayout.ALIGN_PARENT_TOP)//与父容器的上侧对齐
//      view.setId(1)//设置这个View 的id
        view.layoutParams = lp//设置布局参数
        rl_content.addView(view)


    }



    private fun showDialog(title: String, content: String, callback: CustomDialog.ClickBack) {
        val customDialog = CustomDialog(context!!)
        customDialog.setContentText(content)
        customDialog.setTitleText(title)
        customDialog.back = callback
        customDialog.show()
    }



    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        getList(START_PAGE_ID)
    }


    //关闭或者打开白名单，关闭
    fun openOrCloseWhitelist(status: Int, orderWhiteListId: String,position:Int, holder: WhitelistRecordAdapter.ViewHolder) {
        viewModel.editOrderWhiteList(EditWhitelistBean(orderWhiteListId = orderWhiteListId, whiteListState = status),holder,position)
    }


    //添加白名单
    fun addWhitelist() {
        //跳转到条件白名单界面
//        startWithPop(WhitelistFragment.newInstance())
        pop()
    }




    private fun getList(pageId: Int) {

        if (pageId == Constants.START_PAGE_ID) {
            mListLayout.clearData()
        }
        viewModel.getWhitelistRecordPage(pageId = pageId)
    }


    override fun getWhitelistRecordSuccess(data: WhitelistItemBean) {
        //根据分页的数量和总数据是否为0 ，显示不同的界面
        mListLayout.setTotal(data.pageId, data.pageCount, data.totalCount)
        mListLayout.mAdapter.addData(data.rows)

    }

    override fun getWhitelistRecordFail(msg: String?) {
        msg?.let { showToast(it) }
        mListLayout.setRefreshState(false)
    }


    override fun editOrderWhiteListSuccess(msg: String,holder: WhitelistRecordAdapter.ViewHolder?,position: Int?) {
        if (holder == null) return
        (mListLayout.mAdapter as WhitelistRecordAdapter).openOrClose(holder,position?:0)
    }

    override fun editOrderWhiteListFail(msg: String) {
        showToast(msg)
    }



    override fun handleError(throwable: Throwable) {

    }

     /**
      * 处理rxBus数据
      */
     private fun registerEventBus() {

         BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
             .subscribe { eventMessage ->
               when (eventMessage.tag) {
                   EventKey.WHITELIST_REFRESH -> {
                        mListLayout.initListData()
                   }
               }
           }.addTo(viewModel.compositeDisposable)
    }


    companion object {
        fun newInstance() = WhitelistRecordFragment()
        const val START_PAGE_ID = 1
    }


}