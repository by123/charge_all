// pages/charge/charge/taxi/charge.js

var netutil = require("../../../../utils/netutil.js");
var util = require("../../../../utils/util.js");
var constant = require("../../../../utils/constant.js");
var analysis = require("../../../../utils/analysis.js");
let chargeCodePage = '../../chargecode/origin/chargecode';

let adPage = '../../../ad/ad';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    img_taxi_charge:getApp().globalData.sk+"/img_taxi_charge.png",
    snStr:"",
    contentHeight: 0,
    bodyHeight: 0,
    imgUrl: "",
    point1: { height: 220, content:'确认设备已亮红灯'},
    point2: { height: 272, content:'支付后，点击“完成”获取密码' },
    point3: { height: 324, content:'输入密码即可充电'},
    totalPrice:0,
    item:null
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.data.item = options;
    var app = getApp();
    this.data.snStr = decodeURIComponent(options.deviceSn);
    this.setData({
      contentHeight: app.globalData.windowH,
      bodyHeight: app.globalData.windowH - app.globalData.windowW * 55 / 375,
      listHeight: app.globalData.windowH - app.globalData.windowW * 233 / 375,
      totalPrice: options.price/100,
      // point3: { height: 324, content: '输入密码即可充电' + options.time/60+'小时' },
    });
    // this.requestAd();
    //显示广告
    var adview = this.selectComponent("#adBannerView")
    adview.showAdWithSn(this.data.snStr); 
  },


  submit: function (e) {
    console.log("点击支付");
    var data = {
      "deviceSn": this.data.item.deviceSn,
      "latitude": getApp().globalData.latitude,
      "longitude": getApp().globalData.longitude,
      "location": "",
      "renewFlag": 0,
      "scale": this.data.item.scale,
      "formId": e.detail.formId,
      'model': getApp().globalData.model,
      'brand': getApp().globalData.brand,
      'system': getApp().globalData.system,
      'version': getApp().globalData.version,
      'platform': getApp().globalData.platform
    };
    console.log("formId = " + e.detail.formId);
    var that = this;
    netutil.postRequest(constant.URL_CREATE_ORDER, JSON.stringify(data), function (success) {
      var data = success.data;
      var status = success.status;
      if (status == netutil.STATU_REPEAT_ORDER) {
        getApp().reLunchPage(startPage, null);
      } else {
        var mark = { "statu": 1, "orderid": data.orderId };
        analysis.markData("create_order", mark);
        that.doWxPay(data, that.data.item);
      }
    }, function (fail) {
      var mark = { "statu": 0, "orderid": data.orderId };
      analysis.markData("create_order", mark);
    })
  },

  doWxPay: function (data, item) {
    this.data.actionPay = true;
    wx.requestPayment({
      timeStamp: data.timeStamp,
      nonceStr: data.nonceStr,
      package: data.package,
      signType: data.signType,
      paySign: data.paySign,
      success(res) {
        var mark = {
          "statu": 1,
          "orderid": data.orderId,
        }
        analysis.markData("pay", mark);
        util.destoryPlay();
        wx.setStorage({ key: "charge_statu", data: 1 });
        var time = item.time * 60;
        console.log("by测试->微信支付回调获取支付状态");
        getApp().reLunchPage(chargeCodePage, [{ 'key': 'time', 'value': time }, { 'key': 'orderId', 'value': data.orderId }]);
      },
      fail(res) {
        var mark = { "statu": 0, "orderid": data.orderId };
        analysis.markData("pay", mark);
      }
    });
  },


  onShareAppMessage: function () {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }
})