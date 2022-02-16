// pages/mine/help/help.js
var util = require("../../../utils/util.js");

Page({

  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    items: [
      { title: "第一步", content: "微信扫描设备二维码"},
      { title: "第二步", content: "选择计费规则，获取设备解锁密码"  },
      {title: "第三步", content: "开始充电，计费时间截止则自动结束充电或用户手动结束充电，则系统自动返还押金" },
    ],
    contentHeight: 0
  },


  onLoad: function (options) {
    var app = getApp();
    this.setData({
      contentHeight: app.globalData.windowH
    })
  },

  onCallTap:function(){
    wx.makePhoneCall({
      phoneNumber: this.data.product == 0 ? '4006788278' : '4006788278',
    })
  },
  onShareAppMessage: function () {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }
  


 
})