package com.xhd.td.ui

import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import com.elvishew.xlog.XLog
import com.google.gson.Gson
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentMainBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.GrayscaleUpdateUsers
import com.xhd.td.model.bean.VersionBeam
import com.xhd.td.ui.home.HomeFragment
import com.xhd.td.ui.income.IncomeFragment
import com.xhd.td.ui.login.LoginFragment
import com.xhd.td.ui.mine.MineFragment
import com.xhd.td.ui.order.OrderFragment
import com.xhd.td.utils.updateDialog
import com.xhd.td.view.BottomBar
import com.xhd.td.view.BottomBarTab
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.LoginCallback
import com.xhd.td.vm.login.LoginVM
import io.reactivex.disposables.Disposable
import kotlinx.android.synthetic.main.fragment_main.*
import me.yokeyword.fragmentation.ISupportFragment
import me.yokeyword.fragmentation.SupportFragment
import javax.inject.Inject


/**
 * 根fragment，里面包含了首页，收益，订单，我的
 * 1、检测版本是否更新，
 * 2、内存重启后，数据恢复
 */
class MainFragment : BaseFragment<FragmentMainBinding, LoginVM, LoginCallback>(), LoginCallback {

    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val layoutId: Int get() = R.layout.fragment_main
    override val viewModel: LoginVM get() = ViewModelProviders.of(this, factory).get(LoginVM::class.java)

    private val mFragments = arrayOfNulls<SupportFragment?>(4)
    override var mHasToolbar = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        setSwipeBackEnable(false)
        viewModel.mCallback = this
        registerEventBus()
    }


    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)

        if (UserModel.grayscaleUpdate == null) {
            //获取灰度更新的用户
            viewModel.getConfig(MainFragment.GRAYSCALE_UPDATE_USER)
        }else {
            //检查版本更新
            viewModel.checkVersion(UserModel.grayscaleUpdate?:false)
        }
    }


    override fun onSupportVisible() {
        super.onSupportVisible()
        Constants.APP_ALREADY_OPEN = true
    }


    override fun onSupportInvisible() {
        super.onSupportInvisible()
//        Constants.APP_ALREADY_OPEN = false
    }


    override fun onFragmentResult(requestCode: Int, resultCode: Int, data: Bundle) {
        super.onFragmentResult(requestCode, resultCode, data)
        if (requestCode == REQ_MSG && resultCode == ISupportFragment.RESULT_OK) {

        }
    }


    override fun handleError(throwable: Throwable) {

    }

    override fun getVersionFail(msg: String) {

    }

    override fun getVersionSuccess(beans: List<VersionBeam>) {
        if (beans.isNotEmpty()) {
            updateDialog(_mActivity, beans[0])
        }
    }

    override fun getConfigSuccess(key: String, data: String?) {
        //获取灰度更新用户列表成功

        //判断当前用户是否在灰度更新的列表里面
        val users = Gson().fromJson<GrayscaleUpdateUsers>(data, GrayscaleUpdateUsers::class.java)
        UserModel.grayscaleUpdate = users?.users?.contains(UserModel.userBean?.userId)
        viewModel.checkVersion(UserModel.grayscaleUpdate ?: false)
    }


    override fun getConfigFail(msg: String?) {
        //获取灰度更新用户列表失败
        viewModel.checkVersion(UserModel.grayscaleUpdate ?: false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val firstFragment = findChildFragment(HomeFragment::class.java)

        //内存重启时，firstFragment不为空，但是mFragments会被清空，所以这里的if判断不能使用mFragments的有效个数来判断是否需要重新加载
        if (firstFragment == null) {
            //有时会出现这个错误，详见#304 java.lang.IndexOutOfBoundsException:Index: 0, Size: 0
            mFragments[FIRST] = (HomeFragment.newInstance())
            if (UserModel.incomeVisible) {
                mFragments[SECOND] = IncomeFragment.newInstance()
                mFragments[THIRD] = OrderFragment.newInstance()
                mFragments[FOUR] = MineFragment.newInstance()
            } else {
                mFragments[SECOND] = OrderFragment.newInstance()
                mFragments[THIRD] = MineFragment.newInstance()
            }

            XLog.i("MainFragment = $this - 新加的mFragments=$mFragments,Size=${mFragments.size}")

            val adapterFragments: Array<SupportFragment?> = if (UserModel.incomeVisible) {
                arrayOf(mFragments[FIRST], mFragments[SECOND], mFragments[THIRD], mFragments[FOUR])
            } else {
                arrayOf(mFragments[FIRST], mFragments[SECOND], mFragments[THIRD])
            }
            loadMultipleRootFragment(adapterFragments)
        } else {
            // 这里库已经做了Fragment恢复,所有不需要额外的处理了, 不会出现重叠问题
            // 这里我们需要拿到mFragments的引用

            mFragments[FIRST] = firstFragment
            if (UserModel.incomeVisible) {
                mFragments[SECOND] = findChildFragment(IncomeFragment::class.java)
                mFragments[THIRD] = findChildFragment(OrderFragment::class.java)
                mFragments[FOUR] = findChildFragment(MineFragment::class.java)
            } else {
                mFragments[SECOND] = findChildFragment(OrderFragment::class.java)
                mFragments[THIRD] = findChildFragment(MineFragment::class.java)
            }
            XLog.i("MainFragment = $this - 原有的mFragments=$mFragments,Size=${mFragments.size}")
        }

        initView()

    }


    private fun initView() {

        if (UserModel.incomeVisible) {
            bottomBar.addItem(BottomBarTab(_mActivity, R.drawable.ic_home_selected, R.drawable.ic_home_normal, "首页"))
                .addItem(BottomBarTab(_mActivity, R.drawable.ic_income_selected, R.drawable.ic_income_normal, "收益"))
                .addItem(BottomBarTab(_mActivity, R.drawable.ic_order_selected, R.drawable.ic_order_normal, "订单"))
                .addItem(BottomBarTab(_mActivity, R.drawable.ic_mine_selected, R.drawable.ic_mine_normal, "我的"))
        } else {
            bottomBar.addItem(BottomBarTab(_mActivity, R.drawable.ic_home_selected, R.drawable.ic_home_normal, "首页"))
                .addItem(BottomBarTab(_mActivity, R.drawable.ic_order_selected, R.drawable.ic_order_normal, "订单"))
                .addItem(BottomBarTab(_mActivity, R.drawable.ic_mine_selected, R.drawable.ic_mine_normal, "我的"))
        }
        bottomBar.setOnTabSelectedListener(object : BottomBar.OnTabSelectedListener {
            override fun onTabSelected(position: Int, prePosition: Int) {
                XLog.i("MainFragment = $this, 位置：当前:$position,上一个:$prePosition, mFragments=$mFragments,Size=${mFragments.size}")

                showHideFragment(mFragments[position], mFragments[prePosition])
            }

            override fun onTabUnselected(position: Int) {

            }

            override fun onTabReselected(position: Int) {
//                val currentFragment = mFragments[position]
//                val count = currentFragment?.childFragmentManager?.backStackEntryCount ?: 0
//
//                // 如果不在该类别Fragment的主页,则回到主页;
//                if (count > 1) {
//                    when (currentFragment) {
//                        is HomeFragment -> currentFragment.popToChild(HomeFragment::class.java, false)
//                        is IncomeFragment -> currentFragment.popToChild(IncomeFragment::class.java, false)
//                        is OrderFragment -> currentFragment.popToChild(OrderFragment::class.java, false)
//                        is MineFragment -> currentFragment.popToChild(MineFragment::class.java, false)
//                    }
//                    return
//                }


//                // 这里推荐使用EventBus来实现 -> 解耦
//                if (count == 1) {
//                    // 在FirstPagerFragment中接收, 因为是嵌套的孙子Fragment 所以用EventBus比较方便
//                    // 主要为了交互: 重选tab 如果列表不在顶部则移动到顶部,如果已经在顶部,则刷新
//                    EventBusActivityScope.getDefault(this@MainActivity).post(TabSelectedEvent(position))
//                }
            }
        })
    }


    //根据是否显示收益界面，来选择加载不同的
    private fun loadMultipleRootFragment(fragments: Array<SupportFragment?>) {
        if (UserModel.incomeVisible && fragments.size == 4) {
            loadMultipleRootFragment(
                R.id.fl_tab_container,
                FIRST,
                fragments[0],
                fragments[1],
                fragments[2],
                fragments[3]
            )
        } else if (fragments.size == 3) {
            loadMultipleRootFragment(R.id.fl_tab_container, FIRST, fragments[0], fragments[1], fragments[2])
        }
    }

    /**
     * start other BrotherFragment
     */
    fun startBrotherFragment(targetFragment: SupportFragment) {
        start(targetFragment)
    }


    private var mDisposable: Disposable? = null

    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        mDisposable = BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.OTHER_USER_LOGIN -> {
                        if (!Constants.IS_ALREADY_SIGN_OUT) {
                            Constants.IS_ALREADY_SIGN_OUT = true
                            //账号在其他地方登录，再次进入app 需要手动登录
                            startWithPopTo(LoginFragment.newInstance(), MainFragment::class.java, true)
                        }
                    }
                }
            }
    }


    private var TOUCH_TIME: Long = 0
    override fun onBackPressedSupport(): Boolean {

        if (System.currentTimeMillis() - TOUCH_TIME < WAIT_TIME) {
            Constants.APP_ALREADY_OPEN = false
            _mActivity.finish()
        } else {
            TOUCH_TIME = System.currentTimeMillis()
            Toast.makeText(context, R.string.press_again_exit, Toast.LENGTH_SHORT).show()
        }
        XLog.d("调用了mainFragment的onBackPressedSupport")
        //返回true，表示已经处理，不会再回调上一级的onBackPressedSupport，在这里也就是不会再回调mainActivity的onBackPressedSupport
        return true
    }

    override fun onDestroy() {
        super.onDestroy()
        mDisposable?.dispose()
    }

    companion object {

        const val WAIT_TIME = 2000L
        private const val REQ_MSG = 10

        const val FIRST = 0
        const val SECOND = 1
        const val THIRD = 2
        const val FOUR = 3
        const val GRAYSCALE_UPDATE_USER = "grayscale_update_user"


        fun newInstance(): MainFragment {

            val args = Bundle()

            val fragment = MainFragment()
            fragment.arguments = args
            return fragment
        }
    }
}
