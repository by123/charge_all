// pages/charge/charge/whitelist/charge.js
var netutil = require("../../../../utils/netutil.js");
var util = require("../../../..//utils/util.js");
var constant = require("../../../../utils/constant.js");

let wtChargeCodePage = '../../chargecode/whitelist/chargecode';
let startPage = '../../../start/start';
Page({

  data: {
    product: getApp().globalData.product,
    img_vip_use:getApp().globalData.sk+"/bg_vip_use.png",
    chargeBtnHeight: 0,
    cancelBtnHeight: 0,
    deviceSn: "",
    time:0
  },

  onLoad: function (options) {
    var app = getApp();
    wx.setNavigationBarTitle({
      title: getApp().globalData.productName
    })
    this.data.deviceSn = options.deviceSn;
    this.data.time = options.duration/60;
    this.setData({
      chargeBtnHeight: app.globalData.windowH - app.globalData.windowW * 190 / 375,
      cancelBtnHeight: app.globalData.windowH - app.globalData.windowW * 120 / 375,
      time: options.duration/60
    })
  },

  //获取充电密码
  onGetPswTap: function () {
    var data = { "deviceSn": this.data.deviceSn };
    var that = this;
    netutil.postRequest(constant.URL_WHITELIST_ORDER, JSON.stringify(data), function (success) {
      var data = success.data;
      var param = [{ 'key':'sn','value':that.data.deviceSn}];
      getApp().openPageWithoutBack(wtChargeCodePage, param);
    }, function (fail) { });
  },

  //取消
  onCancelTap: function () {
    getApp().reLunchPage(startPage, null);
  },

  onShareAppMessage: function () {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }


})