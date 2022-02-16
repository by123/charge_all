package com.xhd.td.vm

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import cn.xuexuan.mvvm.net.SchedulerProvider
import com.xhd.td.data.DataManager
import com.xhd.td.vm.home.*
import com.xhd.td.vm.income.AbstractLoadMoreVM
import com.xhd.td.vm.income.IncomeDetailVM
import com.xhd.td.vm.income.IncomeVM
import com.xhd.td.vm.income.WithdrawVM
import com.xhd.td.vm.login.ForgetPwdVM
import com.xhd.td.vm.login.LoginVM
import com.xhd.td.vm.map.MapVM
import com.xhd.td.vm.mine.*
import com.xhd.td.vm.order.OrderVM
import com.xhd.td.vm.social.SocialVM
import com.xhd.td.vm.taxi.TaxiGroupVM
import com.xhd.td.vm.unbind.UnbindMerchantDeviceVM
import com.xhd.td.vm.whitelist.WhitelistVM
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Created by jyotidubey on 22/02/19.
 */
@Singleton
class ViewModelProviderFactory @Inject
constructor(
    private val dataManager: DataManager,
    private val schedulerProvider: SchedulerProvider
) : ViewModelProvider.NewInstanceFactory() {


    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(AppVM::class.java)) {
            return AppVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(HomeVM::class.java)){
            return HomeVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(LoginVM::class.java)){
            return LoginVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(ForgetPwdVM::class.java)){
            return ForgetPwdVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(MerchantVM::class.java)){
            return MerchantVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(AgentAndChainVM::class.java)){
            return AgentAndChainVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(AddSalesmanVM::class.java)){
            return AddSalesmanVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(SelectMerchantVM::class.java)){
            return SelectMerchantVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(IncomeVM::class.java)){
            return IncomeVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(ScanVM::class.java)){
            return ScanVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(TotalVM::class.java)){
            return TotalVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(IncomeDetailVM::class.java)){
            return IncomeDetailVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(WithdrawVM::class.java)){
            return WithdrawVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(AbstractLoadMoreVM::class.java)){
            return AbstractLoadMoreVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(AddCardVM::class.java)){
            return AddCardVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(AccountVM::class.java)){
            return AccountVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(OrderVM::class.java)){
            return OrderVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(EditPwdVM::class.java)){
            return EditPwdVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(AgentDetailVM::class.java)){
            return AgentDetailVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(WhitelistVM::class.java)){
            return WhitelistVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(TaxiGroupVM::class.java)){
            return TaxiGroupVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(SocialVM::class.java)){
            return SocialVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(CardListVM::class.java)){
            return CardListVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(UnbindMerchantDeviceVM::class.java)){
            return UnbindMerchantDeviceVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(MapVM::class.java)){
            return MapVM(dataManager, schedulerProvider) as T
        }else if(modelClass.isAssignableFrom(MessageVM::class.java)){
            return MessageVM(dataManager, schedulerProvider) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class: " + modelClass.name)
    }
}