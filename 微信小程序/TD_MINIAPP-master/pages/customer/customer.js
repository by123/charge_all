// pages/customer/customer.js
var netutil = require("../../utils/netutil.js");
var util = require("../../utils/util.js");
var constant = require("../../utils/constant.js");

let complainPage = '../customer/complain';
Page({

  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    img_call:getApp().globalData.sk+"/ic_call.png",
    img_question:getApp().globalData.sk+"/ic_question.png",
    img_arrow:getApp().globalData.sk+"/ic_down_arrow.png",
    list: [],
    orderId: "",
    showRefresh: false,
    password: null,
    snStr:''
  },

  //点击最外层列表展开收起
  listTap(e) {
    console.log('触发了最外层');
    let Index = e.currentTarget.dataset.parentindex,//获取点击的下标值
      list = this.data.list;
    list[Index].show = !list[Index].show || false;//变换其打开、关闭的状态
    if (list[Index].show) {//如果点击后是展开状态，则让其他已经展开的列表变为收起状态
      this.packUp(list, Index);
    }

    this.setData({
      list
    });
    
  },

  //让所有的展开项，都变为收起
  packUp(data, index) {
    for (let i = 0, len = data.length; i < len; i++) {//其他最外层列表变为关闭状态
      if (index != i) {
        data[i].show = false;
      }
    }
  },
  onLoad: function (options) {
    this.data.orderId = options.orderId;
    this.data.snStr = options.sn;
    console.log('平台客服->'+this.data.orderId)
    this.setData({
      orderId: options.orderId
    });
    this.requestQuestionList();
    if (!util.isBlank(this.data.orderId)) {
      this.checkRefreshAvailable();
    }

    //显示广告
    // var adview = this.selectComponent("#adview")
    // adview.showAdWithSn(this.data.snStr); 
  },

  /**
   * 获取常见问题
   */
  requestQuestionList: function () {
    var that = this;
    var params = { 'cfgKey0': 'asked_question' };
    netutil.getRequest(constant.URL_SPECAIL_CFG, params,
      function (success) {
        var result = success.data;
        let data = JSON.parse(result.cfgValue);
        that.setData({
          list: data
        })
      },
      function (fail) {
      });
  },

  // 检查是否可以刷新密码
  checkRefreshAvailable: function () {
    const that = this;
    const { orderId } = this.data;
    const params = { orderId };
    netutil.getRequest(constant.URL_CHECK_REFESH_AVAILABLE, params,
      function (success) {
        // deviceCanRefreshPassword 0 为可以刷新， 1 为不可以
        // everRefreshPassword 0 刷新过 1 没有刷新过
        const { deviceCanRefreshPassword, everRefreshPassword, password } = success.data || {};
        that.setData({
          showRefresh: deviceCanRefreshPassword === 0,
          password: everRefreshPassword === 0 && deviceCanRefreshPassword === 0 ? password.split('') : null,
        });
      },
      function (fail) {
      });
  },

  // 刷新密码
  refreshPwd: function () {
    const that = this;
    const { orderId } = this.data;
    const params = { orderId };
    netutil.getRequest(constant.URL_REFRESH_PWD, params,
      function (success) {
        const password = success.data;
        that.setData({
          password: password.split(''),
        })
      },
      function (fail) {
      });
  },

  onCallTap: function () {
    wx.makePhoneCall({
      phoneNumber: this.data.product == 0 ? '4006788278' : '4006788278',
    })
  },

  onQuestionTap: function () {
    getApp().openPage(complainPage,
      [{ 'key': 'orderId', 'value': this.data.orderId }]);
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }
})
