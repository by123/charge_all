package com.xhd.td.ui.home

import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.model.bean.SalesmanResultBean
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.home.AddSalesmanCB
import com.xhd.td.vm.home.AddSalesmanVM
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class AddSalesmanFragment :
    BaseFragment<com.xhd.td.databinding.FragmentAddSalesmanBinding, AddSalesmanVM, AddSalesmanCB>(),
    AddSalesmanCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_add_salesman
    override val viewModel: AddSalesmanVM get() = ViewModelProviders.of(this, factory).get(AddSalesmanVM::class.java)


    var isSave: ObservableBoolean = ObservableBoolean(false)


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        toolBar.setNavigationOnClickListener { close() }
        title.text = "添加业务员"
        viewModel.mCallback = this
    }

    override fun handleError(throwable: Throwable) {

    }

    override fun addSuccess(bean: SalesmanResultBean) {
         //跳转到商户添加成功界面
        startWithPop(
            AddMerchantSuccessFragment.newInstance(
                bean.userId,
                bean.password,
                false,
                ""
            )
        )
    }

    override fun addFail(msg: String?) {
        msg?.let { showToast(it) }
    }


    companion object {
        fun newInstance() = AddSalesmanFragment()
    }


}