//constant.js
let KEY_TOKEN = "token"
let KEY_TOKEN_TYPE = "tokenType"
let KEY_ERROR_SCAN = "scan_error"
let KEY_NEW_USER = "new_user"

/**请求**/


//测试url
// let rootUrl = "https://www.xhdian99.com/appserver"
// let scanUrl = "https://www.xhdian99.com/interface/qr?sn="

//正式url
let rootUrl = "https://admin.tandianvip.com/api"
let scanUrl = "https://admin.tandianvip.com/interface/qr?sn="

//小红电测试url
// let rootUrl = "https://www.weikeyingxiao.com/appserver"
// let scanUrl = "https://www.weikeyingxiao.com/interface/qr?sn="

//小红电正式url
// let rootUrl = "https://www.xreddian.com/appserver"
// let scanUrl = "https://www.xreddian.com/interface/qr?sn="

//查询sn是否可用
let URL_SN_INVALID = rootUrl + '/miniApp/homePage/checkWhetherDeviceCanBeUsed'
//支付待支付订单
let URL_PAY_WAITORDER = rootUrl + '/miniApp/order/payOrder'
//取消订单
let URL_CANCEL_ORDER = rootUrl + '/miniApp/order/cancelOrder'
//提前结束退押金
let URL_CLOSE_ORDER = rootUrl + '/miniApp/order/closeOrder'
//获取设备密码
let URL_GETDEVICE_PSW = rootUrl + '/miniApp/order/getDevicePasswordByOrderId'
//下单
let URL_CREATE_ORDER = rootUrl + '/miniApp/order/createChargeOrder'
//订单详情
let URL_ORDER_DETAIL = rootUrl + '/miniApp/order/getOrderDetail'
//订单列表(0待支付，1充电中，2充电完成，3已取消)
let URL_ORDER_LIST = rootUrl + '/miniApp/order/getOrderList'
//获取充电状态
let URL_GETLASTCHARGE_STATU = rootUrl + '/miniApp/order/getLastOrderState'
//获取设备价格
let URL_GETDEVICE_PRICE = rootUrl + '/miniApp/homePage/getDevicePriceInfo'
//获取个人信息
let URL_GETUSERINFO = rootUrl + '/miniApp/homePage/getUserInfo'
//绑定用户
let URL_BINDUSER = rootUrl + '/getUserInfoFromWeixin'
//登录
let URL_LOGIN = rootUrl + '/login/wxLogin'
//获取特别配置
let URL_SPECAIL_CFG = rootUrl + '/getSpecialCfg'

// 提交投诉内容
let URL_COMMIT_COMPLAIN = `${rootUrl}/miniApp/homePage/commitUserComplaint`

// 帮助页刷新密码
let URL_REFRESH_PWD = `${rootUrl}/miniApp/order/refreshPassword`;

// 检查是否可以刷新密码
let URL_CHECK_REFESH_AVAILABLE = `${rootUrl}/miniApp/order/getRefreshPasswordCondition`;

// 激活白名单
let URL_ACTIVE_WHITELIST = `${rootUrl}/miniApp/homePage/activeOrderWhiteList`;

//白名单支持的商户
let URL_WHITELIST_SCOPE = `${rootUrl}/miniApp/homePage/getOrderWhiteListDetail`;

//白名单方式产品订单
let URL_WHITELIST_ORDER = `${rootUrl}/miniApp/order/createOrderByWhilteList`;

//判断是否是自己的有效白名单
let URL_VALID_WHITELIST  = `${rootUrl}/miniApp/homePage/judgeWhetherMyValidOrderWhiteList`;

//显示广告
let URL_GET_AD = `${rootUrl}/miniApp/ad/showAd`;

//点击广告统计
let URL_AD_CLICK = `${rootUrl}/miniApp/ad/ADclicked`;

//显示广告统计
let URL_AD_SHOW = `${rootUrl}/miniApp/ad/ADshowed`;

module.exports = {
  KEY_TOKEN,
  KEY_TOKEN_TYPE,
  KEY_ERROR_SCAN,
  KEY_NEW_USER,
  rootUrl,
  scanUrl,
  URL_SN_INVALID,
  URL_PAY_WAITORDER,
  URL_CANCEL_ORDER,
  URL_CLOSE_ORDER,
  URL_GETDEVICE_PSW,
  URL_CREATE_ORDER,
  URL_ORDER_DETAIL,
  URL_ORDER_LIST,
  URL_GETLASTCHARGE_STATU,
  URL_GETDEVICE_PRICE,
  URL_GETUSERINFO,
  URL_BINDUSER,
  URL_LOGIN: URL_LOGIN,
  URL_COMMIT_COMPLAIN,
  URL_SPECAIL_CFG,
  URL_CHECK_REFESH_AVAILABLE,
  URL_ACTIVE_WHITELIST,
  URL_WHITELIST_SCOPE,
  URL_REFRESH_PWD,
  URL_WHITELIST_ORDER,
  URL_VALID_WHITELIST,
  URL_GET_AD,
  URL_AD_CLICK,
  URL_AD_SHOW
}