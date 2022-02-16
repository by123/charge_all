import { stringify } from 'query-string';
import { get, post } from '@/utils/request';

export const api = {

  // 公共接口
  logout: '/logout',
  getImageCode: '/kaptcha',
  login: '/login',
  updatePassword: '/manageWeb/businessUser/modifyPwd',
  fetchDashboard: '/manageWeb/homePage/getIncomeAndDeviceInfo',
  findGetSmsCode: '/resetPassword',
  findCheckSmsCode: '/checkVerificationCodeWhenChangingPassword',
  findResetPassword: '/changingPassword',
  findGetSmsCodeAgain: '/resetPasswordForApp',
  getConfig: '/getSpecialCfg',
  getConfigFn: params => get('/getSpecialCfg', params),

  // 代理商
  agentList: '/manageWeb/user/querylist',
  agentListPost: '/manageWeb/user/querylistPost',
  agentDetail: '/manageWeb/user/queryDetail',
  addBiz: '/manageWeb/user/addTenant',
  updateBiz: '/manageWeb/user/modTenant',
  addAgent: '/manageWeb/user/addAgent',
  updateAgent: '/manageWeb/user/modAgent',
  updateAgentProfit: '/manageWeb/user/batchModProfitV2',
  queryAgent: '/manageWeb/user/queryChildMch',
  editBizRule: '/manageWeb/user/changeDefaultPriceRuleOfTenant',
  addChain: '/manageWeb/user/addChainAgent',
  addStore: '/manageWeb/user/addChainTenant',
  queryIndustyPrice: '/getIndustryPriceCfg',
  deleteAgent: '/manageWeb/user/delMch',
  transferAgent: '/manageWeb/agentMgr/switch/addSwitchTask',
  queryTransferAgentInfo: '/manageWeb/agentMgr/switch/qryMchInfo',
  queryProfitMore: '/manageWeb/agentMgr/switch/qryProfitGreaterAgent',
  searchMchByInfo: '/manageWeb/user/queryByInfoSingle',
  queryParentsByMchId: '/manageWeb/user/queryParentsByMchId',

  // 订单管理
  orderList: '/manageWeb/order/querylist',
  orderListPost: '/manageWeb/order/querylistPost',
  recoverOrder: '/manageWeb/order/recover',
  orderDetail: '/manageWeb/order/detail',
  orderRefund: '/manageWeb/order/refund',
  // generateOrderDownLoadLink: '/manageWeb/order/createOrderListExcel',
  generateOrderDownLoadLink: '/manageWeb/download/order/apply',
  changePwdLocation: '/manageWeb/complaint/changePwdCount', //post
  queryPwdList: '/manageWeb/complaint/queryPasswordListByOrderId',
  changePwdBook: '/manageWeb/device/changePwdList',
  undoPwdChange: '/manageWeb/device/removePwdList',

  // 设备管理
  deviceList: '/manageWeb/device/list',
  getDeviceList: '/manageWeb/device/queryDeviceList', // 新接口
  deviceDetail: '/manageWeb/device/detail',
  addDeviceByIds: '/manageWeb/device/addDeviceBySN',
  editDevice: '/manageWeb/device/bindorprice',
  queryDevice: '/manageWeb/device/bindingDeviceWithMchByCondition',
  transferDeviceBySn: '/manageWeb/device/transferDeviceBysnList', // 指定设备号转移
  transferDeviceByRange: '/manageWeb/device/transferDeviceBysnSection', // 指定设备区间转移 post
  transferDeviceByBusiness: '/manageWeb/device/transferByTenantId', // 指定商户转移 post
  untieDeviceBySn: '/manageWeb/device/unbindDeviceBysnList', // 指定设备号解绑
  untieDeviceByRange: '/manageWeb/device/unbindDeviceBysnSection', // 指定设备区间解绑 post
  untieDeviceByBusiness: '/manageWeb/device/unbindByTenantId', // 指定商户解绑 post
  queryDeviceByMchId: '/manageWeb/device/getTenantDeviceInfo', // 使用mchId查询子代理商
  addSnConfig: '/manageWeb/device/addSnCfg',
  deleteSnConfig: '/manageWeb/device/deleteSnCfg',
  editSnConfig: '/manageWeb/device/modSnCfg',
  fetchSnConfigList: '/manageWeb/device/getSnCfgList',
  getVersionList: '/manageWeb/device/getAllDeviceVersion',

  // 资金管理
  moneyBalanceList: '/manageWeb/app/getCashProfitByDate',
  moneyWithdrawalList: '/manageWeb/bank/withDrawList',
  moneyInfo: '/manageWeb/mp/home/top',
  moneyWithdrawal: '/manageWeb/bank/requestToWithDraw',
  fetchMoneyDetail: '/manageWeb/bank/getWithdrawDetail',
  fetchWithdrawalRule: '/manageWeb/bank/getWithdrawRuleByMchType',
  queryBankByCode: '/lianlianCardQuery',
  queryWithdrawalTax: withdrawMoney => get('/manageWeb/bank/queryWithdrawTax', {
    withdrawMoney,
    mchType: 0,
  }),

  // 人员管理
  personnelList: '/manageWeb/businessUser/list',
  personnelAdd: '/manageWeb/businessUser/createUser',
  personnelEdit: '/manageWeb/businessUser/modUser',
  allUsers: '/manageWeb/businessUser/getAllUser',
  personnelDelete: '/manageWeb/businessUser/delUser',

  // 账户管理
  accountDetail: '/manageWeb/user/queryDetail',
  bankInfo: '/manageWeb/bank/bankCardList',
  addBankCard: '/manageWeb/bank/save',
  salesmanDetail: '/manageWeb/app/mydetail',
  getBankCodeList: 'https://jifung-pub.oss-cn-shenzhen.aliyuncs.com/bankCode.json',
  getCityCodeList: 'https://jifung-pub.oss-cn-shenzhen.aliyuncs.com/cityCode.json',

  // 设备出厂初始化
  getFirstLevelMch: '/manageWeb/user/getFirstLevelMch',
  deviceInitDetail: '/manageWeb/device/getDevicePublishTaskDetail',
  getDevicePublishTaskResult: '/manageWeb/device/getDevicePublishTaskResult',
  createDevicePublishTask: '/manageWeb/device/createDevicePublishTask',
  deleteDevice: '/manageWeb/device/deleteDevice',
  allocateDeviceBySn: '/manageWeb/deviceMgr/transfer/transferBySnList',
  allocateDeviceBySection: '/manageWeb/deviceMgr/transfer/transferBySnSection',
  allocateDeviceByFile: mchId => `/manageWeb/deviceMgr/transfer/transferBySnFile?mchId=${mchId}`,
  recallDeviceByFile: '/manageWeb/download/recall/apply/snFile',

  // 生产统计
  productionAuth: '/manageWeb/produce/login',
  getStatisticsData: '/manageWeb/produce/statistics', // 获取工厂今日的计划和生产量统计 生产统计头部
  getStatisticsList: '/manageWeb/produce/statistics/list', // 获取发货统计列表 生产统计列表
  getPlanData: '/manageWeb/produce/plan/statistics', // 获取近三个月的生产和计划统计数据 上报计划头部数据
  getPlanList: '/manageWeb/produce/plan/list', // 获取生产计划列表 上报计划列表数据
  postPlanList: (id, random) => `/manageWeb/produce/plan/list?factoryId=${id}&random=${random}`, // 更新生产计划列表 更新上报计划列表数据
  getDeliverList: '/manageWeb/produce/deliver/list', // 获取发货计划列表 上报发货列表数据
  postDeliverList: (id, random) => `/manageWeb/produce/deliver/list?factoryId=${id}&random=${random}`, // 更新生产发货列表
  getDeliverData: '/manageWeb/produce/deliver/statistics', // 获取近两个月的发货统计数据 上报发货头部数据
  getFactoryList: '/manageWeb/produce/factory/list', // 获取工厂列表

  // 报表中心
  getChildrenDeviceUsingCondition: '/manageWeb/user/getChildrenDeviceUsingCondition',
  getDeviceUsingCondition: '/manageWeb/user/getDeviceUsingCondition',
  generateDownloadLink: '/manageWeb/user/getExcel',
  getDeviceReportList: '/manageWeb/deviceMgr/report/getPCReport',
  getDeviceReportData: '/manageWeb/deviceMgr/report/getReportSum',
  getAllDeviceReportList: '/manageWeb/deviceMgr/report/getChildrenHistoryReportByMchId',
  getAllDeviceReportData: '/manageWeb/deviceMgr/report/getHistoryReportByMchId',
  generateDeviceReport: '/manageWeb/deviceMgr/report/addPCReportTask',

  // 财务中心
  getApplyLists: '/manageWeb/bank/getWithDrawCheckList',
  viewAuditdetails: '/manageWeb/bank/getWithdrawDetail',
  checkWithDrawRequestAfterLianLianWarned: '/manageWeb/bank/checkWithDrawRequestAfterLianLianWarned',
  getWithdrawalManageList: '/manageWeb/bank/getBankCardInfoListByCondition',
  editBankInfo: '/manageWeb/bank/editBankCardInfo', //post
  modWithdrawalState: '/manageWeb/bank/modWithdrawState',
  deleteBankCardById: '/manageWeb/bank/deleteBankCardById',
  getExpendList: params => get('/manageWeb/finance/expend', params),
  getIncomeList: params => get('/manageWeb/finance/income', params),
  downloadFinanceData: params => get('/manageWeb/finance/download', params),

  // 客服中心
  getComplainList: '/manageWeb/complaint/complaintList',
  viewComplainDetails: '/manageWeb/complaint/complaintDetail',
  changeComplainState: '/manageWeb/complaint/changeComplaintState', //post
  addTelComplain: '/manageWeb/telcomplain/telcomplainmgr/addTelComplain', // post
  delTelComplain: '/manageWeb/telcomplain/telcomplainmgr/delTelComplain',
  getTelComplainDetail: '/manageWeb/telcomplain/telcomplainmgr/getTelComplainDetail',
  modTelComplain: '/manageWeb/telcomplain/telcomplainmgr/modTelComplain',
  getTelComplainList: '/manageWeb/telcomplain/telcomplainmgr/queryListTelComplain',
  getCompainTypeStats: params => get('/manageWeb/telcomplain/telcomplainmgr/queryComplainTypeStats', params), // 查询投诉类型统计
  getDeviceProblemStats: params => get('/manageWeb/telcomplain/telcomplainmgr/queryDeviceProblemStats', params), // 查询设备问题统计
  getComplainVersionStats: params => get('/manageWeb/telcomplain/telcomplainmgr/queryDeviceVersionStats', params), // 查询投诉版本统计
  getTelRecordStats: params => get('/manageWeb/telcomplain/telcomplainmgr/queryListIncomingCallStats', params), // 查询来电记录统计
  getTelResolveStats: params => get('/manageWeb/telcomplain/telcomplainmgr/queryResolveStats', params), // 查询解决情况统计
  getTelCustomerStats: params => get('/manageWeb/telcomplain/telcomplainmgr/queryServiceUserStats', params), // 查询处理客服统计
  modTelRecordStats: params => post('/manageWeb/telcomplain/telcomplainmgr/modIncomingCallStats', params), // 修改来电记录统计
  applyDownloadComplain: params => post('/manageWeb/download/complain/apply', params),

  // 运营中心
  untieWechat: '/manageWeb/user/deleteWeixinBind', //unionId
  fetchWechatList: '/manageWeb/mp/queryMchWxRelation',
  fetchAdList: params => post('/manageWeb/adMgr/adMgr/listADConfig', params),
  modADConfig: params => `/manageWeb/adMgr/adMgr/modADConfig${params ? `?${stringify(params)}` : ''}`,
  addAdConfig: params => `/manageWeb/adMgr/adMgr/addADConfig${params ? `?${stringify(params)}` : ''}`,
  delAdConfig: '/manageWeb/adMgr/adMgr/delADconfig',
  fetchAdDetail: '/manageWeb/adMgr/adMgr/getADConfigDetail',
  getAdStatistic: '/manageWeb/adMgr/adMgr/getADDayStats',
  modADConfigPic: id => `/manageWeb/adMgr/adMgr/modADConfigPic?ADId=${id}`,
  examineAdConfig: params => get('/manageWeb/adMgr/adMgr/adExamine', params),
  fetchNoticeList: '/manageWeb/message/notice/queryNoticeMessageList', // get
  addNotice: '/manageWeb/message/notice/addNoticeMessage', // post
  delNotice: '/manageWeb/message/notice/delNoticeMessage', // id
  modNotice: '/manageWeb/message/notice/modNoticeMessage',
  queryNoticeDetail: '/manageWeb/message/notice/getNoticeMessageDetail', // id
  uploadPublicFile: '/manageWeb/message/notice/uploadPulicOss', // post file

  // 出租车 分组
  addGroup: '/manageWeb/taxi/group/add',
  fetchGroupList: '/manageWeb/taxi/group/page',
  fetchGroupListAll: '/manageWeb/taxi/group/list',
  updateGroupDetail: '/manageWeb/taxi/group/mod',
  // fetchGroupList: '/manageWeb/taxi/group/page',
  fetchGroupDetail: (groupId) => `/manageWeb/taxi/group/${groupId}`,

  // 出租车 设备
  addToGroupByRange: '/manageWeb/taxi/device/addToGroupBySection', // 根据设备起止号添加到分组
  addToGroupBySnList: '/manageWeb/taxi/device/addToGroupBySnList', // 指定设备列表添加到分组
  queryTaxiDeviceDetail: '/manageWeb/taxi/device/detail',
  fetchTaxiDeviceList: '/manageWeb/taxi/device/list',
  updateTaxiDeviceInfo: '/manageWeb/taxi/device/mod',
  transferDeviceByGroup: '/manageWeb/taxi/device/transferDeviceGroup',

  // 出租车 订单
  fetchTaxiOrderList: '/manageWeb/taxi/order/querylistPost',

  changeDevice: '/manageWeb/taxi/device/changeDevice',

  // 下载中心
  fetchDownloadList: '/manageWeb/download/mgr/list',
  deleteDownloadItem: '/manageWeb/download/mgr/del',
};
