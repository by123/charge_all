package com.xhd.td.ui.mine

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.utils.JsonUtil
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.UiSettings
import com.amap.api.maps.model.LatLng
import com.google.gson.Gson
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentAgentDetailBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.BillingBean
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.PreBean
import com.xhd.td.model.bean.ServiceBean
import com.xhd.td.ui.home.AbstractAddModifyFragment
import com.xhd.td.ui.map.MapFragment
import com.xhd.td.utils.*
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.mine.AgentDetailCB
import com.xhd.td.vm.mine.AgentDetailVM
import kotlinx.android.synthetic.main.fragment_agent_detail.*
import kotlinx.android.synthetic.main.title_bar.*
import java.util.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 *
 * 商户和代理详情界面，点击编辑可进入编辑界面
 */

class AgentMerchantDetailFragment : BaseFragment<FragmentAgentDetailBinding, AgentDetailVM, AgentDetailCB>(),
    AgentDetailCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_agent_detail
    override val viewModel: AgentDetailVM get() = ViewModelProviders.of(this, factory).get(AgentDetailVM::class.java)

    private var mMchID: String? = null

    private var mAMap: AMap? = null
    private var mUiSettings: UiSettings? = null


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

    }

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        toolBar.setNavigationOnClickListener { close() }
        title.text = ""
        tv_navigation.setOnClickListener { mapNavigation() }
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)

        //在activity执行onCreate时执行mMapView.onCreate(savedInstanceState)，创建地图
        map.onCreate(savedInstanceState)
        mAMap = map.map

        //设置触摸地图监听器
        mAMap?.setOnMapClickListener { mapNavigation() }
        mAMap?.setOnMapLoadedListener { viewModel.queryDetail(mMchID ?: "") }

        viewModel.mCallback = this
        if (map.visibility != View.VISIBLE) {
            //如果map是可见的，就等map加载完成，在回调接口中，获取商户的信息
            viewModel.queryDetail(mMchID ?: "")
        } else {
            //设置地图的ui界面
            mUiSettings = mAMap?.uiSettings
            mUiSettings?.isZoomControlsEnabled = false//是否显示地图中放大缩小按钮
            mUiSettings?.isMyLocationButtonEnabled = false // 是否显示默认的定位按钮
            mUiSettings?.isScaleControlsEnabled = false//是否显示缩放级别
        }

    }

    private fun mapNavigation() {
        val mapList = MapUtils.getMapApp(context!!)
        if (mapList.isNotEmpty()) {
            showListToPickerView(_mActivity, mapList) { mapType, position ->
                MapUtils.navigate(context!!, mapType ?: "", mDestinationLatlng)
            }
        }
    }

    /**
     * 编辑商户，
     *  mchType 编辑的类型，是代理商，连锁总店，连锁商户，商户
     */
    fun edit(mchType: Int) {
        if (mMerchantBean != null) {
            //商户类型，mchType 字段，//'0:代理商， 1:普通商户, 2:平台',
            if (mchType == 0) {
                //代理商
                startForResult(
                    EditAgentAndChainFragment.newInstance(
                        AbstractAddModifyFragment.AGENT,
                        "编辑代理商",
                        mMerchantBean!!
                    ), AgentMerchantDetailFragment.REFRESH
                )
            } else {
                //普通商户
//                是代理，1：省代, 2:市代, 3：县代，4:连锁门店 ;如果是商户,0:普通商户,1:连锁门店商户',
                val type =
                    if (mMerchantBean?.level == 0) AbstractAddModifyFragment.MERCHANT else AbstractAddModifyFragment.CHAIN_STORE
                startForResult(
                    EditMerchantFragment.newInstance(type, "编辑商户", mMerchantBean!!),
                    AgentMerchantDetailFragment.REFRESH
                )

            }
        } else {
            showToast("获取数据错误")
        }
    }


    override fun getAgentAndMerchantFail(msg: String) {
        showToast(msg)

    }

    var mMerchantBean: MchBean? = null
    private lateinit var mDestinationLatlng: LatLng

    override fun getAgentAndMerchantSuccess(bean: MchBean) {

        //设置界面标题
        mMerchantBean = bean
        title.text = gradeNameForMchTypeAndLevel(bean.mchType, bean.level) + getString(R.string.detail)
        mViewDataBinding.bean = bean

        if (bean.mchType == 1 && bean.level == 0 && UserModel.relativePercentWhitelist){
            //如果是商户，并且代理有相对分润的权限
            if (bean.profitPool == null || bean.percentInPool == null){
                tv_profit_percent.text = "分润比例(绝对)"
                tv_profit_percent_value.text = bean.totalPercent.toString()+"%"
                group_actual_profit.visibility = View.GONE
            }else{
                tv_profit_percent.text = "分润比例(相对)"
                tv_profit_percent_value.text = bean.percentInPool.toString()+"%"
                group_actual_profit.visibility = View.VISIBLE
            }
        }else{
            tv_profit_percent_value.text = bean.totalPercent.toString()+"%"
        }


        setGrade(bean.mchPriceRule)
        if (bean.mchLocationLatitude != null && bean.mchLocationLongitude != null) {
            mDestinationLatlng = LatLng(bean.mchLocationLatitude!!, bean.mchLocationLongitude!!)
            moveMapCamera(mDestinationLatlng)
            context?.let { MapUtils.locationToAddress(it, mDestinationLatlng, tv_gps_location_value) }
        }
    }

    override fun handleError(throwable: Throwable) {

    }


    /**
     * 设置显示档位
     */
    private fun setGrade(mchPriceRule: List<BillingBean>?) {
        clearGrade()
        var rule = mchPriceRule?.get(0)
        if(rule?.serviceType == 1){
            val gradeList = parseGrade(rule?.service ?: return)
            if (gradeList.isEmpty()) return
            for ((index, beam) in gradeList.withIndex()) {
                when (index) {
                    0 -> {
                        tv_billing_rules_title.visibility = View.VISIBLE
                        tv_first_level.visibility = View.VISIBLE
                        tv_first_level_value.visibility = View.VISIBLE
//                    line_first_level.visibility = View.VISIBLE
                        tv_first_level_value.text = parsePrice(beam)
                    }
                    1 -> {
                        tv_second_level.visibility = View.VISIBLE
                        tv_second_level_value.visibility = View.VISIBLE
                        line_second_level.visibility = View.VISIBLE
                        tv_second_level_value.text = parsePrice(beam)
                    }
                    2 -> {
                        tv_third_level.visibility = View.VISIBLE
                        tv_third_level_value.visibility = View.VISIBLE
                        line_third_level.visibility = View.VISIBLE
                        tv_third_level_value.text = parsePrice(beam)
                    }
                    3 -> {
                        tv_fourth_level.visibility = View.VISIBLE
                        tv_fourth_level_value.visibility = View.VISIBLE
                        line_fourth_level.visibility = View.VISIBLE
                        tv_fourth_level_value.text = parsePrice(beam)
                    }
                    4 -> {
                        tv_fifth_level.visibility = View.VISIBLE
                        tv_fifth_level_value.visibility = View.VISIBLE
                        line_fifth_level.visibility = View.VISIBLE
                        tv_fifth_level_value.text = parsePrice(beam)
                    }
                }
            }
        }else{
            var service =  Gson().fromJson(rule?.service, PreBean::class.java)
            tv_billing_rules_title.visibility = View.VISIBLE

            tv_first_level.text = "预付金额"
            tv_first_level_value.text = "${service.prepaid / 100}元"
            tv_first_level.visibility = View.VISIBLE
            tv_first_level_value.visibility = View.VISIBLE


            tv_second_level.text = "封顶金额"
            tv_second_level_value.text = "${service.maxMoney / 100}元"
            tv_second_level.visibility = View.VISIBLE
            tv_second_level_value.visibility = View.VISIBLE
            line_second_level.visibility = View.VISIBLE


            tv_third_level.text = "首次${service.minMinutes / 60}小时"
            tv_third_level_value.text = "${service.minMoney / 100}元"
            tv_third_level.visibility = View.VISIBLE
            tv_third_level_value.visibility = View.VISIBLE
            line_third_level.visibility = View.VISIBLE


            tv_fourth_level.text = "超过${service.minMinutes / 60}小时后，每${service.stepMinutes / 60}小时"
            tv_fourth_level_value.text = "${service.price / 100}元"
            tv_fourth_level.visibility = View.VISIBLE
            tv_fourth_level_value.visibility = View.VISIBLE
            line_fourth_level.visibility = View.VISIBLE
        }

    }


    private fun clearGrade() {

        tv_billing_rules_title.visibility = View.GONE
        tv_first_level.visibility = View.GONE
        tv_first_level_value.visibility = View.GONE
//            line_first_level.visibility = View.GONE

        tv_second_level.visibility = View.GONE
        tv_second_level_value.visibility = View.GONE
        line_second_level.visibility = View.GONE

        tv_third_level.visibility = View.GONE
        tv_third_level_value.visibility = View.GONE
        line_third_level.visibility = View.GONE

        tv_fourth_level.visibility = View.GONE
        tv_fourth_level_value.visibility = View.GONE
        line_fourth_level.visibility = View.GONE

        tv_fifth_level.visibility = View.GONE
        tv_fifth_level_value.visibility = View.GONE
        line_fifth_level.visibility = View.GONE

    }


    override fun onSupportVisible() {
        super.onSupportVisible()
        map.onResume()
        if (mMerchantBean?.mchLocationLatitude != null) {
            map.visibility = View.VISIBLE
        }
    }

    override fun onSupportInvisible() {
        super.onSupportInvisible()
        if (map.visibility == View.VISIBLE) {
            map.onPause()
            map.visibility = View.GONE
        }
    }


    override fun onDestroyView() {
        super.onDestroyView()
        if (map.visibility == View.VISIBLE) {
            map.onDestroy()
        }
    }


    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        //在activity执行onSaveInstanceState时执行mMapView.onSaveInstanceState (outState)，保存地图当前的状态
        map.onSaveInstanceState(outState)
    }


    /**
     * 把地图画面移动到定位地点(使用moveCamera方法没有动画效果)
     *
     * @param latitude
     * @param longitude
     */
    private fun moveMapCamera(latLng: LatLng) {
        mAMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, MapFragment.ZOOM))
    }


    override fun onFragmentResult(requestCode: Int, resultCode: Int, data: Bundle?) {
        super.onFragmentResult(requestCode, resultCode, data)
        if (requestCode == REFRESH && resultCode == RESULT_OK && data != null) {
            viewModel.queryDetail(mMchID ?: "")
        }
    }


    companion object {
        fun newInstance(mchId: String) = AgentMerchantDetailFragment().apply {
            mMchID = mchId
        }

        var REFRESH = 1
    }


}