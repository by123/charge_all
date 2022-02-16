package com.xhd.td.ui.home

import android.os.Bundle
import android.text.Editable
import android.text.Html
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableInt
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.bigkoo.pickerview.builder.OptionsPickerBuilder
import com.bigkoo.pickerview.listener.OnOptionsSelectListener
import com.elvishew.xlog.XLog
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentAbstractMerchantBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.IndustryBillingRule
import com.xhd.td.model.bean.LocalCityBean
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.MinPay
import com.xhd.td.ui.map.MapFragment
import com.xhd.td.utils.CashierInputFilter
import com.xhd.td.utils.InputFilter
import com.xhd.td.utils.getRawToString
import com.xhd.td.utils.showListToPickerView
import com.xhd.td.vm.cb.AbstractMerchantCallback
import com.xhd.td.vm.home.AbstractMerchantVM
import kotlinx.android.synthetic.main.fragment_abstract_merchant.*
import kotlinx.android.synthetic.main.title_bar.*
import java.math.BigDecimal

/**
 * create by xuexuan
 * time 2019/3/21 22:36
 * 添加代理，添加连锁总店，修改代理，修改连锁总店
 * 添加商户（连锁分店），修改商户（连锁分店）信息的抽象类
 * 使用模板方法，上述六种分别继承这个抽象类
 */

abstract class AbstractAddModifyFragment<F : AbstractMerchantVM> :
    BaseFragment<FragmentAbstractMerchantBinding, F, AbstractMerchantCallback>(), AbstractMerchantCallback {


    companion object {
        val MERCHANT = 1
        val CHAIN_STORE = 2
        val AGENT = 3
        val CHAIN_AGENT = 4

        val ADD = 1
        val MODIFY = 2

        //类型参数，是对商户，代理，连锁门店哪种类型进行操作
        val PARAM_TYPE = "type_param"
        //状态参数，新增还是修改
        val PARAM_STATUS = "status_param"
        val PARAM_TITLE = "title_param"

    }

    var mType: Int = MERCHANT
    var mStatus: Int = ADD
    var mTitle: String? = ""


    var isSave: ObservableBoolean = ObservableBoolean(false)
    var isEdit: ObservableBoolean = ObservableBoolean(false)
    var type: ObservableInt = ObservableInt()

    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment

    override val layoutId: Int get() = R.layout.fragment_abstract_merchant


    private var mMerchantType = CHAIN_AGENT

    var mSuperProfitPercent = UserModel.mchBean?.totalPercent ?: 0.0//当前账号或者当前分店的分润总比例

    //没有填写信息的提示
    protected var mNoMerchantAgentHint = "请输入商户名称"


    private var mMerchantNameCorrect = false
    protected var mIndustryCorrect = false
    protected var mAgentLevelCorrect = false
    private var mContactNameCorrect = false
    private var mContactPhoneCorrect = false
    private var mProfitPercentCorrect = false
    private var mBillingCorrect = false
    //商户必填，代理，连锁非必填
    protected var mAddressCorrect = false
    //编辑的时候，需要传入已有的数据
    protected var mMerchantBean: MchBean? = null

    protected var mProvince: String? = null
    protected var mCity: String? = null
    protected var mCounty: String? = null

    //当前显示的是绝对分润类型
    protected var mIsAbsoluteProfitType = true

    //如果没有从数据库获得计费规则最低金额，则使用默认的值，单位分
    protected var mMinMoney: Int = 200

    var mTextWatcher = object : TextWatcher {
        override fun afterTextChanged(s: Editable?) {
            inspectData()
        }

        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }
    }

    var mRelativelyProfitTextWatcher = object : TextWatcher {
        override fun afterTextChanged(s: Editable?) {

            var relativelyProfitTotal = BigDecimal(0)
            var relativelyProfit = BigDecimal(0)

            if (edit_relatively_profit_percent.text.isNotEmpty()) {
                relativelyProfit =
                    edit_relatively_profit_percent.text?.toString()?.toBigDecimalOrNull() ?: BigDecimal(0)
            }

            if (edit_relatively_profit_pool.text.isNotEmpty()) {
                relativelyProfitTotal =
                    edit_relatively_profit_pool.text?.toString()?.toBigDecimalOrNull() ?: BigDecimal(0)
            }

            val i = relativelyProfitTotal.times(relativelyProfit)
            //BigDecimal 除法参考https://blog.csdn.net/haibin_hu/article/details/52076830
            val j = i.divide(BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP).toString()
            tv_actual_profit_value.text = j

            inspectData()
        }

        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }
    }

    override fun lazyInitView(view: View) {

        //所有子类需要重写这个类，来显示不同的界面
        val bundle = arguments
        if (bundle != null) {
            mType = bundle.getInt(PARAM_TYPE)
            mStatus = bundle.getInt(PARAM_STATUS)
            mTitle = bundle.getString(PARAM_TITLE)
        }
        viewModel?.mCallback = this

        title.text = mTitle
        edit_merchant_name.addTextChangedListener(mTextWatcher)
        edit_contact_name.addTextChangedListener(mTextWatcher)
        edit_contact_phone.addTextChangedListener(mTextWatcher)
        edit_profit_percent.addTextChangedListener(mTextWatcher)
        edit_merchant_name.addTextChangedListener(mTextWatcher)
        edit_detail_address.addTextChangedListener(mTextWatcher)
        edit_pre_amount.addTextChangedListener(mTextWatcher)

        toolBar.setNavigationOnClickListener { cancel() }
        img_location.setOnClickListener {
            start(MapFragment.newInstance())
            registerEventBus()
        }
        if (mType == MERCHANT || mType == CHAIN_STORE) {
            rv_billing.visibility = View.VISIBLE
            initRecyclerView()
            edit_pre_amount.addTextChangedListener(mTextWatcher)
            edit_max_amount.addTextChangedListener(mTextWatcher)
            edit_min_amount.addTextChangedListener(mTextWatcher)
            edit_upper_amount.addTextChangedListener(mTextWatcher)
            edit_min_hour.addTextChangedListener(mTextWatcher)
            edit_upper_hour.addTextChangedListener(mTextWatcher)
        }
        edit_freeze_amount.filters = Array(1) { CashierInputFilter() }

    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)

        if (mType == CHAIN_STORE || mType == MERCHANT) {
            //如果是添加商户和添加连锁门店，则获取行业信息
            viewModel?.getConfig(Constants.CFG_INDUSTRY_TYPE)
            //编辑用户则选择已有行业，新建用户显示“请选择行业”
            spinner_industry.text = mMerchantBean?.industry ?: ""
            //获取行业的默认计费规则
            viewModel?.getConfig(Constants.CFG_INDUSTRY_DEFAULT_PRICE)
            viewModel?.getConfig(Constants.CFG_MIN_PAY)
        }

        if (mType == MERCHANT && UserModel.relativePercentWhitelist) {
            //编辑商户和添加商户的时候，都需要展示相对或绝对分润
            edit_relatively_profit_pool.addTextChangedListener(mRelativelyProfitTextWatcher)
            edit_relatively_profit_percent.addTextChangedListener(mRelativelyProfitTextWatcher)
            edit_relatively_profit_pool.filters = Array(1) { InputFilter(_mActivity, mSuperProfitPercent, 0) }
            edit_relatively_profit_percent.filters = Array(1) { InputFilter(_mActivity, 100.0, 0) }

            tv_profit_type.visibility = View.VISIBLE
            tv_profit_type.setOnClickListener {
                if (mIsAbsoluteProfitType) {
                    //下一次显示绝对的布局
                    tv_profit_type.setText(R.string.profit_absolute)
                    //显示相对的布局
                    group_absolute_profit_type.visibility = View.GONE
                    group_relatively_profit_type.visibility = View.VISIBLE
                    mIsAbsoluteProfitType = false
                } else {
                    //下一次显示相对的布局
                    tv_profit_type.setText(R.string.profit_relatively)
                    //显示绝对的布局
                    group_absolute_profit_type.visibility = View.VISIBLE
                    group_relatively_profit_type.visibility = View.GONE
                    mIsAbsoluteProfitType = true
                }
                //状态重置成功后，再去检验数据
                inspectData()
            }
        }

        if (mStatus == MODIFY) {
            isEdit.set(true)
            setData()
            //setData 一定要在上面，一些数据设置好了，通过下面的setText，可以更新一下界面
            mMerchantBean?.apply {
                edit_merchant_name.setText(this.mchName)
                edit_contact_name.setText(this.contactUser)
                edit_contact_phone.setText(this.contactPhone)
                edit_profit_percent.setText(this.totalPercent.toString())

                tv_address_value.text = (this.province ?: "") + (this.city ?: "") + (this.area ?: "")
                edit_detail_address.setText(this.detailAddr)
                edit_freeze_amount.setText(this.blockedAmountYuan.toString())
                edit_relatively_profit_pool.setText(this.profitPool?.toString())
                edit_relatively_profit_percent.setText(this.percentInPool?.toString())
                tv_actual_profit_value.text = this.totalPercent.toString()
            }
            //调用各子类的具体实现，个性初始化
        } else if (mStatus == ADD) {
            isEdit.set(false)
//            location()
        }

        tv_address_value.setOnClickListener {
            hideSoftInput()
            showCity { province, city, county ->
                mProvince = province
                mCity = city
                mCounty = county
                tv_address_value.text = province + city + county
                inspectData()
            }
        }


    }


    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        if (viewModel != null) {
            BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
                .subscribe { eventMessage ->
                    when (eventMessage.tag) {
                        EventKey.SELECTED_LOCATION -> {
                            try {
                                val address = eventMessage.eventContent as List<String?>
                                tv_address_value.text = address[0] + address[1] + address[2]
                                mProvince = address[0]
                                mCity = address[1]
                                mCounty = address[2]
                                edit_detail_address.setText(address[3])
                            } catch (e: Exception) {
                                e.toString()
                            }
                        }
                    }
                }.addTo(viewModel!!.compositeDisposable)
        }
    }


    //自动定位手机当前位置
    private fun location() {
        //gps定位监听器
        mAMapLocationListener = AMapLocationListener { loc ->
            try {
                if (null != loc) {
                    if (loc.errorCode == 0) {//可在其中解析amapLocation获取相应内容。
                        stopLocation()
                        tv_address_value.text = loc.province + loc.city + loc.district
//                        edit_detail_address.setText(loc.street + loc.streetNum + loc.description)
                    } else {
                        //定位失败时，可通过ErrCode（错误码）信息来确定失败的原因，errInfo是错误信息，详见错误码表。
                        XLog.e(
                            "AmapError", "location Error, ErrCode:"
                                    + loc.errorCode + ", errInfo:"
                                    + loc.errorInfo
                        )
                    }
                }
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        }

        startLocation()
    }


    /**
     * 默认的定位参数
     */
    private fun getDefaultOption(): AMapLocationClientOption {
        val mOption = AMapLocationClientOption()
        mOption.locationMode =
            AMapLocationClientOption.AMapLocationMode.Hight_Accuracy//可选，设置定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
        mOption.isGpsFirst = true//可选，设置是否gps优先，只在高精度模式下有效。默认关闭
        mOption.httpTimeOut = 30000//可选，设置网络请求超时时间。默认为30秒。在仅设备模式下无效
        mOption.interval = 2000//可选，设置定位间隔。默认为2秒
        mOption.isNeedAddress = true//可选，设置是否返回逆地理地址信息。默认是true
        mOption.isOnceLocation = false//可选，设置是否单次定位。默认是false
        mOption.isOnceLocationLatest = false//可选，设置是否等待wifi刷新，默认为false.如果设置为true,会自动变为单次定位，持续定位时不要使用
        AMapLocationClientOption.setLocationProtocol(AMapLocationClientOption.AMapLocationProtocol.HTTPS)//可选， 设置网络请求的协议。可选HTTP或者HTTPS。默认为HTTP
        mOption.isSensorEnable = false//可选，设置是否使用传感器。默认是false
        mOption.isWifiScan = true //可选，设置是否开启wifi扫描。默认为true，如果设置为false会同时停止主动刷新，停止以后完全依赖于系统刷新，定位位置可能存在误差
        mOption.isMockEnable = true//如果您希望位置被模拟，请通过setMockEnable(true);方法开启允许位置模拟
        return mOption
    }


    private var mLocationClient: AMapLocationClient? = null
    private var mAMapLocationListener: AMapLocationListener? = null

    /**
     * 开始定位
     */
    private fun startLocation() {
        if (null == mLocationClient) {
            //初始化client
            mLocationClient = AMapLocationClient(context)
            //设置定位参数
            mLocationClient?.setLocationOption(getDefaultOption())
            // 设置定位监听
            mLocationClient?.setLocationListener(mAMapLocationListener)
        }

        // 启动定位
        mLocationClient?.startLocation()
    }

    /**
     * 停止定位
     */
    private fun stopLocation() {
        if (null != mLocationClient) {
            mLocationClient?.stopLocation()
        }
    }


    private val provinceList = arrayListOf<String>()
    private val cityList = arrayListOf<List<String>>()
    private val countyList = arrayListOf<List<List<String>>>()

    var mIsFirstShowCity = true
    //城市选中
    private fun showCity(cb: (String, String, String) -> Unit) {

        if (mIsFirstShowCity) {

            val json = getRawToString(context!!, R.raw.address)
            val data =
                Gson().fromJson<List<LocalCityBean>>(json, object : TypeToken<List<LocalCityBean>>() {}.type) ?: return
//            val data = Gson().fromJson<List<LocalCityBean>>(json, object : TypeToken<List<LocalCityBean>>() {}.type) ?: return
//            val data = Gson().fromJson<Array<LocalCityBean>>(json,  Array<LocalCityBean>::class.java) ?: return
            for (beam in data) {
                provinceList.add(beam.label)
                val cityTempList = arrayListOf<String>()
                val countyTempList = arrayListOf<List<String>>()
                if (beam.children != null) {
                    for (cityBean in beam.children) {
                        cityTempList.add(cityBean.label)

                        val countyTempList2 = arrayListOf<String>()
                        if (cityBean.children != null) {
                            for (countyBean in cityBean.children) {
                                countyTempList2.add(countyBean.label)
                            }
                        } else {
                            countyTempList2.add("")
                        }
                        countyTempList.add(countyTempList2)

                    }
                } else {
                    cityTempList.add("")
                    countyTempList.add(listOf(""))
                }
                cityList.add(cityTempList)
                countyList.add(countyTempList)

            }
            mIsFirstShowCity = false
        }
        val builder = OptionsPickerBuilder(_mActivity, OnOptionsSelectListener { options1, options2, options3, _ ->
            cb(provinceList[options1], cityList[options1][options2], countyList[options1][options2][options3])
        })
        builder.setOutSideCancelable(false)
            .setLineSpacingMultiplier(2f)
            .isCenterLabel(false)
            .setTextColorCenter(_mActivity!!.resources.getColor(R.color.btn))
            .setCancelColor(_mActivity!!.resources.getColor(R.color.tv_color))
            .setSubmitColor(_mActivity!!.resources.getColor(R.color.tv_color))
            .setContentTextSize(18)
            .setSubCalSize(16).build<String>().apply {
                setPicker(provinceList, cityList, countyList)
            }.show()
    }


    /**
     * 添加时候显示的按钮，取消添加
     */
    fun cancel() {
        pop()
    }

    /**
     *  检查输入是否合法，合规.如果所有数据都合法则，高亮确定按钮
     *  默认所有数据，不合法
     *  所有的文本输入框
     *  所有的选择列表
     */
    fun inspectData() {

        //判断连锁门店不是必填字段，不用进行判断


        //判断商户名称，如果可见则对其进行验证
        if (edit_merchant_name.visibility == View.VISIBLE) {
            mMerchantNameCorrect = edit_merchant_name.text.isNotEmpty()
        } else {
            mMerchantNameCorrect = true
        }

        //判断行业的选择是否正确,在下拉选择的点击事件中判断,如果不可见，说明不需要选择，就是正确
        if (spinner_industry.visibility != View.VISIBLE) {
            mIndustryCorrect = true
        }


        //判断代理级别的选择是否正确,在下拉选择的点击事件中判断
        //判断代理级别是否正确,在下拉选择的点击事件中判断,如果不可见，说明不需要选择，就是正确
        if (spinner_agent_level.visibility != View.VISIBLE) {
            mAgentLevelCorrect = true
        }

        //判断姓名的是否合法
        if (edit_contact_name.visibility == View.VISIBLE) {
            mContactNameCorrect = edit_contact_name.text.isNotEmpty()
        } else {
            mContactNameCorrect = true
        }


        //判断手机是否合法
        if (edit_contact_phone.visibility == View.VISIBLE) {
            mContactPhoneCorrect = if (mType == CHAIN_STORE) {
                //创建连锁分店的手机号码是非必填的
                true
            } else {
                edit_contact_phone.text.length == 11
            }
        } else {
            mContactPhoneCorrect = true
        }

        //判断区域位置，是否正确
        if (mType == CHAIN_STORE || mType == MERCHANT) {
            //添加商户和连锁分店，地址是必填的，所以进行判断
            mAddressCorrect = tv_address_value.text.isNotEmpty() && edit_detail_address.text.isNotEmpty()
        } else {
            mAddressCorrect = true
        }


        //判断绝对分润比例的是否合法
        if (group_absolute_profit_type.visibility == View.VISIBLE || group_relatively_profit_type.visibility == View.VISIBLE) {
            val total = BigDecimal(mSuperProfitPercent)

            var profitText: BigDecimal? = null
            profitText = if (mIsAbsoluteProfitType) {
                //绝对比例的修改
                edit_profit_percent.text?.toString()?.toBigDecimalOrNull()
            } else {
                //相对比例的修改
                if (edit_relatively_profit_pool.text.isNullOrEmpty() || edit_relatively_profit_percent.text.isNullOrEmpty()) {
                    null
                } else {
                    if (edit_relatively_profit_pool.text.toString().toDouble() > mSuperProfitPercent) {
                        showToast("分润池不能超出你的总利润比例")
                        null
                    } else {
                        tv_actual_profit_value.text?.toString()?.toBigDecimalOrNull()
                    }

                }
            }

            val giveToOthers = profitText ?: BigDecimal(0)
            if (giveToOthers <= total) {
                mProfitPercentCorrect = profitText != null
            } else {

                mProfitPercentCorrect = false
                showToast("分润比例不能超出你的总利润比例")
            }

            tv_profit_share_hint.text = Html.fromHtml(
                "您的总利润比例为：<font color=\"${R.color.black}\" > ${total}%</font>，剩余分润：<font color=\"${R.color.black}\" > ${total - giveToOthers}%</font>"
            )

        } else {
            mProfitPercentCorrect = true
        }


        //判断计费规则的是否合法
        mBillingCorrect = if (rv_billing.visibility == View.VISIBLE) {
            inspectBilling()
        } else {
            true
        }

        isSave.set(
            mMerchantNameCorrect && mContactNameCorrect && mContactPhoneCorrect && mAddressCorrect
                    && mProfitPercentCorrect && mBillingCorrect && mIndustryCorrect && mAgentLevelCorrect
        )

    }

    /**
     * 从后台的配置文件中获取，商户类型
     */
    override fun getConfigSuccess(key: String, data: String?) {

        if (key == Constants.CFG_INDUSTRY_TYPE) {

            //获取行业信息成功
            if (data == null) return

            val industrys = data.split(",")
            if (industrys?.isEmpty()) {
                showToast("商户类型为空")
            } else {
                mIndustryList = industrys
                spinner_industry.setOnClickListener(mIndustryClickListener)

            }

        } else if (key == Constants.CFG_INDUSTRY_DEFAULT_PRICE) {
            mIndustryBillingRuleList = Gson().fromJson<List<IndustryBillingRule>>(
                data,
                object : TypeToken<List<IndustryBillingRule>>() {}.type
            )
            if (UserModel.type == Constants.CHAIN_AGENT) {
                //如果是连锁门店代理，在获取行业收费规则成功后，需要去设置收费规则
                //没有放在数据初始化，因为有可能行业已经设置了，但是请求计费规则还没有返回，导致设置不了
                industryClickListener(UserModel.mchBean?.industry ?: "")
            }
        } else if (key == Constants.CFG_MIN_PAY) {
            //获取计费规则的限制规则，例如：最低价格不能低于2
            val minPay = Gson().fromJson<MinPay>(data, MinPay::class.java)
            mMinMoney = minPay.money
        }


    }

    var mIndustryBillingRuleList: List<IndustryBillingRule>? = arrayListOf()
    var mIndustryList: List<String> = arrayListOf()

    var mIndustryClickListener: View.OnClickListener = View.OnClickListener {
        hideSoftInput()
        showListToPickerView(_mActivity, mIndustryList) { item, position ->
            //选择所属行业，更新界面
            spinner_industry.text = item
            industryClickListener(item ?: "")
            //点击过说明已经选了行业
            mIndustryCorrect = true
            inspectData()
        }
    }


    //添加商户或者连锁门店，不同的行业应该使用不同的计费规则
    //添加代理的时候，不需要使用计费规则
    open fun industryClickListener(item: String) {

    }


    override fun getConfigFail(msg: String?) {
        showToast("获取商户类型出错${msg}")

    }


    /**
     * 修改的时候显示的按钮，确认修改
     */
    open fun submitChange() {}

    open fun setData() {}


    /**
     *添加时候显示的按钮，新增一个
     */
    open fun addOne() {}


    /**
     * 判断输入是否完成，如果不完整，对未填写的字段进行提示
     */
    protected fun checkInput(): Boolean {

        if (!isSave.get()) {
            //如果isSave不为true，说明有字段没有填写正确，需要进行提示

            when {
                !mMerchantNameCorrect -> {
                    showToast(mNoMerchantAgentHint)
                }
                !mIndustryCorrect -> {
                    showToast("请选择行业")
                }
                !mAgentLevelCorrect -> {
                    showToast("请选择代理商等级")
                }
                !mContactNameCorrect -> {
                    showToast("请输入联系人姓名")
                }
                !mContactPhoneCorrect -> {
                    showToast("请检查联系人手机号是否正确")
                }

                !mProfitPercentCorrect -> {
                    showToast("请输入分润比例")
                }
                !mBillingCorrect -> {
                    showToast("请设置计费规则")
                }

                !mAddressCorrect -> {
                    showToast("请检查区域位置是否填写")
                }

            }
            return false
        } else {
            return true
        }
    }


    /**
     * 添加修改 商户、连锁分店，这四种才需要检查收费档是否合法
     */
    open fun inspectBilling(): Boolean {
        return false
    }

    /**
     * 添加修改 商户、连锁分店，这四种才需要初始化计费档位
     */
    open fun initRecyclerView() {}

}
