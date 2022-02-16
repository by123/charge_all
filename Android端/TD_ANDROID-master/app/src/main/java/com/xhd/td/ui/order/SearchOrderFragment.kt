package com.xhd.td.ui.order

import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.RelativeLayout
import androidx.appcompat.widget.SearchView
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.LinearLayoutManager
import cn.droidlover.xrecyclerview.XRecyclerAdapter
import cn.droidlover.xrecyclerview.XRecyclerView
import com.xhd.td.BR
import com.xhd.td.adapter.order.OrderListAdapter
import com.xhd.td.adapter.order.SelectMerchantForOrderAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.databinding.FragmentSearchOrderBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.*
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.order.OrderCB
import com.xhd.td.vm.order.OrderVM
import kotlinx.android.synthetic.main.fragment_search_order.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class SearchOrderFragment : BaseFragment<FragmentSearchOrderBinding, OrderVM, OrderCB>(), OrderCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val viewModel: OrderVM get() = ViewModelProviders.of(this, factory).get(OrderVM::class.java)

    override val layoutId: Int get() = com.xhd.td.R.layout.fragment_search_order

    //下面的两个变量是用来获取订单列表数据的
    var mQueryKey: String? = null
    var mType: Int = QUERY_MERCHANT

    lateinit var mOrderListLayout: LoadMoreView<OrderBean, OrderListAdapter.ViewHolder>


    private var mAdapter: SelectMerchantForOrderAdapter? = null
    private var mXAdapter: XRecyclerAdapter? = null
    private var mXRecyclerView: XRecyclerView? = null

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "订单查询"
        viewModel.mCallback = this

        initRecyclerView()
        val orderListAdapter = OrderListAdapter(context!!,
            { orderId -> start(OrderDetailFragment.newInstance(orderId)) },
            { orderBean -> start(RefundFragment.newInstance(orderBean)) })

        mOrderListLayout = LoadMoreView(
            context!!,
            orderListAdapter
        ) { pageId: Int ->
            getOrderList(pageId, mQueryKey)
        }

        var view = mOrderListLayout.initView()
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

                when (mType) {
                    QUERY_MERCHANT -> getAgentAndMerchant(Constants.START_PAGE_ID, query)

                    else -> {
                        mQueryKey = query;getOrderList(Constants.START_PAGE_ID, query ?: "")
                    }
                }
                return true
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                search_view.isSubmitButtonEnabled = !newText.isNullOrEmpty()
                if (newText.isNullOrEmpty() && mType == QUERY_MERCHANT){
                    layout_merchant_name.visibility = View.GONE
                }
                return false
            }

        })



        val arrayAdapter = ArrayAdapter<String>(
            _mActivity,
            com.xhd.td.R.layout.search_order_type,
            android.R.id.text1,
            resources.getStringArray(com.xhd.td.R.array.searchOrderType)
        )
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        search_type.adapter = arrayAdapter
        search_type.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onNothingSelected(parent: AdapterView<*>?) {

            }

            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                when (position) {
                    0 -> {
                        //选择商户后，首先需要查询的是商户列表
                        mType = QUERY_MERCHANT
                        search_view.queryHint = "请输入商户名称"
                    }
                    1 -> {
                        mType = QUERY_TYPE_ORDER_ID
                        search_view.queryHint = "请输入订单号"
                    }
                    2 -> {
                        mType = QUERY_TYPE_DEVICE
                        search_view.queryHint = "请输入设备编号"
                    }
                }

            }
        }

        //隐藏查询商户的列表界面
        layout_merchant_name.visibility = View.GONE
        //订单列表界面，显示空界面
        viewModel.getOrderListByKey(QUERY_TYPE_ORDER_ID, null, 1)

    }

    //这个是商户搜索列表的布局初始化
    private fun initRecyclerView() {

        mXRecyclerView = layout_merchant_name.recyclerView

        val layoutManager = LinearLayoutManager(context)
        mXRecyclerView?.layoutManager = layoutManager
        mAdapter = SelectMerchantForOrderAdapter(context = context!!) {
            //点击了查询出来的商户的某一项，就去查询该商户的订单，隐藏商户列表

            //根据商户，查询订单id
            search_view.setQuery(it, false)
            getOrderList(Constants.START_PAGE_ID, it)
        }

        mXAdapter = XRecyclerAdapter(mAdapter)
        mXRecyclerView?.adapter = mXAdapter
    }


    private fun getOrderList(pageId: Int, key: String? = null) {

        if (pageId == Constants.START_PAGE_ID) {
            mOrderListLayout.clearData()
        }
        layout_merchant_name.visibility = View.GONE
        viewModel.getOrderListByKey(mType, key, pageId)
    }


    private fun getAgentAndMerchant(pageId: Int, keyword: String? = null) {

        if (pageId == Constants.START_PAGE_ID) {
            mAdapter?.clearData()
        }
        viewModel.getAgentAndMerchant(
            QueryAgentMchBean(
                mchId = UserModel.mchBean?.mchId ?: "",
                mchName = keyword,
                mchForm = 1,
                pageId = pageId
            )
        )
    }


    override fun handleError(throwable: Throwable?) {
    }


    override fun getOrderListSuccess(data: OrderData, viewPageId: Int) {
        //根据分页的数量和总数据是否为0 ，显示不同的界面
        mOrderListLayout.setTotal(data.pageId, data.pageCount, data.totalCount)
        mOrderListLayout.mAdapter.addData(data.rows)

    }

    override fun getOrderListFail(msg: String?) {
        msg?.let { showToast(it) }
        mOrderListLayout.setRefreshState(false)
    }


    override fun getAgentAndMerchantSuccess(data: PageBean<MchBean>) {

        mXRecyclerView?.setPage(data.pageId, data.pageCount)
        //查询商户成功，需要把商户的recycleview显示出来
        layout_merchant_name.visibility = View.VISIBLE
        mAdapter?.addData(data.rows)
    }

    override fun getAgentAndMerchantFail(msg: String?) {
        msg?.let { showToast(it) }
    }

    companion object {
        fun newInstance() = SearchOrderFragment()

        //        const val QUERY_TYPE_MERCHANT = 1
        const val QUERY_TYPE_ORDER_ID = 2 //查询条件，根据订单号查询
        const val QUERY_TYPE_DEVICE = 3  //查询条件，根据设备id查询
        const val QUERY_MERCHANT = 4 // 查询条件，根据商户查询
        const val START_PAGE_ID = 1

    }


}