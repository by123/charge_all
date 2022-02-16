/**
 * ActionType file
 * @type {string}
 */

// global
export const login = 'login';
export const resetLoginErrorInfo = 'resetLoginErrorInfo';
export const getCurrentUser = 'getCurrentUser';
export const toggleMPModal = 'toggleMPModal';
export const updatePassword = 'updatePassword';
export const getImageCode = 'getImageCode';
export const cleanLoginForm = 'cleanLoginForm';
export const getAccountFromCookie = 'getAccountFromCookie';
export const generateUuid = 'generateUuid';
export const toggleFindPassword = 'toggleFindPassword';
export const findPassword = 'findPassword';
export const getMessageCode = 'getMessageCode';
export const findGetSmsCode = 'findGetSmsCode';
export const findCheckSmsCode = 'findCheckSmsCode';
export const findResetPassword = 'findResetPassword';
export const findGetSmsCodeAgain = 'findGetSmsCodeAgain';
export const getRefundReason = 'getRefundReason';

export const showGlobalLoading = 'showGlobalLoading';
export const toggleErrorList = 'toggleErrorList';

// 首页
export const fetchDashboard = 'fetchDashboard';

// 图片上传组件依赖的token
export const fetchImageToken = 'fetchImageToken';
export const fetchPrivateImageToken = 'fetchPrivateImageToken';

export const fetchMenuList = 'fetchMenuList';

// 代理商
export const fetchAgentList = 'fetchAgentList';
export const fetchAgentDetail = 'fetchAgentDetail';

export const selectedAgentRow = 'selectedAgentRow';
export const toggleAddProfitModal = 'toggleAddProfitModal';

export const toggleEditAgentModal = 'toggleEditAgentModal';
export const addAgentInfo = 'addAgentInfo';
export const updateAgentInfo = 'updateAgentInfo';

export const toggleAccountInfoModal = 'toggleAccountInfoModal';
export const removeAgentDetail = 'removeAgentDetail';
export const updateAgentProfit = 'updateAgentProfit';

export const fetchSelfInfo = 'fetchSelfInfo';

export const toggleErrorListModal = 'toggleErrorListModal';
export const editBizRule = 'editBizRule';
export const addChain = 'addChain';
export const addChainBiz = 'addChainBiz';
export const changeAgentType = 'changeAgentType';
export const queryParentProfit = 'queryParentProfit';
export const removeAddedStore = 'removeAddedStore';
export const queryIndustyPrice = 'queryIndustyPrice';
export const deleteAgent = 'deleteAgent';

export const toggleTransferAgentModal = 'toggleTransferAgentModal';
export const transferAgent = 'transferAgent';
export const queryTransferAgentInfo = 'queryTransferAgentInfo';
export const queryProfitMore = 'queryProfitMore';

// 订单管理
export const fetchOrderList = 'fetchOrderList';
export const recoverOrder = 'recoverOrder';
export const fetchOrderDetail = 'fetchOrderDetail';
export const toggleRefundModal = 'toggleRefundModal';
export const orderRefund = 'orderRefund';
export const toggleDetailModal = 'toggleDetailModal';
export const generateOrderDownloadLink = 'generateOrderDownloadLink';
export const toggleOrderDownloadModal = 'toggleOrderDownloadModal';
export const queryPwdList = 'queryPwdList';
export const changePwdLocation = 'changePwdLocation';
export const toggleQueryPwdModal = 'toggleQueryPwdModal';
export const toggleQueryPwdResultModal = 'toggleQueryPwdResultModal';
export const changePageId = 'changePageId';
export const changePwdSelected = 'changePwdSelected';
export const resetPwdData = 'resetPwdData';
export const toggleCustomerModal = 'toggleCustomerModal';
export const addTelComplain = 'addTelComplain';
export const delTelComplain = 'delTelComplain';
export const getTelComplainDetail = 'getTelComplainDetail';
export const modTelComplain = 'modTelComplain';
export const getTelComplainList = 'getTelComplainList';
export const getProblemList = 'getProblemList';

// 设备管理
export const fetchDeviceList = 'fetchDeviceList';
export const fetchDeviceDetail = 'fetchDeviceDetail';
export const toggleAddDeviceModal = 'toggleAddDeviceModal';
export const addDevice = 'addDevice';
export const toggleDeviceResultModal = 'toggleDeviceResultModal';
export const toggleAddResultModal = 'toggleAddResultModal';
export const selectedDeviceRow = 'selectedDeviceRow';
export const editDevice = 'editDevice';
export const toggleEditDeviceModal = 'toggleEditDeviceModal';
export const toggleBindAgentModal = 'toggleBindAgentModal';
export const toggleEditBillingModal = 'toggleEditBillingModal';
export const queryDevice = 'queryDevice';
export const queryAgent = 'queryAgent';
export const transferDeviceBySn = 'transferDeviceBySn';
export const transferDeviceByRange = 'transferDeviceByRange';
export const transferDeviceByBusiness = 'transferDeviceByBusiness';
export const untieDeviceBySn = 'untieDeviceBySn';
export const untieDeviceByRange = 'untieDeviceByRange';
export const untieDeviceByBusiness = 'untieDeviceByBusiness';
export const queryDeviceByMchId = 'queryDeviceByMchId';
export const toggleTransferDeviceModal = 'toggleTransferDeviceModal';
export const toggleUntieDeviceModal = 'toggleUntieDeviceModal';
export const toggleUntieConfirmModal = 'toggleUntieConfirmModal';
export const toggleTransferConfirmModal = 'toggleTransferConfirmModal';
export const confirmUntieDevice = 'confirmUntieDevice';
export const confirmTransferDevice = 'confirmTransferDevice';
export const fetchIndustryList = 'fetchIndustryList';
export const fetchSnConfigList = 'fetchSnConfigList';
export const deleteSnConfig = 'deleteSnConfig';
export const editSnConfig = 'editSnConfig';
export const addSnConfig = 'addSnConfig';
export const changePwdBook = 'changePwdBook';
export const undoPwdChange = 'undoPwdChange';
export const searchMchByInfo = 'searchMchByInfo';
export const queryParentsByMchId = 'queryParentsByMchId';
export const getMinPrice = 'getMinPrice';

// 资金管理
export const fetchMoneyWithdrawalList = 'fetchMoneyWithdrawalList';
export const fetchMoneyBalanceList = 'fetchMoneyBalanceList';
export const changeMoneyTab = 'changeMoneyTab';
export const fetchMoneyInfo = 'fetchMoneyInfo';
export const fetchWithdrawalInfo = 'fetchWithdrawalInfo';
export const moneyWithdrawal = 'moneyWithdrawal';
export const changeWithdrawalInput = 'changeWithdrawalInput';
export const showWithdrawalModal = 'showWithdrawalModal';
export const fetchMoneyDetail = 'fetchMoneyDetail';
export const togleMoneyDetail = 'togleMoneyDetail';
export const fetchWithdrawalRule = 'fetchWithdrawalRule';
export const toggleEmptyBank = 'toggleEmptyBank';
export const queryWithdrawalTax = 'queryWithdrawalTax';

// 人员管理
export const fetchPersonnelList = 'fetchPersonnelList';
export const fetchAllUsers = 'fetchAllUsers';
export const addPersonnel = 'addPersonnel';
export const setModalVisiable = 'setModalVisiable';
export const closeModalVisiable = 'closeModalVisiable';
export const editPersonnel = 'editPersonnel';
export const saveSelectedRowData = 'saveSelectedRowData';
export const deletePersonnel = 'deletePersonnel';
export const toggleDeleteModal = 'toggleDeleteModal';

// 账户信息
export const fetchAccountDetail = 'fetchAccountDetail';
export const fetchSalesmanDetail = 'fetchSalesmanDetail';
export const setAccountRoleType = 'setAccountRoleType';
export const fetchBankInfo = 'fetchBankInfo';
export const addBankCard = 'addBankCard';
export const toggleAddBankModal = 'toggleAddBankModal';
export const toggleChooseModal = 'toggleChooseModal';
export const changeAddType = 'changeAddType';
export const fetchBankCodeList = 'fetchBankCodeList';
export const fetchCityCodeList = 'fetchCityCodeList';

//设备初始化
export const fetchDeviceInitList = 'fetchDeviceInitList';
export const toggleDeviceInitDetailModal = 'toggleDeviceInitDetailModal';
export const fetchDeviceInitDetail = 'fetchDeviceInitDetail';
export const createDevicePublishTask = 'createDevicePublishTask';
export const queryFirstAgent = 'queryFirstAgent';
export const toggleDeviceDelete = 'toggleDeviceDelete';
export const deleteDevice = 'deleteDevice';
export const toggleDeviceDeleteResult = 'toggleDeviceDeleteResult';
export const toggleDeleteDeviceFail = 'toggleDeleteDeviceFail';
export const getFirstLevelMch = 'getFirstLevelMch';
export const toggleAddSnConfigModal = 'toggleAddSnConfigModal';
export const getVersionList = 'getVersionList';
export const allocateDeviceBySn = 'allocateDeviceBySn';
export const allocateDeviceBySection = 'allocateDeviceBySection';
export const allocateDeviceByFile = 'allocateDeviceByFile';
export const recallDeviceByFile = 'recallDeviceByFile';

// 生产统计
export const getDeliverList = 'getDeliverList';
export const getDeliverData = 'getDeliverData';
export const postDeliverList = 'postDeliverList';
export const getPlanList = 'getPlanList';
export const getPlanData = 'getPlanData';
export const postPlanList = 'postPlanList';
export const getStatisticsData = 'getStatisticsData';
export const getStatisticsList = 'getStatisticsList';
export const productionAuth = 'productionAuth';
export const productionAuthSuccess = 'productionAuthSuccess';
export const getFactoryList = 'getFactoryList';

//报表中心
export const getChildrenDeviceUsingCondition = 'getChildrenDeviceUsingCondition';//分页
export const getDeviceUsingCondition = 'getDeviceUsingCondition';//时间filter
export const generateDownloadLink = 'generateDownloadLink';
export const getDeviceReportList = 'getDeviceReportList';
export const getDeviceReportData = 'getDeviceReportData';
export const getAllDeviceReportList = 'getAllDeviceReportList';
export const getAllDeviceReportData = 'getAllDeviceReportData';
export const generateDeviceReport = 'generateDeviceReport';

//财务中心
export const getApplyLists = 'getApplyLists';
export const viewAuditdetails = 'viewAuditdetails';
export const toggleApplyDetailModal = 'toggleApplyDetailModal';
export const toggleWarinEditModal = 'toggleWarinEditModal';
export const checkWithDrawRequestAfterLianLianWarned = 'checkWithDrawRequestAfterLianLianWarned';
export const getWithdrawalManageList = 'getWithdrawalManageList';
export const editBankInfo = 'editBankInfo';
export const toggleEditBankInfoModal = 'toggleEditBankInfoModal';
export const modWithdrawalState = 'modWithdrawalState';
export const toggleDeleteWechatModal = 'toggleDeleteWechatModal';
export const deleteWechatWithdrawal = 'deleteWechatWithdrawal';
export const getExpendList = 'getExpendList';
export const getIncomeList = 'getIncomeList';
export const downloadFinanceData = 'downloadFinanceData';

// 客服中心
export const getComplainList = 'getComplainList';
export const toggleComplainDetailModal = 'toggleComplainDetailModal';
export const viewComplainDetails = 'viewComplainDetails';
export const changeComplainState = 'changeComplainState';
export const toggleComplainRefund = 'toggleComplainRefundg';
export const getAllCustomer = 'getAllCustomer';
export const toggleDeleteComplainModal = 'toggleDeleteComplainModal';
export const togglePhoneResolveDetail = 'togglePhoneResolveDetail';

export const getCompainTypeStats = 'getCompainTypeStats';
export const getDeviceProblemStats = 'getDeviceProblemStats';
export const getComplainVersionStats = 'getComplainVersionStats';
export const getTelRecordStats = 'getTelRecordStats';
export const getTelResolveStats = 'getTelResolveStats';
export const getTelCustomerStats = 'getTelCustomerStats';
export const modTelRecordStats = 'modTelRecordStats';
export const applyDownloadComplain = 'applyDownloadComplain';

// 运营中心
export const toggleUntieComfirm = 'toggleUntieComfirm';
export const fetchWechatList = 'fetchWechatList';
export const untieWechat = 'untieWechat';

export const fetchAdList = 'fetchAdList';
export const fetchAdDetail = 'fetchAdDetail';
export const addAdConfig = 'addAdConfig';
export const delAdConfig = 'delAdConfig';
export const modADConfig = 'modADConfig';
export const getAdStatistic = 'getAdStatistic';
export const toggleEditAdModal = 'toggleEditAdModal';
export const toggleAdDetail = 'toggleAdDetail';
export const getPostionList = 'getPostionList';
export const modADConfigPic = 'modADConfigPic';
export const examineAdConfig = 'examineAdConfig';
export const uploadAdFile = 'uploadAdFile';
export const getAdAuthList = 'getAdAuthList';
export const menuAddAdItem = 'menuAddAdItem';

export const fetchNoticeList = 'fetchNoticeList';
export const delNotice = 'delNotice';
export const addNotice = 'addNotice';
export const modNotice = 'modNotice';
export const queryNoticeDetail = 'queryNoticeDetail';
export const uploadPublicFile = 'uploadPublicFile';
export const selectedNoticeRow = 'selectedNoticeRow';
export const toggleNoticeDeleteModal = 'toggleNoticeDeleteModal';

// 出租车
export const toggleAddGroupModal = 'toggleAddGroupModal';
export const fetchGroupList = 'fetchGroupList';
export const fetchGroupDetail = 'fetchGroupDetail';
export const getTaxiConfig = 'getTaxiConfig';
export const addGroup = 'addGroup';
export const editGroup = 'editGroup';
export const queryGroup = 'queryGroup';
export const toggleNoGroupModal = 'toggleNoGroupModal';

// 出租车设备
export const fetchTaxiDeviceList = 'fetchTaxiDeviceList';
export const queryTaxiDeviceList = 'queryTaxiDeviceList';
export const fetchTaxiDeviceDetail = 'fetchTaxiDeviceDetail';
export const addTaxiDeviceBySn = 'addTaxiDeviceBySn';
export const addTaxiDeviceByRange = 'addTaxiDeviceByRange';
export const cleanErrorList = 'cleanErrorList';
export const transferDeviceByGroup = 'transferDeviceByGroup';
export const editTaxiDevice = 'editTaxiDevice';

// 出租车订单
export const fetchTaxiOrderList = 'fetchTaxiOrderList';

export const exchangeDevice = 'exchangeDevice';

// 下载中心
export const toggleDownloadModal = 'toggleDownloadModal';
export const fetchDownloadList = 'fetchDownloadList';
export const deleteDownloadItem = 'deleteDownloadItem';
