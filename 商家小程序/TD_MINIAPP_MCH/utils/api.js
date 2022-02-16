import {
  get,
  post,
} from './http.js';

export const Api = {
  // code登录
  login: params => get('/mchMiniAppUser/login/wxLogin', params),

  // 发送用户信息
  sign: params => post('/mchMiniAppUser/getUserInfoFromWeixin', params),

  // 获取用于绑定的二维码
  getQrCode: params => get('/mchMiniAppUser/createBindingQRCode', params),

  // 订单相关
  // 订单列表 status, pageId, pageSize
  getOrderList: params => post('/manageWeb/order/querylistPost', params),

  // 订单详情 orderId
  // getOrderDetail: params => get('/manageWeb/mp/orderDetail', params),
  // /manageWeb/order/detail
  getOrderDetail: params => get('/manageWeb/order/detail', params),

  // 退款 orderId, reason, refundMoney
  refund: params => post('/manageWeb/order/refund', params),

  // 收益列表 pageId, pageSize
  getProfitList: params => get('/manageWeb/mp/home/endv2', params),

  // 提现列表 pageId, pageSize
  getWithdrawalList: params => get('/manageWeb/bank/withDrawList', params),

  // 申请提现 withdrawMoney
  withdrawal: params => post('/manageWeb/bank/requestToWithDraw', params),

  // 获取提现规则 mchType 商户类型，0:代理商， 1:普通商户
  getWithdrawalInfo: params => get('/manageWeb/bank/getWithdrawRule', params),

  // 获取特殊配置 withdraw_hint 提现到账时间
  getConfig: params => get('/getSpecialCfg', params),

  // 获取提现详情
  getWithdrawalDetail: params => get('/manageWeb/bank/getWithdrawDetail', params),

  // 收益数据
  getProfit: params => get('/manageWeb/mp/home/top', params),

  // 商户信息
  getUserInfo: params => get('/manageWeb/mp/mchDetail', params),

  // 查询指定代理商信息 mchId
  queryMchDetail: params => get('/manageWeb/user/queryDetail', params),

  // 银行卡信息
  getBankInfo: params => get('/manageWeb/bank/bankCardList', params),

  // 添加银行卡
  addBank: params => post('/manageWeb/bank/save', params),

  // 获取二维码
  getQr: params => get('/qrcode', params),

  // 获取设备复位码
  getResetCode: params => get('/manageWeb/app/getResetPasswordDeviceCode', params),

  // 获取设备复位码
  confirmResetCode: params => get('/manageWeb/app/confirmResetDevicePassword', params),

  // 激活设备  activeDeviceVo{deviceSn,mchId}
  activeDevice: params => post('/manageWeb/app/active', params),

  // 开户行城市列表
  getCityCodeList: params => get('https://xhdianapp.oss-cn-beijing.aliyuncs.com/cityCode.json', params),

  // 开户行列表
  getBankCodeList: params => get('https://xhdianapp.oss-cn-beijing.aliyuncs.com/bankCode.json', params),

  // 用卡号查询银行
  queryBankByCode: params => get('/lianlianCardQuery', params),

  // 判断身份是否是管理员
  checkIsAdmin: params => get('/manageWeb/businessUser/isAdminAccount', params),

  // 获取业务员联系方式
  getUserContactPhone: params => get('/manageWeb/businessUser/getContactPhone', params),

  // 获取认证验证码
  getVerificationCode: params => get('/manageWeb/app/getVerificationCode', params),

  // 认证微信 code, mobile, userId
  auth: params => post('/manageWeb/app/admin/authentication', params),

  // 绑定微信提现 openid，unionid，userId，username
  bindWechat: params => post('/manageWeb/app/bindingTenantWeixinBank', params),

  // 获取提现规则
  getWithdrawalRule: () => get('/manageWeb/bank/getWithdrawRuleByMchType', { mchType: 1 }),

  // 获取运营人员列表
  getOperatorList: params => get('/manageWeb/businessUser/getOperatorList', params),

  // 删除运营人员
  deleteOperator: params => post('/manageWeb/businessUser/deleteOperator', params),

  // 转让管理员
  transferAdmin: params => post('/manageWeb/businessUser/transferAdmin', params),
}
// export const AllApi = api;