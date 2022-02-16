package com.xhd.td.ui.home

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.GridLayoutManager
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.elvishew.xlog.XLog
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xhd.td.BR
import com.xhd.td.BuildConfig
import com.xhd.td.R
import com.xhd.td.adapter.home.HomeAdapter
import com.xhd.td.adapter.home.PerformanceAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentHomeBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.HomeItemBean
import com.xhd.td.ui.MainFragment
import com.xhd.td.ui.home.AbstractAddModifyFragment.Companion.AGENT
import com.xhd.td.ui.home.AbstractAddModifyFragment.Companion.CHAIN_AGENT
import com.xhd.td.ui.home.SelectMerchantFragment.Companion.ACTIVATE_DEVICE
import com.xhd.td.ui.mine.MessageDetailFragment
import com.xhd.td.ui.mine.MessageListFragment
import com.xhd.td.ui.taxi.TaxiListFragment
import com.xhd.td.utils.GridItemDecoration
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.HomeCallback
import com.xhd.td.vm.home.HomeVM
import io.reactivex.android.schedulers.AndroidSchedulers
import kotlinx.android.synthetic.main.fragment_home.*
import javax.inject.Inject


/**
 * create by xuexuan
 * time 2019/3/17 18:52
 */
class HomeFragment : BaseFragment<FragmentHomeBinding, HomeVM, HomeCallback>(), HomeCallback {


    @Inject
    lateinit var factory: ViewModelProviderFactory

    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int? get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_home
    override val viewModel: HomeVM get() = ViewModelProviders.of(this, factory).get(HomeVM::class.java)
    override var mHasToolbar = false


    lateinit var mPerformanceAdapter: PerformanceAdapter
    lateinit var mHomeAdapter: HomeAdapter

    override fun lazyInitView(view: View) {
        setSwipeBackEnable(false)
        val homeItemList = arrayListOf<HomeItemBean>()
        val itemActivate = HomeItemBean("激活设备", R.drawable.ic_activate_device, 0)
        val itemAddMerchant = HomeItemBean("添加商户", R.drawable.ic_add_merchant, 1)
        val itemAddAgent = HomeItemBean("添加代理商", R.drawable.ic_add_agent, 2)
        val itemAddSalesman = HomeItemBean("添加业务员", R.drawable.ic_add_salesman, 3)
        val itemAddChainStore = HomeItemBean("添加连锁门店", R.drawable.ic_add_chain_store, 4)
        val itemResetPwd = HomeItemBean("设备密码重置", R.drawable.ic_reset_device_pwd, 5)
        val itemTaxi = HomeItemBean("出租车业务", R.drawable.ic_taxi, 6)
        val itemBindMerchant = HomeItemBean("绑定商户", R.drawable.ic_band_merchant, 7)

        homeItemList.add(itemActivate)
        homeItemList.add(itemAddMerchant)
        homeItemList.add(itemAddAgent)
        homeItemList.add(itemAddSalesman)
        homeItemList.add(itemAddChainStore)
        if (BuildConfig.PRODUCT_TYPE == Constants.PRODUCT_YELLOW) {
            //如果是炭电，才去显示设备密码重置
            homeItemList.add(itemResetPwd)
        }
        homeItemList.add(itemTaxi)
        homeItemList.add(itemBindMerchant)


        //根据不同的账号类型显示不同的界面
        when (UserModel.type) {
            //省级代理 市级代理
            Constants.PROVINCIAL_AGENT, Constants.MUNICIPAL_AGENT -> {
                //全部都能显示

            }
            //区县代理
            Constants.COUNTY_AGENT -> {
//                cv_add_agent.visibility = View.GONE
                //隐藏添加代理商
                homeItemList.remove(itemAddAgent)
            }
            //普通商户
            Constants.MERCHANT -> {
//                cv_add_agent.visibility = View.GONE
//                cv_add_chain_agent.visibility = View.GONE

                //隐藏添加代理商，添加连锁门店
                homeItemList.remove(itemAddAgent)
                homeItemList.remove(itemAddChainStore)
            }

            //连锁代理
            Constants.CHAIN_AGENT -> {
//                cv_add_agent.visibility = View.GONE
//                cv_add_chain_agent.visibility = View.GONE
                //隐藏添加代理商，添加连锁门店
                homeItemList.remove(itemAddAgent)
                homeItemList.remove(itemAddChainStore)
            }
            //连锁门店
            Constants.CHAIN_STORE -> {
//                cv_add_agent.visibility = View.GONE
//                cv_add_chain_agent.visibility = View.GONE
                //隐藏添加代理商，添加连锁门店
                homeItemList.remove(itemAddAgent)
                homeItemList.remove(itemAddChainStore)
            }
        }


        when (UserModel.roleType) {
            Constants.ROLY_TYPE_SALESMAN -> {
                //隐藏添加业务员
                homeItemList.remove(itemAddSalesman)
            }
        }

        //出租车业务统一隐藏
        homeItemList.remove(itemTaxi)

        initRecyclerView()
        tv_performance.setOnClickListener { (parentFragment as MainFragment).startBrotherFragment(PerformanceFragment.newInstance()) }
        viewModel.mCallback = this
        swipeLayout.apply {
            setColorSchemeColors(
                resources.getColor(R.color.colorAccent)
            )
            setOnRefreshListener {
                viewModel.loadPerformanceData()
            }
        }

        mHomeAdapter.addData(homeItemList)
        viewModel.getConfig(Constants.CFG_RELATIVE_PERCENT_WHITELIST)
        displayRedIcon()
        registerEventBus()
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.loadPerformanceData()
    }

    private fun initRecyclerView() {
        //我的收益的recycleView
        val gridManager = GridLayoutManager(context, 3)
        rc_performance.layoutManager = gridManager
        mPerformanceAdapter = PerformanceAdapter(context!!)
        rc_performance.adapter = mPerformanceAdapter

        //下方模板的recycleView
        val homeManager = GridLayoutManager(context, 3)
        rv_home.layoutManager = homeManager
        mHomeAdapter = HomeAdapter(context!!) { homeItemBean ->

            when (homeItemBean.index) {
                0 -> (parentFragment as MainFragment).startBrotherFragment(
                    SelectMerchantFragment.newInstance(
                        ACTIVATE_DEVICE
                    )
                )
                1 -> (parentFragment as MainFragment).startBrotherFragment(AddMerchantFragment.newInstance(title = "添加商户"))
                2 -> (parentFragment as MainFragment).startBrotherFragment(
                    AddAgentAndChainFragment.newInstance(
                        type = AGENT,
                        title = "添加代理商"
                    )
                )
                3 -> (parentFragment as MainFragment).startBrotherFragment(AddSalesmanFragment.newInstance())
                4 -> (parentFragment as MainFragment).startBrotherFragment(
                    AddAgentAndChainFragment.newInstance(
                        type = CHAIN_AGENT,
                        title = "添加连锁门店"
                    )
                )
                5 -> (parentFragment as MainFragment).startBrotherFragment(ScanDeviceResetFragment.newInstance())
                6 -> (parentFragment as MainFragment).startBrotherFragment(TaxiListFragment.newInstance())
                7 -> scan()
            }
        }
        rv_home.adapter = mHomeAdapter
        val divider = GridItemDecoration.Builder(context!!)
            .setHorizontalSpan(R.dimen.common_vew_column_padding)
            .setVerticalSpan(R.dimen.common_vew_raw_padding)
            .setColorResource(R.color.tv_hint)
            .setShowLastLine(true)
            .build()
        rv_home.addItemDecoration(divider)
    }


    //点击首页的扫描按钮，跳转界面
    fun scan() {
        (parentFragment as MainFragment).startBrotherFragment(ScanBindMerchantFragment.newInstance())
    }


    //打开消息列表
    fun toMessageList() {
        (parentFragment as MainFragment).startBrotherFragment(MessageListFragment.newInstance())
    }


    override fun onSupportVisible() {
        super.onSupportVisible()
        XLog.i("调用了onSupportVisible")

        if (Constants.CLICK_NEW_MESSAGE_ID!= null){

            (parentFragment as MainFragment).startBrotherFragment(MessageDetailFragment.newInstance(Constants.CLICK_NEW_MESSAGE_ID))
        }

    }

    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.MESSAGE_RED_ICON -> {
                        val isDisplay = eventMessage.eventContent as Boolean
                        viewModel.setHasNewMessage(isDisplay)
                        displayRedIcon()
                    }

                    EventKey.MESSAGE_DETAIL -> {
                        val id = eventMessage.eventContent as Int
                        (parentFragment as MainFragment).startBrotherFragment(MessageDetailFragment.newInstance(id))
                    }
                }
            }.addTo(viewModel.compositeDisposable)
    }

    //是否显示消息红电
    private fun displayRedIcon() {
        if (viewModel.getHasNewMessage()) {
            img_red_icon.visibility = View.VISIBLE
        } else {
            img_red_icon.visibility = View.GONE
        }
    }

    override fun getPerformanceSuccess() {
        if (swipeLayout != null) {
            swipeLayout.isRefreshing = false
        }
    }

    override fun getPerformanceFail(msg: String?) {
        showToast("获取我的收益失败：${msg}")
    }


    override fun getConfigSuccess(key: String, data: String?) {
        //获取灰度更新用户列表成功
        //判断当前用户是否在灰度更新的列表里面
        val users = Gson().fromJson<List<String>?>(data, object : TypeToken<List<String>>() {}.type)
        UserModel.relativePercentWhitelist = users?.contains(UserModel.userBean?.mchId) == true

    }


    override fun getConfigFail(msg: String?) {
        //获取灰度更新用户列表失败

    }


    override fun handleError(throwable: Throwable?) {
        if (swipeLayout != null) {
            swipeLayout.isRefreshing = false
        }
    }

    companion object {
        @JvmStatic
        fun newInstance(): HomeFragment {
            val args = Bundle()
            val fragment = HomeFragment()
//        fragment.set(args)
            return fragment
        }
    }
}