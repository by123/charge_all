//util.js
var constant = require("constant.js");
var util = require("util.js");
const { URL_GETLASTCHARGE_STATU } = require("./constant");

var STATU_SUCCEE = '0'
var STATU_NOUSER = '24'
var STATU_TOKENINVALID = '90'
var STATU_REPEAT_ORDER = '10000019'

//get请求
var getRequest = function(url, param, success, fail) {
  //刷新主页或重复查询密码不显示loading
  if (url != constant.URL_GETUSERINFO && url != constant.URL_GETDEVICE_PSW) {
    showLoading();
  }
  console.log("<get:>" + url);
  var that = this;
  wx.request({
    url: url,
    method: 'GET',
    header: {
      'content-type': 'application/json',
      'authorization': getAuthrization(),
      'latitude': getApp().globalData.latitude,
      'longitude': getApp().globalData.longitude,
    },
    data: param,
    success: function(res) {
      console.log("<success:>" + JSON.stringify(res));
      wx.hideLoading();
      if (res.data.status == STATU_SUCCEE) {
        typeof success == "function" && success(res.data)
      } else if (res.data.status == STATU_NOUSER) {
        typeof success == "function" && success(res.data)
      } else if (res.data.status == STATU_TOKENINVALID && url == URL_GETLASTCHARGE_STATU) {
        handleTokenInvalid(function(handleSucess) {
          getRequest(url, param, success, fail);
        });
      } else {
        //白名单不显示提示
        if (url == constant.URL_VALID_WHITELIST) {
          return;
        }
        //广告接口不显示错误提示
        if (url == constant.URL_GET_AD ||
          url == constant.URL_AD_CLICK ||
          url == constant.URL_AD_SHOW) {
          return;
        }
        //获取价格错误直接返回对象处理
        if (url == constant.URL_GETDEVICE_PRICE || url == constant.URL_SN_INVALID) {
          typeof fail == "function" && fail(res.data)
        } else {
          typeof fail == "function" && fail(res.data.msg)
        }
      }
    },
    fail: function(res) {
      console.log("<fail:>" + res);
      wx.hideLoading();
      //重复查询密码不显示错误
      if (url != constant.URL_GETDEVICE_PSW) {
        showErrorMsg(res.errMsg);
      }
      typeof fail == "function" && fail(res.errMsg)
    }
  })
}

//post请求
var postRequest = function(url, param, success, fail) {
  var header = {
    'content-type': 'application/json',
    'authorization': getAuthrization(),
    'latitude': getApp().globalData.latitude,
    'longitude': getApp().globalData.longitude,
  };
  postRequestWithHeader(url, header, param, success, fail);
}

//post请求带header
var postRequestWithHeader = function(url, header, param, success, fail) {
  console.log("<post:>" + url);
  showLoading();
  wx.request({
    url: url,
    header: header,
    method: 'POST',
    data: param,
    success: function(res) {
      console.log("<success:>" + JSON.stringify(res));
      wx.hideLoading();
      if (res.data.status == STATU_SUCCEE || res.data.status == STATU_REPEAT_ORDER) {
        typeof success == "function" && success(res.data)
      } else if (res.data.status == STATU_TOKENINVALID) {
        handleTokenInvalid(function(handleSucess) {
          postRequestWithHeader(url, header, param, success, fail);
        });
      } else {
        showErrorMsg(res.data.msg);
        typeof fail == "function" && fail(res.data.msg)
      }
    },
    fail: function(res) {
      console.log("<fail:>" + res);
      wx.hideLoading();
      showErrorMsg(res.errMsg);
      typeof fail == "function" && fail(res.errMsg)
    }
  })
}


//设置token
var setAuthrization = function(authorization) {
  getApp().globalData.authorization = authorization;
}

//获取token
var getAuthrization = function() {
  return getApp().globalData.authorization;
}

//显示加载中
var showLoading = function() {
  wx.showLoading({
    content: '加载中...',
  });
}

//显示错误信息
var showErrorMsg = function(errMsg) {
  if (!util.isBlank(errMsg)) {
    wx.showToast({
      title: errMsg,
      icon: 'none',
      duration: 2000
    })
  } else {
    wx.showToast({
      title: "无法连接网络，请检查网络设置",
      icon: 'none',
      duration: 2000
    });
  }
}

//token过期
var handleTokenInvalid = function(handleSuccess) {
  wx.login({
    success: res => {
      doLogin(res.code, handleSuccess);
    },
    fail: res => {
      showErrorMsg("微信code获取失败");
    }
  });
}

var doLogin = function(code, handleSuccess) {
  var params = {
    'code': code
  };
  getRequest(constant.URL_LOGIN, params,
    function(success) {
      var result = success.data;
      getApp().globalData.synWx = result.synWx;
      console.log('tokenType = ' + result.tokenType)
      if (result.tokenType == 0) {
        wx.setStorage({
          key: constant.KEY_TOKEN,
          data: result.token,
        })
      }
      setAuthrization(result.token)
      typeof handleSuccess == "function" && handleSuccess()

    },
    function(fail) {});
}



/**
 * 上传用户信息
 */
var bindUser =  function(res){
  var encryptedData = res.encryptedData;
  var iv = res.iv;
  var rawData = res.rawData;
  var signature = res.signature;
  var jsonObj = {
    "encryptedData": encryptedData,
    "iv": iv,
    "rawData": rawData,
    "signature": signature
  };
  var header = {
    'content-type': 'application/json',
    'token': getApp().globalData.authorization,
    "latitude": getApp().globalData.latitude,
    "longitude": getApp().globalData.longitude
  };
  postRequestWithHeader(constant.URL_BINDUSER, header, JSON.stringify(jsonObj), function (success) {}, function (fail) {});
}

// var listenNetwork = function(){
//   //获取网络状态
//   wx.getNetworkType({
//     success(res) {
//       getApp().globalData.networkType = res.networkType;
//       console.log("当前网络:"+res.networkType);
//     }
//   });
//监听网络改变
// wx.onNetworkStatusChange(function (res) {
//   getApp().globalData.networkType = res.networkType;
//   console.log("网络变化:" + res.networkType);
// });
// }

module.exports = {
  getRequest,
  postRequest,
  postRequestWithHeader,
  handleTokenInvalid,
  doLogin,
  getAuthrization,
  setAuthrization,
  showLoading,
  showErrorMsg,
  bindUser,
  // listenNetwork,
  STATU_SUCCEE,
  STATU_NOUSER,
  STATU_TOKENINVALID,
  STATU_REPEAT_ORDER
}