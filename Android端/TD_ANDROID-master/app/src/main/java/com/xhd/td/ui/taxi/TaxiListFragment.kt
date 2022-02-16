package com.xhd.td.ui.taxi

import android.os.Bundle
import android.view.View
import android.widget.RelativeLayout
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.taxi.TaxiListAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentTaxiListBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.Pages
import com.xhd.td.model.bean.QueryGroupBean
import com.xhd.td.model.bean.TaxiGroupBean
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.taxi.TaxiGroupCB
import com.xhd.td.vm.taxi.TaxiGroupVM
import kotlinx.android.synthetic.main.fragment_taxi_list.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class TaxiListFragment : BaseFragment<FragmentTaxiListBinding, TaxiGroupVM, TaxiGroupCB>(), TaxiGroupCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_taxi_list
    override val viewModel: TaxiGroupVM get() = ViewModelProviders.of(this, factory).get(TaxiGroupVM::class.java)


    lateinit var mListLayout: LoadMoreView<TaxiGroupBean, TaxiListAdapter.ViewHolder>

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "出租车业务"

        //创建adapter，并设置点击回调事件
        val listAdapter = TaxiListAdapter(context!!,
            { bean -> start(TaxiGroupFragment.newInstance(true, bean)) },
            { groupId, groupName -> start(ScanTaxiActivateDeviceFragment.newInstance(groupId, groupName)) })
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
        registerEventBus()

    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        when (UserModel.mchBean?.mchType) {
            //代理商，获取代理商的业务员
            0 -> viewModel.getSalesman(2)
            //普通商户，获取普通商户的业务员
            1 -> viewModel.getSalesman(3)
        }

        getList(Constants.START_PAGE_ID)
    }


    private fun getList(pageId: Int) {

        if (pageId == Constants.START_PAGE_ID) {
            mListLayout.clearData()
        }
        viewModel.queryGroup(QueryGroupBean(mchId = UserModel.mchBean?.mchId?:"", pageId = pageId))
    }


    fun addTaxiGroup() {
        start(TaxiGroupFragment.newInstance())
    }


    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.TAXI_LIST_REFRESH -> {
                        getList(Constants.START_PAGE_ID)
                    }
                }
            }.addTo(viewModel.compositeDisposable)
    }


    private var mLayoutEmpty: View? = null


    override fun queryGroupSuccess(data: Pages<TaxiGroupBean>) {
        //根据分页的数量和总数据是否为0 ，显示不同的界面
        mListLayout.setTotal(data.pageId, data.pageCount, data.totalCount)
        mListLayout.mAdapter.addData(data.rows)

        if (data.totalCount == 0) {
            try {
                mLayoutEmpty = viewStub1.inflate()     //inflate 方法只能被调用一次，
                rl_content.visibility = View.GONE
            } catch (e: Exception) {
                if (mLayoutEmpty != null) {
                    mLayoutEmpty!!.visibility = View.VISIBLE
                }
            }
        } else {
            if (mLayoutEmpty != null) {
                mLayoutEmpty!!.visibility = View.GONE
                rl_content.visibility = View.VISIBLE
            }
        }
    }

    override fun queryGroupFail(msg: String) {
        showToast(msg)
    }


    override fun handleError(throwable: Throwable) {

    }


    companion object {
        fun newInstance() = TaxiListFragment()
        const val START_PAGE_ID = 1
    }


}