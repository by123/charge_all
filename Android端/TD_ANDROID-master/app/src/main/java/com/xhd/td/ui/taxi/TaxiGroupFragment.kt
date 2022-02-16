package com.xhd.td.ui.taxi


import android.os.Bundle
import android.text.Editable
import android.text.Html
import android.text.TextWatcher
import android.view.View
import android.widget.ScrollView
import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import com.bigkoo.pickerview.builder.OptionsPickerBuilder
import com.bigkoo.pickerview.listener.OnOptionsSelectListener
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentTaxiGroupBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.GradeBean
import com.xhd.td.model.bean.LocalCityBean
import com.xhd.td.model.bean.SalesmanBean
import com.xhd.td.model.bean.TaxiGroupBean
import com.xhd.td.utils.getRawToString
import com.xhd.td.utils.parseGrade
import com.xhd.td.utils.showListToPickerView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.taxi.TaxiGroupCB
import com.xhd.td.vm.taxi.TaxiGroupVM
import kotlinx.android.synthetic.main.fragment_taxi_group.*
import kotlinx.android.synthetic.main.title_bar.*
import java.math.BigDecimal
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class TaxiGroupFragment : BaseFragment<FragmentTaxiGroupBinding, TaxiGroupVM, TaxiGroupCB>(), TaxiGroupCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_taxi_group
    override val viewModel: TaxiGroupVM get() = ViewModelProviders.of(this, factory).get(TaxiGroupVM::class.java)

    var isSave: ObservableBoolean = ObservableBoolean(false)
    var isView: ObservableBoolean = ObservableBoolean(false)


    private var mPreSaleProvince: String = ""
    private var mPreSaleCity: String = ""
    private var mPreSaleCounty: String = ""
    private var mAfterSaleProvince: String = ""
    private var mAfterSaleCity: String = ""
    private var mAfterSaleCounty: String = ""
    private var mSalesmanList: ArrayList<SalesmanBean> = arrayListOf()

    private var mSelectSalesmanId :String? = null

    private var mTotalProfilePercent = UserModel.mchBean?.totalPercent?:0.0
    override fun initView(view: View) {
        super.initView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "创建分组"


        edit_group_name.addTextChangedListener(mTextWatcher)
        edit_charge_price_value.addTextChangedListener(mTextWatcher)
        edit_pre_sale_contact_phone.addTextChangedListener(mTextWatcher)
        edit_after_sale_contact_phone.addTextChangedListener(mTextWatcher)
        edit_driver_profit_percent.addTextChangedListener(mTextWatcher)


        if (UserModel.roleType == Constants.ROLY_TYPE_SALESMAN) {
            //当前账号是业务员，直接填入业务员名称
            tv_group_salesman_value.text = UserModel.userBean?.name
            tv_group_salesman_value.setTextColor(context!!.resources.getColor(R.color.tv_black))
            mSelectSalesmanId = UserModel.userBean?.userId
        } else {
            tv_group_salesman_value.setOnClickListener(clickSalesman)
        }

        tv_pre_sale_address_value.setOnClickListener {
            hideSoftInput()
            showCity { province, city, county ->
                mPreSaleProvince = province
                mPreSaleCity = city
                mPreSaleCounty = county
                tv_pre_sale_address_value.text = province + city + county
            }
        }
        tv_after_sale_address_value.setOnClickListener {
            hideSoftInput()
            showCity { province, city, county ->
                mAfterSaleProvince = province
                mAfterSaleCity = city
                mAfterSaleCounty = county
                tv_after_sale_address_value.text = province + city + county
            }
        }
    }


    var clickSalesman = View.OnClickListener {

        hideSoftInput()
        if (mSalesmanList.isEmpty()) {
            showToast("业务人员列表为空")
            return@OnClickListener
        }
        val salesmanNameList = mSalesmanList!!.mapTo(arrayListOf()) { it.name }
        showListToPickerView(_mActivity, salesmanNameList) { salesman, position ->

            mSelectSalesmanId = mSalesmanList[position].userId
            tv_group_salesman_value.text = salesman
            tv_group_salesman_value.setTextColor(context!!.resources.getColor(R.color.tv_black))
            inspectData()
        }

    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        var taxiProfitPercent = 0F
        if (mGroupBean != null) {
            //当前处于编辑状态，显示原有数据
            title.text = "查看分组"

            mViewDataBinding.bean = mGroupBean
            //司机的分润，用于计算剩余分润
            taxiProfitPercent = mGroupBean?.profitPercentTaxi ?: 0F

            edit_charge_price_value.setText((parseGrade(mGroupBean?.service.toString())[0].price.toFloat() / 100).toString())


            mPreSaleProvince = mGroupBean?.presaleProvince?:""
            mPreSaleCity = mGroupBean?.presaleCity?:""
            mPreSaleCounty = mGroupBean?.presaleArea?:""

            mAfterSaleProvince = mGroupBean?.aftersaleProvince?:""
            mAfterSaleCity = mGroupBean?.aftersaleCity?:""
            mAfterSaleCounty = mGroupBean?.aftersaleArea?:""

            val t = mGroupBean?.service?.let { parseGrade(it)[0] }
            edit_charge_price_value.setText((t?.price?.toFloat()?.div(100)).toString())


            tv_group_salesman_value.text = mGroupBean?.salesName
            tv_group_salesman_value.setTextColor(context!!.resources.getColor(R.color.tv_black))

            edit_frozen_amount_value.setText((mGroupBean?.deposit?.div(100).toString()))
        }

        tv_profit_share_hint.text = Html.fromHtml(
            "您的总利润比例为：<font color=\"${R.color.black}\" > ${mTotalProfilePercent}%</font>，剩余分润：<font color=\"${R.color.black}\" > ${mTotalProfilePercent - taxiProfitPercent}%</font>"
        )

        when (UserModel.mchBean?.mchType) {
            //代理商，获取代理商的业务员
            0 -> viewModel.getSalesman(2)
            //普通商户，获取普通商户的业务员
            1 -> viewModel.getSalesman(3)
        }

    }

    private var mGroupNameCorrect = false
    private var mDepositCorrect = false
    private var mGroupSalesCorrect = false
    private var mChargePriceCorrect = false
    private var mProfilePercentCorrect = false
    private var mPreTelCorrect = false
    private var mAfterTelCorrect = false


    var mTextWatcher = object : TextWatcher {
        override fun afterTextChanged(s: Editable?) {
            inspectData()
        }

        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }
    }


    /**
     * 检查所有必填项，是否已经填入，
     * 检查手机号码是否正确
     * 检查分润比例是否正确
     *
     */
    fun inspectData() {

        mGroupNameCorrect = edit_group_name.text.isNotEmpty()
        mDepositCorrect = edit_frozen_amount_value.text.isNotEmpty()
        //不等于-1说明已经有选择，或者在编辑状态,或者在查看状态，这个参数的校验都未正确
        mGroupSalesCorrect = mSelectSalesmanId != null || mIsEdit || isView.get()
        mChargePriceCorrect = edit_charge_price_value.text.isNotEmpty()

        mPreTelCorrect = edit_pre_sale_contact_phone.text.length == 11
        mAfterTelCorrect = edit_after_sale_contact_phone.text.length == 11


        //判断分润比例的是否合法

        val total = BigDecimal(mTotalProfilePercent)
        val profitText = edit_driver_profit_percent.text?.toString()?.toBigDecimalOrNull()
        val giveToOthers = profitText ?: BigDecimal(0)

        if (giveToOthers <= total) {
            mProfilePercentCorrect = if (giveToOthers < BigDecimal(0)) {
                //分润比例不能小于0
                showToast("分润比例不能为负数")
                false
            } else {
                //有可能是没有填写分润比例，所以需要判断profitText是否为空，如果不为空，就是填写正确
                profitText != null
            }

        } else {

            mProfilePercentCorrect = false
            showToast("分润比例不能超出你的总利润比例")
        }

        tv_profit_share_hint.text = Html.fromHtml(
            "您的总利润比例为：<font color=\"${R.color.black}\" > ${total}%</font>，剩余分润：<font color=\"${R.color.black}\" > ${total - giveToOthers}%</font>"
        )

        isSave.set(mGroupNameCorrect && mGroupSalesCorrect && mChargePriceCorrect && mPreTelCorrect && mAfterTelCorrect && mProfilePercentCorrect&&mDepositCorrect)

    }


    val provinceList = arrayListOf<String>()
    val cityList = arrayListOf<List<String>>()
    val countyList = arrayListOf<List<List<String>>>()

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


    var mIsEdit = false

    /**
     * 提交数据
     */
    fun submit() {

        if (isView.get()) {
            isView.set(false)
            scroll_view.fullScroll(ScrollView.FOCUS_UP)
            mIsEdit = true
            showToast("请编辑分组信息")
            title.text = "编辑分组"

        } else {
            val list: ArrayList<GradeBean> = arrayListOf<GradeBean>()
            list.add(GradeBean("120", 3, (edit_charge_price_value.text.toString().toFloat() * 100)))
            //mCreateGroupBean 为空，表示没有传入分组信息，表示这是新建分组
            viewModel.createOrModifyGroup(
                TaxiGroupBean(
                    groupId = mGroupBean?.groupId,
                    aftersaleProvince = mAfterSaleProvince,
                    aftersaleCity = mAfterSaleCity,
                    aftersaleArea = mAfterSaleCounty,
                    aftersaleDetailAddr = edit_after_sale_detail_address.text.toString(),
                    aftersaleContactName = edit_after_sale_contact_name.text.toString(),
                    aftersaleContactTel = edit_after_sale_contact_phone.text.toString(),
                    groupName = edit_group_name.text.toString(),
                    mchId = UserModel.mchBean?.mchId,
                    presaleProvince = mPreSaleProvince,
                    presaleCity = mPreSaleCity,
                    presaleArea = mPreSaleCounty,
                    presaleContactName = edit_pre_sale_contact_name.text.toString(),
                    presaleContactTel = edit_pre_sale_contact_phone.text.toString(),
                    presaleDetailAddr = edit_pre_sale_detail_address.text.toString(),
                    profitPercentTaxi = edit_driver_profit_percent.text.toString().toFloat(),
                    salesId = if (mSelectSalesmanId != null) mSelectSalesmanId!! else mGroupBean?.salesId ?: "0",
                    service = Gson().toJson(list),
                    deposit = (edit_frozen_amount_value.text.toString().toFloat() *100).toInt()
                ), mIsEdit
            )
//        viewModel.createOrModifyGroup(mViewDataBinding.bean ?: return, isEdit.get())
        }
    }


    override fun handleError(throwable: Throwable) {

    }

    override fun createGroupFail(msg: String) {
        showToast(msg)
    }

    override fun createGroupSuccess(groupId: String, groupName: String) {
        if (mIsEdit) {
            showToast("修改成功")
            BusProvider.getBus()?.post(EventMessage<String>(EventKey.TAXI_LIST_REFRESH, ""))
            pop()
        } else {
            showToast("分组创建成功")
            startWithPop(AddGroupSuccessFragment.newInstance(groupId, groupName))
        }
    }


    override fun getSalesmanSuccess(list: List<SalesmanBean>) {

        mSalesmanList.addAll(list)
        mSalesmanList.add(SalesmanBean("管理员", 1, UserModel.mchBean?.mchId?:""))
    }

    override fun getSalesmanFail(msg: String) {

    }

    var mGroupBean: TaxiGroupBean? = null

    companion object {
        fun newInstance(view: Boolean = false, groupBean: TaxiGroupBean? = null) = TaxiGroupFragment().apply {
            mGroupBean = groupBean
            isView.set(view)
        }
    }


}



