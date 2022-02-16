package com.xhd.td.ui.whitelist

import android.os.Bundle
import android.view.View
import android.widget.RelativeLayout
import androidx.lifecycle.ViewModelProviders
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.xuexuan.mvvm.event.BusProvider
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.whitelist.SelectWhitelistTimeAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.WhitelistTimeBean
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.whitelist.WhitelistCB
import com.xhd.td.vm.whitelist.WhitelistVM
import kotlinx.android.synthetic.main.fragment_select_whitelist_time.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class SelectWhitelistTimeFragment :
    BaseFragment<com.xhd.td.databinding.FragmentSelectWhitelistTimeBinding, WhitelistVM, WhitelistCB>(),
    WhitelistCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_select_whitelist_time
    override val viewModel: WhitelistVM
        get() = ViewModelProviders.of(this, factory).get(WhitelistVM::class.java)


    lateinit var mListLayout: LoadMoreView<WhitelistTimeBean, SelectWhitelistTimeAdapter.ViewHolder>

    //创建adapter，并设置点击回调事件
    private lateinit var mListAdapter: SelectWhitelistTimeAdapter

    private var mSelectItem: WhitelistTimeBean? = null

    private var mIsEdit = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "充电时长"

        //创建adapter，并设置点击回调事件
        mListAdapter = SelectWhitelistTimeAdapter(context!!, { params -> })

        mListLayout = LoadMoreView(context!!, mListAdapter) { pageId: Int -> getList(pageId) }

        val view = mListLayout.initView()
        val lp = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT
        )

        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT)//与父容器的左侧对齐
        lp.addRule(RelativeLayout.ALIGN_PARENT_TOP)//与父容器的上侧对齐
//      view.setId(1)//设置这个View 的id
        view.layoutParams = lp//设置布局参数
        rl_content.addView(view)

        //列表item 点击监听
        mListAdapter.recItemClick =
            object : RecyclerItemCallback<WhitelistTimeBean, SelectWhitelistTimeAdapter.ViewHolder>() {
                override fun onItemClick(
                    position: Int,
                    model: WhitelistTimeBean?,
                    tag: Int,
                    holder: SelectWhitelistTimeAdapter.ViewHolder?
                ) {
                    super.onItemClick(position, model, tag, holder)
                    mSelectItem = model
                }
            }
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getConfig(Constants.CFG_WHITELIST_TIME_LEVEL)
    }

    override fun getConfigSuccess(key: String, data: String?) {

        if (key == Constants.CFG_WHITELIST_TIME_LEVEL) {
            val list = Gson().fromJson<List<WhitelistTimeBean>>(
                data,
                object : TypeToken<List<WhitelistTimeBean>>() {}.type
            )
            mListLayout.setTotal(list.size)
            mListLayout.mAdapter.setData(list)
        }
    }

    override fun getConfigFail(msg: String?) {
        showToast("获取充电时长失败")
        mListLayout.setRefreshState(false)

    }

    private fun getList(pageId: Int) {
        viewModel.getConfig(Constants.CFG_WHITELIST_TIME_LEVEL)
    }

    override fun handleError(throwable: Throwable) {

    }

    fun confirm() {

        if (mSelectItem == null) {
            showToast("请选择充电时长")
            return
        }

        if (mIsEdit) {
            //修改充电时长
            BusProvider.getBus()?.post(EventMessage<WhitelistTimeBean>(EventKey.WHITELIST_EDIT_TIME_LEVEL, mSelectItem!!))
        } else {
            BusProvider.getBus()?.post(EventMessage<WhitelistTimeBean>(EventKey.WHITELIST_TIME_LEVEL, mSelectItem!!))
        }

        close()
    }

    companion object {
        fun newInstance(isEdit:Boolean = false) = SelectWhitelistTimeFragment().apply {
            mIsEdit = isEdit
        }
        const val START_PAGE_ID = 1
    }


}