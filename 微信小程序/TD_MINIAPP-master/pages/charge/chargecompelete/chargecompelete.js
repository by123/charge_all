var netutil = require("../../../utils/netutil.js");
var util = require("../../../utils/util.js");
var constant = require("../../../utils/constant.js");

let homePage = '../../home/home';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    img_compelete:getApp().globalData.sk+"/bg_compelete.png",
    items: [],
    depositPriceStr:0
  
  },

  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: getApp().globalData.productName
    })
    var that = this;
    var orderId = options.orderId;
    
    var params = {
      'orderId': orderId
    };
    netutil.getRequest(constant.URL_ORDER_DETAIL,params,function(success){
      var data = success.data.tblOrder;
      var rule = data.orderName;
      var depositPrice = data.depositPrice;
      var servicePrice = data.servicePrice;
      var startTime = data.startTime;
      var endTime = data.actualEndTime;
      var chargeTime = util.generateAllTimeStr(parseInt((endTime - startTime)/1000))
      var serviceType = data.serviceType;
      var refundMoney = data.refundMoney;
      var refundingMoney = data.refundingMoney;
      that.setData({
        items: [
          { title: "计费规则", content: rule },
          { title: "充电时间", content: chargeTime },
          { title: '消费金额', content: serviceType == 1 ? servicePrice/100  : (servicePrice - refundMoney - refundingMoney)/100}
        ],
        depositPriceStr: serviceType == 1 ? depositPrice/100 + "元押金已按原路返还" : (refundMoney + refundingMoney)/100 + "元预付款将于24小时内按原路返回"
      })
    },function(fail){});
  
  }, 

  onShareAppMessage: function () {
    return util.shareContent();
  },

 
  onBackHomeTap:function(){
    getApp().reLunchPage(homePage,null);
  },

  onPageTap: function () {
    console.log('page touch')
  }
})