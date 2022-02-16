package com.xhd.td.vm.mine

import androidx.lifecycle.MutableLiveData
import cn.xuexuan.mvvm.extensions.addTo
import cn.xuexuan.mvvm.extensions.performOnBackOutOnMain
import cn.xuexuan.mvvm.net.ApiSubscriber
import cn.xuexuan.mvvm.net.NetError
import cn.xuexuan.mvvm.net.SchedulerProvider
import cn.xuexuan.mvvm.net.XNet
import com.google.gson.Gson
import com.xhd.td.base.BaseViewModel
import com.xhd.td.data.DataManager
import com.xhd.td.model.bean.*
import com.xhd.td.vm.cb.mine.AddCardCB
import io.reactivex.Single
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL

/**
 * create by xuexuan
 * 依然来自薛瑄的独创模板
 */
class AddCardVM(dataManager: DataManager, scheduler: SchedulerProvider) :
    BaseViewModel<AddCardCB>(dataManager, scheduler) {

    var mPerformanceListLiveData: MutableLiveData<List<String>> = MutableLiveData()


    /**
     *  连连第三方  检查银行卡
     */
    fun checkCardBank(cardNo: String) {
        setIsLoading(true)
        dataManager.httpService.checkCardBank(cardNo)
            .compose<BaseModel<BankItemBean>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<BankItemBean>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<BankItemBean>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        t.data?.let { mCallback?.checkCardSuccess(it) }
                    } else {
                        mCallback?.checkCardFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 添加银行卡
     */
    fun addCardBank(cardBean: BankBeam) {
        setIsLoading(true)
        dataManager.httpService.saveBankCard(cardBean)
            .compose<BaseModel<Any>>(XNet.getSingleTransformer())
            .performOnBackOutOnMain(scheduler)
            .doAfterSuccess { }
            .subscribeWith(object : ApiSubscriber<BaseModel<Any>>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                }

                override fun success(t: BaseModel<Any>) {
                    setIsLoading(false)
                    //业务的成功与否
                    if (t.success) {
                        mCallback?.addCardSuccess()
//                        t.data?.let { mCallback.addCardSuccess(it) }
                    } else {
                        mCallback?.addCardFail(t.msg.toString())
                    }
                }
            })
            .addTo(compositeDisposable)
    }


    /**
     * 获取城市列表
     */
    fun getCity() {
        setIsLoading(true)
        Single.just(URL("http://xhdianapp.oss-cn-beijing.aliyuncs.com/cityCode.json"))
            .compose { upstream ->
                upstream.flatMap {
                    Single.just(it.openConnection() as HttpURLConnection)
                }
            }
            .compose { upstream ->
                upstream.flatMap {
                    if (it.responseCode == HttpURLConnection.HTTP_OK) {
                        Single.just(it)
                    } else {
                        Single.error(NetError("无数据", NetError.NoDataError))
                    }
                }
            }
            .doAfterSuccess { }
            .compose { upstream ->
                upstream.flatMap {
                    val reader = BufferedReader(InputStreamReader(it.inputStream))
                    val strBuilder = StringBuilder()
                    reader.forEachLine {
                        strBuilder.append(it)
                    }
                    Single.just(strBuilder)
                }
            }
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<StringBuilder>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getCityFail("")
                }

                override fun success(t: StringBuilder) {
                    setIsLoading(false)
                    //业务的成功与否
                    mCallback?.getCitySuccess(Gson().fromJson(t.toString(), Array<CityBean>::class.java).toList())
                }
            })
            .addTo(compositeDisposable)

    }




    /**
     * 获取城市列表
     */
    fun getBank() {
        setIsLoading(true)
        Single.just(URL("http://xhdianapp.oss-cn-beijing.aliyuncs.com/bankCode.json"))
            .compose { upstream ->
                upstream.flatMap {
                    Single.just(it.openConnection() as HttpURLConnection)
                }
            }
            .compose { upstream ->
                upstream.flatMap {
                    if (it.responseCode == HttpURLConnection.HTTP_OK) {
                        Single.just(it)
                    } else {
                        Single.error(NetError("无数据", NetError.NoDataError))
                    }
                }
            }
            .doAfterSuccess { }
            .compose { upstream ->
                upstream.flatMap {
                    val reader = BufferedReader(InputStreamReader(it.inputStream))
                    val strBuilder = StringBuilder()
                    reader.forEachLine {
                        strBuilder.append(it)
                    }
                    Single.just(strBuilder)
                }
            }
            .performOnBackOutOnMain(scheduler)
            .subscribeWith(object : ApiSubscriber<StringBuilder>() {
                override fun onFail(error: NetError?) {
                    //网络方面的错误
                    setIsLoading(false)
                    mCallback?.getBankFail("")
                }

                override fun success(t: StringBuilder) {
                    setIsLoading(false)
                    //业务的成功与否
                    mCallback?.getBankSuccess(Gson().fromJson(t.toString(), Array<BankCardBean>::class.java).toList())
                }
            })
            .addTo(compositeDisposable)

    }

}