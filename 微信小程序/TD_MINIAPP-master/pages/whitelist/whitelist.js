var netutil = require("../../utils/netutil.js");
var util = require("../../utils/util.js");
var constant = require("../../utils/constant.js");

let whitelistResultPage = '../../../whitelistResult';

Page({
 
  data: {
    product: getApp().globalData.product,
    product_name: getApp().globalData.productName,
    img_invite: getApp().globalData.sk+"/bg_invite.png",
    img_about: getApp().globalData.sk+"/ic_about.png",
    orderWhiteListId:"",
    hiddenUI: true,
    tempToken: "",
  },

  onLoad: function (options) {
    wx.setNavigationBarColor({
      frontColor:this.data.product == 0 ? '#000000' : '#ffffff',
      backgroundColor: this.data.product == 0 ? '#FFF1C2' : '#352B2F',
    });
    wx.setNavigationBarTitle({
      title: this.data.product_name
    });
    var that = this;
    this.data.orderWhiteListId = options.data;
    //检测是否登录
    var timerId = setInterval(function () {
    wx.getStorage({
      key: constant.KEY_TOKEN,
      success: function (res) {
        if (util.isBlank(res.data)) {
          console.log("token不存在");
          that.getLoginCode();
        } else {
          console.log("token存在");
          if (res.data.indexOf("Bearer;") != -1) {
            console.log("这是gwt-token");
            getApp().globalData.authorization = res.data;
            // that.getUserStatu();
          } else {
            console.log("这是普通token");
            that.data.tempToken = res.data;
            that.setData({
              hiddenUI: false,
            });
          }
        }
      }, fail: function () {
        console.log("token不存在");
        that.getLoginCode();
      }
    });
    clearInterval(timerId);
  }, 1000);
    this.checkValidWhitelist();
  },

  /**
     * 获取登录code
     */
  getLoginCode: function () {
    var that = this;
    wx.login({
      success: res => {
        that.doLogin(res.code);
      }, fail: res => {
        util.showToast('微信code获取失败');
      }
    });
  },

  /**
   * 请求登录
   */
  doLogin: function (code) {
    var that = this;
    var params = { 'code': code };
    netutil.getRequest(constant.URL_LOGIN, params,
      function (success) {
        var result = success.data;
        console.log('tokenType = ' + result.tokenType)
        if (result.tokenType == 0) {
          wx.setStorage({
            key: constant.KEY_TOKEN,
            data: result.token,
          })
          netutil.setAuthrization(result.token)
          // that.getUserStatu();
        } else {
          that.data.tempToken = result.token;
          that.setData({
            hiddenUI: false,
          });
          wx.setNavigationBarColor({
            frontColor: '#000000',
            backgroundColor: '#ffffff',
          });
        }
      },
      function (fail) {
      });
  },

  /**
   * 授权绑定用户
   */
  onGotUserInfo: function (e) {
    var that = this;
    var encryptedData = e.detail.encryptedData;
    var iv = e.detail.iv;
    var rawData = e.detail.rawData;
    var signature = e.detail.signature;
    var jsonObj = {
      "encryptedData": encryptedData,
      "iv": iv,
      "rawData": rawData,
      "signature": signature
    };
    var header = {
      'content-type': 'application/json',
      'token': this.data.tempToken,
      "latitude": getApp().globalData.latitude,
      "longitude": getApp().globalData.longitude
    };
    netutil.postRequestWithHeader(constant.URL_BINDUSER, header, JSON.stringify(jsonObj), function (success) {
      netutil.setAuthrization(success.data.token)
      that.setData({
        hiddenUI: true,
      });
      wx.setNavigationBarColor({
        frontColor: '#000000',
        backgroundColor: '#FFF1C2',
      });
    }, function (fail) {
      wx.clearStorage();
      that.getLoginCode();
    });
  },

  onAcceptTap :function(){
    var that = this;
    if (util.isBlank(this.data.orderWhiteListId)){
      util.showToast('数据异常，请从微信分享打开');
      return;
    }
    var params = { 'orderWhiteListId': this.data.orderWhiteListId };
    netutil.getRequest(constant.URL_ACTIVE_WHITELIST, params, function (success) {
      getApp().reLunchPage(whitelistResultPage, 
      [{ 'key': 'orderWhiteListId', 'value': that.data.orderWhiteListId}]);
    }, function (fail) {})
  },

  checkValidWhitelist:function(){
    var that = this;
    var params = { 'orderWhiteListId': this.data.orderWhiteListId };
    netutil.getRequest(constant.URL_VALID_WHITELIST, params, function (success) {
      getApp().reLunchPage(whitelistResultPage, [{ 'key': 'orderWhiteListId', 'value': that.data.orderWhiteListId}]);
    }, function (fail) {})
  },

  onPageTap: function () {
    console.log('page touch')
  }

})