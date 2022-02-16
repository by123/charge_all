package com.xhd.td.ui.mine.bank

import android.app.Activity
import android.view.LayoutInflater
import android.view.View
import androidx.databinding.DataBindingUtil
import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import com.bigkoo.pickerview.builder.OptionsPickerBuilder
import com.bigkoo.pickerview.listener.OnOptionsSelectListener
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentAddCardBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.*
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.mine.AddCardCB
import com.xhd.td.vm.mine.AddCardVM
import kotlinx.android.synthetic.main.dialog_card_bottom.view.*
import kotlinx.android.synthetic.main.fragment_add_card.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class AddCardFragment : BaseFragment<FragmentAddCardBinding, AddCardVM, AddCardCB>(), AddCardCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_add_card
    override val viewModel: AddCardVM get() = ViewModelProviders.of(this, factory).get(AddCardVM::class.java)

    var mCardType: Int = 0

    var isAddCompanyCard: ObservableBoolean = ObservableBoolean(true)
    var mIsCardNoCorrect: Boolean = false


    private lateinit var mCityBean: CityDetailBean
    private lateinit var mBankBean: BankItemBean
    //第一次点击的时候，是false，不显示银行列表，自动检测一次后，无论成功失败，再次点击，都去显示银行表格
    private var mIsShowBankList = false

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "添加银行卡"
        isAddCompanyCard.set(mCardType == Constants.CARD_COMPANY)

        addsValue.setOnClickListener {
            hideSoftInput()
            if (sCityList.isEmpty()) {
                //从服务器获取数据
                viewModel.getCity()
            } else {
                showCity()
            }
        }
        bankNameValue.setOnClickListener {
            hideSoftInput()
            if (mIsShowBankList) {
                if (sBankList.isEmpty()) {
                    //自动检验银行
                    viewModel.getBank()
                } else {
                    showBank()
                }
            }
            if (accountValue.text.toString().isNotEmpty() && !mIsCardNoCorrect) {
                //银行卡号不为空，并且卡号检验不正确，
                viewModel.checkCardBank(accountValue.text.toString())
            } else if (accountValue.text.toString().isEmpty() ){
                showToast("请输入银行卡号")
            }
        }

        //查询银行卡
//        accountValue.onFocusChangeListener = View.OnFocusChangeListener { v, hasFocus ->
//            if (!hasFocus && accountValue.text.isNotEmpty() && mCardType == Constants.CARD_PERSONAL) {
//                viewModel.checkCardBank(accountValue.text.toString())
//            }
//        }

    }

    private fun showCity() {
        showCity(sCityList, _mActivity) { bean ->
            mCityBean = bean
            addsValue.setText(bean.city_name)
        }
    }


    //城市选中
    private fun showCity(data: List<CityBean>, activity: Activity, cb: (CityDetailBean) -> Any) {
        val provincialList = arrayListOf<String>()
        val municipalList = arrayListOf<List<String>>()
        for (beam in data) {
            provincialList.add(beam.city_name)
            val countyList = arrayListOf<String>()
            for (countyBean in beam.children) {
                countyList.add(countyBean.city_name)
            }
            municipalList.add(countyList)
        }
        val builder = OptionsPickerBuilder(activity, OnOptionsSelectListener { options1, options2, _, _ ->
            cb(data[options1].children[options2])
        })
        builder.setOutSideCancelable(false)
            .setLineSpacingMultiplier(2f)
            .isCenterLabel(false)
            .setTextColorCenter(activity.resources.getColor(R.color.btn))
            .setCancelColor(activity.resources.getColor(R.color.tv_color))
            .setSubmitColor(activity.resources.getColor(R.color.tv_color))
            .setContentTextSize(18)
            .setSubCalSize(16).build<String>().apply {
                setPicker(provincialList, municipalList)
            }.show()
    }


    private fun showBank() {
        showBankCard(sBankList, _mActivity) { beam ->
            mBankBean = beam
            bankNameValue.text = mBankBean.bank_name
        }
    }


    //银行卡
    private fun showBankCard(data: List<BankCardBean>, activity: Activity, cb: (beam: BankItemBean) -> Unit) {
        val bankItemList = arrayListOf<String>()
        for (beam in data) {
            bankItemList.add(beam.node.bank_name)
        }
        val builder = OptionsPickerBuilder(activity, OnOptionsSelectListener { options1, _, _, _ ->
            cb(data[options1].node)
        })
        builder.setOutSideCancelable(false)
            .setLineSpacingMultiplier(2f)
            .isCenterLabel(false)
            .setTextColorCenter(activity.resources.getColor(R.color.btn))
            .setCancelColor(activity.resources.getColor(R.color.tv_color))
            .setSubmitColor(activity.resources.getColor(R.color.tv_color))
            .setContentTextSize(18)
            .setSubCalSize(16).build<String>().apply {
                setNPicker(bankItemList, null, null)
            }.show()
    }


    private fun checkInput(): Boolean {
        return accountNameValue.text.isNotEmpty().apply {
            if (!this) showToast("${accountName.text}不能为空")
        } && accountValue.text.isNotEmpty().apply {
            if (!this) showToast("${account.text}不能为空")
        } && bankNameValue.text.isNotEmpty().apply {
            if (!this) showToast("${bankName.text}不能为空")
        } && if (mCardType == Constants.CARD_COMPANY) addsValue.text.isNotEmpty().apply {
            if (!this) showToast("${adds.text}不能为空")
        } else {
            true
        } && if (mCardType == Constants.CARD_COMPANY) subBankNameValue.text.isNotEmpty().apply {
            if (!this) showToast("${subBankName.text}不能为空")
        } else true
    }


    fun checkData() {
        if (checkInput()) {
            //param1 = 1对私，检验不通过，不能提交
            if (!mIsCardNoCorrect && mCardType == Constants.CARD_PERSONAL) {
                showToast("卡号校验未通过")
                return
            }
            val dialogBottom = BottomSheetDialog(_mActivity)
            val dataBindingUtil = DataBindingUtil.inflate<com.xhd.td.databinding.DialogCardBottomBinding>(
                LayoutInflater.from(activity), R.layout.dialog_card_bottom, null, false
            )
            val view = dataBindingUtil.root
            dialogBottom.setContentView(dataBindingUtil.root)
            dialogBottom.delegate.findViewById<View>(com.google.android.material.R.id.design_bottom_sheet)
                ?.setBackgroundColor(resources.getColor(android.R.color.transparent))

            dataBindingUtil.isCompanyCard = mCardType == Constants.CARD_COMPANY
            view.tv_account_name_value.text = accountNameValue.text.toString()
            view.tv_card_no_value.text = accountValue.text.toString()
            view.tv_card_bank_value.text = bankNameValue.text.toString()
            view.tv_card_issuing_bank_value.text = subBankNameValue.text.toString()
            view.tv_card_address_value.text = addsValue.text.toString()

            view.btn_cancel.setOnClickListener { dialogBottom.dismiss() }
            view.btn_confirm.setOnClickListener {
                var cityCode = ""
                var cityName = ""
                if (mCardType == Constants.CARD_COMPANY) {
                    cityCode = mCityBean.city_code
                    cityName = mCityBean.city_name
                }
                viewModel.addCardBank(
                    BankBeam(
                        view.tv_account_name_value.text.toString(),
                        view.tv_card_issuing_bank_value.text.toString(),
                        mBankBean.bank_code,
                        view.tv_card_no_value.text.toString(),
                        mBankBean.bank_name,
                        cityCode,
                        cityName,
                        mCardType
                    )
                )

                dialogBottom.dismiss()
            }
            dialogBottom.show()
        }
    }


    override fun handleError(throwable: Throwable) {

    }

    override fun addCardSuccess() {
        //添加成功，界面跳转
        showToast("添加银行卡成功")
        jumpUI()
    }

    override fun addCardFail(msg: String) {
        showToast(msg)
        jumpUI()
    }


    fun jumpUI() {
        pop()
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.REFRESH_CARD_LIST, false))
    }


    override fun checkCardSuccess(bean: BankItemBean) {
        mBankBean = bean
        bankNameValue.text = bean.bank_name
        mIsCardNoCorrect = true
        mIsShowBankList = true
    }

    override fun checkCardFail(msg: String) {
        //查询银行卡信息失败
        showToast(msg)
        mIsShowBankList = true
    }


    override fun getCitySuccess(data: List<CityBean>) {
        sCityList = data
        showCity()
    }

    override fun getCityFail(msg: String) {
        showToast("获取城市列表失败")
    }

    override fun getBankSuccess(data: List<BankCardBean>) {
        sBankList = data
        showBank()
    }

    override fun getBankFail(msg: String) {
        showToast("获取银行列表失败")
    }


    companion object {
        fun newInstance(cardType: Int) = AddCardFragment().apply {
            mCardType = cardType
        }

        //从服务器获取的列表数据
        var sCityList: List<CityBean> = arrayListOf()
        var sBankList: List<BankCardBean> = arrayListOf()
    }


}