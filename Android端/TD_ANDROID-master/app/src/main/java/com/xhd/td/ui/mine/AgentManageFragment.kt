package com.xhd.td.ui.mine

import android.os.Bundle
import android.view.View
import android.widget.RelativeLayout
import androidx.appcompat.widget.SearchView
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.mine.ManageAgentAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentManageAgentBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.PageBean
import com.xhd.td.model.bean.QueryAgentMchBean
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.home.SelectMerchantCB
import com.xhd.td.vm.home.SelectMerchantVM
import kotlinx.android.synthetic.main.fragment_search_order.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class AgentManageFragment : BaseFragment<FragmentManageAgentBinding, SelectMerchantVM, SelectMerchantCB>(),
    SelectMerchantCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_manage_agent
    override val viewModel: SelectMerchantVM
        get() = ViewModelProviders.of(
            this,
            factory
        ).get(SelectMerchantVM::class.java)


    private lateinit var mMerchantListLayout: LoadMoreView<MchBean, ManageAgentAdapter.ViewHolder>

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "代理商列表"

        mMerchantListLayout =
            LoadMoreView(
                context!!,
                ManageAgentAdapter(context!!) { mchId -> start(AgentMerchantDetailFragment.newInstance(mchId)) }) { pageId: Int ->
                getMerchantList(
                    pageId
                )
            }

        val view = mMerchantListLayout.initView()
        val lp = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT
        )

        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT)//与父容器的左侧对齐
        lp.addRule(RelativeLayout.ALIGN_PARENT_TOP)//与父容器的上侧对齐
////        view.setId(1)//设置这个View 的id
        view.layoutParams = lp//设置布局参数
        rl_content.addView(view)

        search_view.setOnClickListener { search_view.onActionViewExpanded() }

        search_view.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean {
                getMerchantList(Constants.START_PAGE_ID,query)

                return true
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                search_view.isSubmitButtonEnabled = !newText.isNullOrEmpty()
                return false
            }
        })
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        getMerchantList(Constants.START_PAGE_ID)
    }

    private fun getMerchantList(pageId: Int,keyword:String? = null) {

        if (pageId == Constants.START_PAGE_ID ){
            mMerchantListLayout.mAdapter.clearData()
        }

        viewModel.getAgentAndMerchant(QueryAgentMchBean(mchId = UserModel.mchBean?.mchId?:"",mchName = keyword,pageId = pageId))
    }

    override fun handleError(throwable: Throwable) {

    }

    override fun getAgentAndMerchantSuccess(data: PageBean<MchBean>) {

        mMerchantListLayout.setTotal(data.pageId, data.pageCount, data.totalCount)
        //如果是分页加载，这里需要使用addData。因为不是分页，所以使用
        mMerchantListLayout.mAdapter.addData(data.rows)

    }

    override fun getAgentAndMerchantFail(msg: String?) {
        msg?.let { showToast(it) }
        mMerchantListLayout.setRefreshState(false)
    }

    companion object {
        fun newInstance() = AgentManageFragment()
        const val START_PAGE_ID = 1
    }


}