package com.xhd.td.net

import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.*
import io.reactivex.Single
import retrofit2.http.*

/**
 * create by xuexuan
 * time 2018/6/27 20:13
 */
interface HttpService {
    //登录
    @POST("applogin")
    fun login(@Body loginVo: LoginBean): Single<BaseModel<LoginResultBean>>

    //首页
    @GET("manageWeb/app/home")
    fun getPerformanceInfo(): Single<BaseModel<PerformanceDTO>>

    //修改密码
    @POST("manageWeb/businessUser/modifyPwd")
    fun modifyPwd(@Body modifyPwdVo: ModifyBean): Single<BaseModel<String>>


    //验证验证码
    @POST("checkVerificationCodeWhenChangingPassword")
    fun vefifyCode(@Body changingPwdValidateVerificationCodeVo: VerifyCodeBean): Single<BaseModel<String>>

    //修改密码
    @POST("changingPassword")
    fun changePwd(@Body changingPwdValidateVerificationCodeVo: ChangePwdBean): Single<BaseModel<String>>

    //发送验证码
    @GET("resetPasswordForApp")
    fun getSMSCode(@Query("userName") userName: String): Single<BaseModel<String>>


    //获取后台配置
    @GET("getSpecialCfg")
    fun getCfg(@Query("cfgKey0") cfgKey0: String,@Query("cfgKey1") cfgKey1: String?=null): Single<BaseModel<CfgBean>>

//    //查询商户列表
//    @GET("manageWeb/app/mch")
//    fun getMch(@Query("mchName") mchName: String): Call<RetroFitBeam<List<MchBean>>>
//
    //激活设备
    @POST("manageWeb/app/active")
    fun activeDev(@Body activeDeviceVo: ActiveDeviceBean):  Single<BaseModel<String>>


    //出租车激活设备
    @POST("manageWeb/taxi/device/addToGroupBySnList")
    fun taxiActiveDev(@Body taxiActivateDevice: TaxiActivateDevice):  Single<BaseModel<List<BatchOperationDeviceBean>>>


    //添加连锁店分店
    @POST("manageWeb/user/addChainTenant")
    fun addChainTenant(@Body addChainTenantVo: AddMerchantBean):Single<BaseModel<AddResponseBean>>


    //添加商户
    @POST("manageWeb/user/addTenant")
    fun addTenant(@Body addTenantVo: AddMerchantBean): Single<BaseModel<AddResponseBean>>


    //添加连锁店
    @POST("manageWeb/user/addChainAgent")
    fun addChainAgent(@Body addChainAgentVo: AddMerchantBean): Single<BaseModel<AddResponseBean>>


    //添加代理商
    @POST("manageWeb/user/addAgent")
    fun addAgent(@Body addAgentVo: AddMerchantBean): Single<BaseModel<AddResponseBean>>

    //添加业务员
    @POST("manageWeb/businessUser/createUser")
    fun addSalesman(@Body businessUserVo: AddSalesmanBean):  Single<BaseModel<SalesmanResultBean>>

    //绑定商户
    @POST("manageWeb/app/bindingTenantWeixinUser")
    fun bindTenant(@Body bindingTenantWeixinUserVo: BindMerchantBean): Single<BaseModel<String>>

    //测试绑定商户
    @GET("manageWeb/app/checkOpenIdOnBindingTenant")
    fun checkTenant(@Query("openId") openId: String, @Query("type") type: String): Single<BaseModel<String>>

    //个人信息
    @GET("manageWeb/app/mydetail")
    fun getMyDetail(): Single<BaseModel<AccountDetailBean>>

    //查询银行卡
    @GET("manageWeb/bank/detail")
    fun getCardInfo(): Single<BaseModel<CardInfoBean>>


    //查询银行卡列表
    @GET("manageWeb/bank/bankCardList")
    fun getBankListInfo(): Single<BaseModel<BankListBean>>


    //获取版本号  softwareType  0=Android  1=ios  2= Android 灰度更新
    @GET("getSoftwareUpdateVersion")
    fun getVersion(@Query("currentVersionNum") currentVersionNum: Int, @Query("softwareType") softwareType: Int = 0): Single<BaseModel<List<VersionBeam>>>

    //获取重置码
    @GET("manageWeb/app/getResetPasswordDeviceCode")
    fun getResetCode(@Query("deviceSn") deviceSn: String): Single<BaseModel<String>>

    //确认重置
    @GET("manageWeb/app/confirmResetDevicePassword")
    fun confirmReset(@Query("deviceSn") deviceSn: String): Single<BaseModel<String>>

    //获取开发商数/获取设备激活数
//    @GET("manageWeb/app/homedetail")
//    fun getTotalMerchantAndDevice(@Query("startDate") startDate: String, @Query("endDate") endDate: String, @Query("type") type: Int
//                                  , @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int): Single<BaseModel<TotalMerchantBean<TotalMerchantDetailBean>>>



    //获取直属开发商户数
    @GET("manageWeb/app/directMchList")
    fun getDirectMchList(@Query("bgnDate") startDate: String, @Query("endDate") endDate: String,
                         @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int,
                         @Query("mchId") mchId: String?,@Query("keyWord") keyword: String?): Single<BaseModel<PageBean<DevMchListBean>>>




    //获取下级开发商户数
    @GET("manageWeb/app/subordinateMchList")
    fun getSubordinateMchList(@Query("bgnDate") startDate: String, @Query("endDate") endDate: String,
                         @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int,
                         @Query("mchId") mchId: String?,@Query("keyWord") keyword: String?): Single<BaseModel<PageBean<DevMchListBean>>>



    //获取开发商户数的统计
    @GET("manageWeb/app/mchStats")
    fun getDevMchTotal(@Query("bgnDate") startDate: String, @Query("endDate") endDate: String,
                           @Query("mchId") mchId: String?): Single<BaseModel<DevMchSum>>



    //获取激活设备数报表
    @GET("manageWeb/deviceMgr/report/getAppReport")
    fun getActiveDeviceReport(@Query("startDay") startDate: String, @Query("endDay") endDate: String,
                              @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int,
                              @Query("mchId") mchId: String?,@Query("qryInfo") keyword: String?): Single<BaseModel<PageBean<ActiveDeviceListBean>>>

    //获取激活设备数报表,激活设备的总数
    @GET("manageWeb/deviceMgr/report/getReportSum")
    fun getActiveDeviceSum(@Query("startDay") startDate: String, @Query("endDay") endDate: String,
                              @Query("mchId") mchId: String?,@Query("qryInfo") keyword: String?): Single<BaseModel<ActiveDeviceSum>>


    //设备收益
    @GET("manageWeb/app/getCashProfitByDate")
    fun getDeviceIncome(@Query("startDate") startDate: String, @Query("endDate") endDate: String
                        , @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int, @Query("addZeroData") addZeroData: Int = 0): Single<BaseModel<EarningDetailBeam>>

    //资金首页
    @GET("manageWeb/mp/home/top")
    fun getTop(): Single<BaseModel<IncomeBean>>


    //获取订单
    @POST("manageWeb/order/querylistPost")
    fun getOrderList(@Body orderQueryListVo: OrderQueryBean): Single<BaseModel<OrderData>>

    //获取订单by ID 设备号   商户名
    @GET("manageWeb/order/querylist")
    fun queryOrderListByKey(@Query("orderId") orderId: String? = null,@Query("deviceSn") deviceSn: String? = null,@Query("mchName") mchName: String? = null,
                     @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int = 100):Single<BaseModel<OrderData>>


    //退款
    @POST("manageWeb/order/refund")
    fun refund(@Body orderRefundVo: RefundBean): Single<BaseModel<String>>

    //订单详情
    @GET("manageWeb/order/detail")
    fun getOrderDetails(@Query("orderId") orderId: String): Single<BaseModel<OrderDetailBean>>


    //
//    //订单详情
//    @GET("manageWeb/order/detail")
//    fun getOrderDetail(@Query("orderId") orderId: String)

    //添加银行卡
    @POST("manageWeb/bank/save")
    fun saveBankCard(@Body bankVo: BankBeam): Single<BaseModel<Any>>


    //提现规则  mchType 商户类型，0:代理商, 1:普通商户,-2全部  channel: 0 连连渠道, 1:微信渠道
    @GET("manageWeb/bank/getWithdrawRuleByMchTypeAndChannel")
    fun getWithdrawRuleByMchTypeAndChannel(@Query("mchType") mchType: Int = -2,@Query("channel") channel: Int?): Single<BaseModel<List<BankCardWithDrawRule>>>


    //提现规则  mchType 商户类型，0:代理商, 1:普通商户, 不传为全部,按照阶梯收费
    @GET("manageWeb/bank/getWithdrawRuleByMchType")
    fun getWithdrawRuleByMchType(@Query("mchType") mchType: Int? = null): Single<BaseModel<List<WithDrawRule>>>


    //提现手续费规则  mchType 商户类型，0:代理商, 1:普通商户, 不传为全部,按照阶梯收费
    // 提现手续费（银行收取），支付手续费（支付收取），代扣税
    //GET /manageWeb/bank/queryWithdrawTax
    @GET("manageWeb/bank/queryWithdrawTax")
    fun queryWithdrawTax(@Query("withdrawMoney") withdrawMoney:Double,@Query("mchType") mchType: Int? = null): Single<BaseModel<WithDrawFee>>

    //提现
    @POST("manageWeb/bank/requestToWithDraw")
    fun applyWithdrawal(@Body requestToPayVo: WithdrawBean): Single<BaseModel<WithDrawResultBean>>

//    //提现详情
//    @GET("manageWeb/bank/getWithdrawDetail")
//    fun getWithDrawDetail(@Query("withDrawId") withDrawId: String): Call<RetroFitBeam<WithDrawResultBean>>
//
    //提现列表
    @GET("manageWeb/bank/withDrawList")
    fun getWithDrawList(@Query("startDate") startDate: String, @Query("endDate") endDate: String
                        , @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int): Single<BaseModel<WithDrawDetailBeam>>

    //获取代理商默认规则
    @GET("manageWeb/user/getDefaultDevicePriceRule")
    fun getBillingRules(): Single<BaseModel<PriceListBean>>




    //获取子代理
    @GET("manageWeb/user/queryChildMch")
    fun queryChildMch(@Query("mchId") mchId: String = UserModel.userBean?.mchId ?: ""): Single<BaseModel<List<MchBean>>>

    /**
     * mchType  商户类型，0:代理商， 1:普通商户，-1全部
     */
    @GET("manageWeb/user/blurQuerySubMch")
    fun queryBlurMch(@Query("queryName") queryName: String, @Query("mchType") mchType: Int): Single<BaseModel<List<MchBean>?>>


    /**
     * mchType  商户类型，0:代理商， 1:普通商户，-1全部
     */
    @POST("manageWeb/user/querylistPost")
    fun querylistPost(@Body queryAgentMch: QueryAgentMchBean): Single<BaseModel<PageBean<MchBean>?>>


//    /**
//     *mchType  商户类型，0:代理商， 1:普通商户，-1全部
//     */
//    @GET("manageWeb/user/blurQuerySubMch")
//    fun queryBlurMchAll(@Query("queryName") queryName: String, @Query("mchType") mchType: Int = -1, @Query("queryDirectMchType") queryDirectMchType: Int = 1): Call<RetroFitBeam<List<MchBean>?>>

    //代理商详情
    @GET("manageWeb/user/queryDetail")
    fun queryDetail(@Query("mchId") mchId: String): Single<BaseModel<MchBean>>

    //编辑代理商
    @POST("manageWeb/user/modAgent")
    fun modAgent(@Body modAgentVo: EditBeam): Single<BaseModel<String>>

    //编辑商户
    @POST("manageWeb/user/modTenant")
    fun modTenant(@Body modAgentVo: EditBeam): Single<BaseModel<String>>

    //修改价格
    @POST("manageWeb/user/changeDefaultPriceRuleOfTenant")
    fun changeRule(@Body changeDefaultPriceRuleVo: ChangeRuleBeam): Single<BaseModel<String>>

    //资金详情头部
    @GET("manageWeb/user/getDeviceUsingCondition")
    fun getIncomeCondition(@Query("queryDate") queryDate: String): Single<BaseModel<IncomeTopBeam>>

    //获取
    @GET("manageWeb/user/getChildrenDeviceUsingCondition")
    fun getChildrenDeviceUsingScenes(@Query("queryDate") queryDate: String, @Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int = 100): Single<BaseModel<IncomeTempBeam<IncomeTopBeam>>>

    //连连银行卡查询
    @GET("lianlianCardQuery")
    fun checkCardBank(@Query("cardNo") cardNo: String):Single<BaseModel<BankItemBean>>

    //白名单逐级查询子商户和/或子代理，只查询一个层级
    @GET("manageWeb/user/queryGraduallyChildMch")
    fun queryGraduallyChildMch(@Query("mchId") mchId: String): Single<BaseModel<List<MchBean>>>

    //创建白名单
    @POST("manageWeb/app/createOrderWhiteList")
    fun createOrderWhiteList(@Body createOrderWhiteListVo: CreateOrderWhiteListBean): Single<BaseModel<String>>

    //获取白名单列表
    @GET("manageWeb/app/getOrderWhiteListPage")
    fun getOrderWhiteListPage(@Query("pageId") pageId: Int,@Query("pageSize") pageSize: Int = 50): Single<BaseModel<WhitelistItemBean>>

    //修改白名单 /manageWeb/app/editOrderWhiteList
    @POST("manageWeb/app/editOrderWhiteList")
    fun editOrderWhiteList(@Body  editOrderWhiteListVo:EditWhitelistBean): Single<BaseModel<String>>


    //获取白名单列表
    @GET("manageWeb/user/queryWhiteListNodeTree")
    fun queryWhiteListNodeTree(@Query("orderWhiteListId") orderWhiteListId: String,@Query("mchId") mchId: String): Single<BaseModel<List<WhitelistMerchantBean>>>

    //创建出租车分组
    @POST("manageWeb/taxi/group/add")
    fun addGroup(@Body  createTaxiGroup:TaxiGroupBean): Single<BaseModel<TaxiGroupBean>>

    //修改出租车分组
    @POST("manageWeb/taxi/group/mod")
    fun modGroup(@Body  createTaxiGroup:TaxiGroupBean): Single<BaseModel<TaxiGroupBean>>

    //查询当前商户，所有用户信息  type ：1:普通管理员 2：代理商业务员，3：商户业务员，默认查所以用户
    @GET("manageWeb/businessUser/getAllUser")
    fun getAllUser(@Query("roleType") type: Int): Single<BaseModel<List<SalesmanBean>>>

    //分页获取分组列表
    @POST("manageWeb/taxi/group/page")
    fun queryGroup(@Body  reqVo:QueryGroupBean): Single<BaseModel<Pages<TaxiGroupBean>>>



    //获取微信登录的accesstoken
    @GET("manageWeb/bank/bindWechatBankInfo")
    fun getWechatAccessToken(@Query("code") code: String): Single<BaseModel<TblUserUnionid>>


    //获取微信的个人信息
    @GET("https://api.weixin.qq.com/sns/userinfo")
    fun getWechatInfo(@Query("access_token") accessToken: String,@Query("openid") openid: String): Single<BaseModel<String>>


    //用于 获取微信的个人信息
    @GET
    fun getWechatInfo(@Url url:String): Single<BaseModel<String>>


    //查询商家或代理商设备统计信息，只查直属的设备
    @GET("manageWeb/device/getTenantDeviceInfo")
    fun getTenantDeviceInfo(@Query("mchId") mchId:String? = null, @Query("groupId")groupId:String? = null): Single<BaseModel<DeviceAmount>>


    //解绑指定商户的设备
    @GET("manageWeb/device/unbindByTenantId")
    fun unbindByTenantId(@Query("mchId") mchId:String): Single<BaseModel<UnbindSuccessAmount>>


    //扫码解绑设备
    @POST("manageWeb/device/unbindDeviceBysnList")
    fun unbindDeviceBysnList(@Body deviceUnbindLstVo:DeviceSnList): Single<BaseModel<List<BatchOperationDeviceBean>>>

    //扫码解绑设备
    @GET("manageWeb/device/detail")
    fun getDeviceDetailBySn(@Query("sn") sn:String): Single<BaseModel<DeviceInfo>>


    //向服务器发送友盟的devicetoken
    @GET("manageWeb/message/notice/addDiviceToken")
    fun addDeviceToken(@Query("deviceToken") deviceToken: String,@Query("devicePlatform") devicePlatform :Int= 1): Single<BaseModel<String>>


    //获取消息列表
    //beginTime : 查询消息起始时间，格式:2019-07-16 12:00:00
    @GET("manageWeb/message/notice/queryNoticeMessageList")
    fun queryNoticeMessageList(@Query("beginTime") beginTime: String?,@Query("pageId") pageId: Int, @Query("pageSize") pageSize: Int = 100): Single<BaseModel<PageBean<MessageBean>?>>



    //获取消息的详细信息
    @GET("manageWeb/message/notice/getNoticeMessageDetail")
    fun getNoticeMessageDetail(@Query("id") id: Int): Single<BaseModel<MessageBean>>

}