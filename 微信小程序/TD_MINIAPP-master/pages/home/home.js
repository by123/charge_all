// pages/home/home.js
var netutil = require("../../utils/netutil.js");
var util = require("../../utils/util.js");
var constant = require("../../utils/constant.js");

let orderPage = '../mine/order/order';
let helpPage = '../mine/help/help';
let chargePage = '../charge/charge/origin/charge';
let chargePrePage = '../charge/charge/pre/charge';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    img_order: getApp().globalData.sk + "/icon_order.png",
    img_help: getApp().globalData.sk + "/icon_help.png",
    img_scan: getApp().globalData.sk + "/icon_scan.png",
    accountStr: "",
    chargeTimeStr: 0,
    chargeMinutesStr: "0小时0分",
    canRefresh: true,
    contentHeight: 0
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: getApp().globalData.productName
    });
    this.setData({
      contentHeight: getApp().globalData.windowH
    });
    //显示广告
    // var adview = this.selectComponent("#adview")
    // adview.showAd();
  },

  refreshHomeData: function () {
    var that = this;
    netutil.getRequest(constant.URL_GETUSERINFO, null, function (success) {
      var result = success.data;
      var chargeMinutes;
      var minutes = parseInt(result.chargeMinutes);
      console.log("累计时长->" + minutes);
      chargeMinutes = util.generateHmStr(minutes)
      that.setData({
        accountStr: result.userId,
        chargeTimeStr: result.chargeTimes,
        chargeMinutesStr: chargeMinutes,
      });
      getApp().globalData.userId = result.userId;
      if (result.chargeTimes == 0) {
        wx.setStorage({
          key: constant.KEY_NEW_USER,
          data: 1,
        })
      }
    }, function (fail) { })
  },


  onShow: function (options) {
    if (this.data.canRefresh) {
      this.refreshHomeData();
    }
  },

  onHide: function () {
    console.log("隐藏home")
    this.data.canRefresh = true;
  },
  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
    return util.shareContent();
  },

  /**
   * 跳转到订单
   */
  onOrderTap: function () {
    getApp().openPage(orderPage, null);
  },

  /**
   * 跳转到帮助
   */
  onHelpTap: function () {
    getApp().openPage(helpPage, null);
  },
  /**
   * 扫码
   */
  onScanTap: function () {
    if(getApp().globalData.synWx == 1){
      this.startScan();
    }else{
      var that = this;
      wx.getUserProfile({
        desc: '用于完善会员资料',
        success: (res) => {
           netutil.bindUser(res);
           that.startScan();
        },
        fail : (res) => {
          that.startScan();
        }
      })
    }
  },

  startScan: function(){
    var that = this;
    wx.scanCode({
      success: (res) => {
        if (res.result.indexOf(constant.scanUrl) == -1) {
          util.showToast('二维码无法识别');
          that.data.canRefresh = false;
          return;
        }
        console.log("二维码：" + res.result);
        var snStr = res.result.slice(constant.scanUrl.length);
        var params = {
          'deviceSN': snStr,
        };
        //检测sn是否可用
        netutil.getRequest(constant.URL_SN_INVALID, params, function (success) {
          if (success.data.serviceType == 1) {
            getApp().openPage(chargePage,
              [
                { 'key': 'scanUrl', 'value': encodeURIComponent(res.result) },
                { 'key': 'serviceType', 'value': success.data }
              ]);
          } else {
            getApp().openPage(chargePrePage,
              [
                { 'key': 'scanUrl', 'value': encodeURIComponent(res.result) },
                { 'key': 'serviceType', 'value': success.data }
              ]);
          }

        }, function (fail) {
          var result = fail.data;
          if (result.deviceType == 1) {
            //出租车设备未激活，跳转到司机激活页面
            util.showToast("设备未激活，请使用微信扫一扫功能扫描二维码");
          } else {
            that.data.canRefresh = false;
          }
        });
      }
    })
  }

  ,
  onSuccess: function (e) {
    console.log('点击成功')
    console.log(e.detail.code)
    console.log(e.detail.userInfo)
  },
  onFail: function (e) {
    console.log('点击失败')
    console.log(e)

  },

  onPageTap: function () {
    console.log('page touch')
  }
})