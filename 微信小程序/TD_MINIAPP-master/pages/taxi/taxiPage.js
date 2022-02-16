// pages/taxi/taxiPage.js
var util = require("../../utils/util.js");

Page({

  /**
   * 页面的初始数据
   */
  data: {
    step1: {
      title: '第一步', content: '点击卡片关注“' + getApp().globalData.productName+'出租车版”微信公众号', height:20 },
    step2: {
      title: '第二步', content: '注册司机账号', height: 40 
    },
    step3: {
      title: '第三步', content: '扫码绑定充电线', height: 40 
    },
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
     var deviceSn = options.deviceSn;
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {

  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
   wx.setNavigationBarTitle({
     title: getApp().globalData.productName + '新司机操作说明',
   })
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {

  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {

  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {

  },
  onShareAppMessage: function () {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }
})