package com.xhd.td.ui.home

import android.content.DialogInterface
import android.view.View
import android.widget.SearchView
import androidx.appcompat.app.AlertDialog
import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.LinearLayoutManager
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.droidlover.xrecyclerview.XRecyclerAdapter
import cn.droidlover.xrecyclerview.XRecyclerView
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.BindMerchantBean
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.PageBean
import com.xhd.td.model.bean.QueryAgentMchBean
import com.xhd.td.ui.unbind.UnbindMerchantDeviceFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.home.SelectMerchantCB
import com.xhd.td.vm.home.SelectMerchantVM
import kotlinx.android.synthetic.main.fragment_select_merchant.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject
import kotlin.properties.Delegates
import kotlin.reflect.KProperty


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class SelectMerchantFragment :
    BaseFragment<com.xhd.td.databinding.FragmentSelectMerchantBinding, SelectMerchantVM, SelectMerchantCB>(),
    SelectMerchantCB, SearchView.OnQueryTextListener {


    var saveEnable: ObservableBoolean = ObservableBoolean(false)

    var mSearchKeyword: String by Delegates.observable("") { kProperty: KProperty<*>, s: String, s1: String ->
        //        viewModel.getAgentAndMerchant(s1)
    }

    //当前界面的类型，是激活设备，还是绑定商户
    var mSelectType = ACTIVATE_DEVICE
    var mOpenId: String = ""
    var mUnionid: String = ""
    var mType: String = ""

    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int? get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_select_merchant
    override val viewModel: SelectMerchantVM
        get() = ViewModelProviders.of(this, factory).get(SelectMerchantVM::class.java)

    lateinit var mAdapter: SelectMerchantAdapter
    lateinit var mXAdapter: XRecyclerAdapter
    var mXRecyclerView: XRecyclerView? = null

    var mMerchantList: ArrayList<MchBean> = arrayListOf()

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }

        initRecyclerView()

        //默认展开搜索框
        searchView.onActionViewExpanded()
        searchView.clearFocus()
        //搜索框展开的时候显示的提示语言
        searchView.queryHint = "请输入商户信息搜索"
        searchView.setOnQueryTextListener(this)
        recyclerContentLayout.swipeRefreshLayout.setOnRefreshListener {
            getTotalData(Constants.START_PAGE_ID)
        }
        //获取全部代理和商户
        getTotalData(Constants.START_PAGE_ID)
        when (mSelectType) {
            ACTIVATE_DEVICE -> {
                title.text = "激活设备"
                tv_title_hint.text = "选择激活设备的商户"
                btn_activate.text = "开始激活"
            }
            BIND_MERCHANT -> {
                title.text = "绑定商户"
                tv_title_hint.text = "选择需要绑定的商户"
                btn_activate.text = "确定"
            }
            UNBINDING_MERCHANT_DEVICE -> {
                title.text = "按商户解绑设备"
                tv_title_hint.text = "选择需要解绑设备的商户"
                btn_activate.visibility = View.GONE
                tv_unbinding_tip.visibility = View.VISIBLE
            }
        }

    }

    lateinit var mAdapterClick: RecyclerItemCallback<MchBean, SelectMerchantAdapter.ViewHolder>


    override fun onSupportVisible() {
        super.onSupportVisible()
        searchView.clearFocus()
    }

    private fun initRecyclerView() {

        when (mSelectType) {
            ACTIVATE_DEVICE, BIND_MERCHANT -> {
                mAdapterClick = object : RecyclerItemCallback<MchBean, SelectMerchantAdapter.ViewHolder>() {
                    override fun onItemClick(
                        position: Int,
                        model: MchBean?,
                        tag: Int,
                        holder: SelectMerchantAdapter.ViewHolder?
                    ) {
                        super.onItemClick(position, model, tag, holder)
                        //有选中的商户，激活按钮就可以点击
                        saveEnable.set(model?.isSelected ?: false)
                    }
                }
            }

            UNBINDING_MERCHANT_DEVICE -> {
                mAdapterClick = object : RecyclerItemCallback<MchBean, SelectMerchantAdapter.ViewHolder>() {
                    override fun onItemClick(
                        position: Int,
                        model: MchBean?,
                        tag: Int,
                        holder: SelectMerchantAdapter.ViewHolder?
                    ) {
                        super.onItemClick(position, model, tag, holder)
                        //删除商户的设备，选择商户，直接跳转界面
                        start(UnbindMerchantDeviceFragment.newInstance(model))

                    }
                }
            }
        }

        mAdapter = SelectMerchantAdapter(context!!, mSelectType)
        mAdapter.recItemClick = mAdapterClick
        //数据列表的recycleView
        mXRecyclerView = recyclerContentLayout.recyclerView
//        scroll_view.setSmoothScrollbarEnabled(true);
//        scroll_view.setAutoMeasureEnabled(true);
        mXRecyclerView?.isNestedScrollingEnabled = true
        val linearManager = LinearLayoutManager(context)
        mXRecyclerView?.layoutManager = linearManager
        mXAdapter = XRecyclerAdapter(mAdapter)
        mXRecyclerView?.adapter = mXAdapter
        mXRecyclerView?.onRefreshAndLoadMoreListener = object : XRecyclerView.OnRefreshAndLoadMoreListener {
            override fun onLoadMore(page: Int) {

                getTotalData(page)
            }

            override fun onRefresh() {
            }
        }
    }

    private var mPageId = Constants.START_PAGE_ID

    private fun getTotalData(pageId: Int, keyword: String? = null) {
        mPageId = pageId
        viewModel.getAgentAndMerchant(
            QueryAgentMchBean(
                mchId = UserModel.mchBean?.mchId ?: "",
                mchName = keyword,
                mchForm = 1,
                pageId = pageId
            )
        )
    }


    override fun onQueryTextSubmit(query: String?): Boolean {


        mAdapter.mCheckedPosition = -1
        //每一次新的请求，都需要重新选择商户，置按钮为不可点击
        saveEnable.set(false)
        getTotalData(Constants.START_PAGE_ID, query)
        return true
    }


    override fun onQueryTextChange(p0: String?): Boolean {

//        var searchMerchantList = arrayListOf<MchBean>()
//        var keyword = p0?.trim() ?: ""
//        for (bean in mMerchantList) {
////            if (beam.mchName?.trim().contains(keyword,true)!!) {
//            if (bean.mchName?.trim()?.contains(keyword, true)!!) {
//                bean.isSelected = false
//                searchMerchantList.add(bean)
//            }
//        }
//        mAdapter.clearData()
//        mAdapter.setData(searchMerchantList)


        return true
    }


    /**
     * 商户选择完成，
     */
    fun submit() {

        var selectMerchantBean = mAdapter.getSelectItem()

        if (selectMerchantBean == null) {
            showToast("请先选择商户")
            return
        }

        if (mSelectType == ACTIVATE_DEVICE) {
//            去激活设备，跳转到二维码扫描界面
            start(ScanActivateDeviceFragment.newInstance(selectMerchantBean.mchId!!))

        } else if (mSelectType == BIND_MERCHANT) {
//           绑定商户

            AlertDialog.Builder(_mActivity!!).setCancelable(true).setTitle("当前所选商户")
                .setMessage("商户名称：${selectMerchantBean.mchName}\n商户联系人：${selectMerchantBean.contactUser}")
                .setPositiveButton("取消") { dialogInterface: DialogInterface, i: Int ->
                    dialogInterface.dismiss()
                }.setNegativeButton("确定") { dialogInterface: DialogInterface, i: Int ->
                    dialogInterface.dismiss()
                    viewModel.bindTenant(
                        BindMerchantBean(
                            mOpenId, mUnionid,
                            selectMerchantBean.superUser.toString(), mType
                        )
                    )
                }.show()
        }
    }

    override fun handleError(throwable: Throwable) {}

    override fun getAgentAndMerchantSuccess(data: PageBean<MchBean>) {

        mXRecyclerView?.setPage(data.pageId, data.pageCount)
        var list = data.rows
        if (list == null) {
            mAdapter.clearData()
        } else {
            list.filter { it.mchType == 1 }.mapTo(arrayListOf()) { it }.let {
                if (mPageId == Constants.START_PAGE_ID) {
                    mAdapter.setData(it)
                } else {
                    mAdapter.addData(it)
                }
            }
        }
        if (recyclerContentLayout.swipeRefreshLayout != null) {
            //如果网络请求很慢，在网络请求返回前，用户已经退出该界面，导致这个字段为空
            recyclerContentLayout.swipeRefreshLayout.isRefreshing = false
        }


        //每一次新的请求，都需要重新选择商户，置按钮为不可点击
        saveEnable.set(false)

    }

    override fun getAgentAndMerchantFail(msg: String?) {
        msg?.let { showToast(it) }
    }


    override fun bindMerchantSuccess() {
        showToast("绑定成功")
        close()
    }

    override fun bindMerchantFail(msg: String) {
        showToast("绑定失败：${msg}")
    }

    companion object {
        fun newInstance(selectType: Int, openId: String = "", unionid: String = "", type: String = "") =
            SelectMerchantFragment().apply {
                mSelectType = selectType
                if (selectType == BIND_MERCHANT) {
                    mOpenId = openId
                    mUnionid = unionid
                    mType = type
                }
            }


        var ACTIVATE_DEVICE = 1
        var BIND_MERCHANT = 2
        var UNBINDING_MERCHANT_DEVICE = 3
    }


}