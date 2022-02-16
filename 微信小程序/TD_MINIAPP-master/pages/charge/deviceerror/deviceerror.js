// pages/charge/deviceerror/deviceerror.js
var util = require("../../../utils/util.js");

let homePage = '../../home/home';

Page({

  data: {
    product: getApp().globalData.product,
    img_no_active:getApp().globalData.sk+"/img_device_not_active.png",
    errorStr: ""
  },

  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: getApp().globalData.productName
    })
    this.setData({
      errorStr: decodeURIComponent(options.msg)
    })
  },
  onBackHome: function(){
    getApp().openPageWithoutBack(homePage,null);
  },
 
  onShareAppMessage: function () {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }
})