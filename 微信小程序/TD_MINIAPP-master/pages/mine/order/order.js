// pages/order/order.js
var netutil = require("../../../utils/netutil.js");
var util = require("../../../utils/util.js");
var constant = require("../../../utils/constant.js");


let orderDetailPage = '../orderdetail/orderdetail';
let chargeCompeltePage = '../../charge/chargecompelete/chargecompelete';
let chargeCodePage = '../../charge/chargecode/origin/chargecode';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    img_no_order: getApp().globalData.sk +"/img_no_order.png",
    contentHeight:0,
    currentTab: 0,
    datas:[],
    page:1,
    hasDatas:false,
    loadingHidden:true,
    loadingStr:"加载中",
  },
  onShow:function(){
    this.restoreData();
    this.requestDatas(this.data.currentTab);

  },

  onLoad: function (options) {
    var app = getApp();
    this.setData({
      contentHeight: app.globalData.windowH -88 *app.globalData.windowW /750
    });

    //显示广告
    var adview = this.selectComponent("#adview")
    adview.showAd(); 

  },//滑动切换
  swiperTab: function (e) {
    this.restoreData();
    var that = this;
    that.setData({
      currentTab: e.detail.current
    });
    this.requestDatas(e.detail.current);
  },
  //复位
  restoreData:function(e){
    this.data.page = 1;
    this.data.datas = [];
    this.setData({
      datas:[],
      hasDatas:false
    })
  },
  //点击切换
  clickTab: function (e) {
    var that = this;
    if (this.data.currentTab === e.target.dataset.current) {
      return false;
    } else {
      that.setData({
        currentTab: e.target.dataset.current
      })
    }
  },

  onItemClick: function (e) {
    var index = parseInt(e.currentTarget.dataset.index);
    var selectData = this.data.datas[index];
    getApp().openPage(orderDetailPage, [{'key':'data','value':encodeURIComponent(JSON.stringify(selectData))}]);
  },

  //点击待支付的立即支付
  onPayClick:function(e){
    var index = parseInt(e.currentTarget.dataset.index);
    var selectData = this.data.datas[index];
    console.log(selectData)
    var params = {
      'orderId': selectData.orderId,
    };
    var that = this;
    if(selectData.orderState == 0){
      //立即支付
      netutil.getRequest(constant.URL_PAY_WAITORDER, params, function (success) {
        var data = success.data;
        that.doWxPay(data, selectData);
      }, function (fail) {});
    }else if(selectData.orderState == 2){
      //提前结束退押金
      netutil.getRequest(constant.URL_CLOSE_ORDER, params, function (success) {
        getApp().reLunchPage(chargeCompeltePage, [{ 'key': 'orderId', 'value': selectData.orderId}]);
      }, function (fail) {});
    }
  },


 //支付
  doWxPay: function (data, selectData){
  wx.requestPayment({
    timeStamp: data.timeStamp,
    nonceStr: data.nonceStr,
    package: data.package,
    signType: data.signType,
    paySign: data.paySign,
    success(res) {
      var time = selectData.buyDuration * 60;
      getApp().reLunchPage(chargeCodePage, [{ 'key': 'time', 'value': time }, { 'key': 'orderId', 'value': selectData.orderId }, { 'key': 'sn', 'value': selectData.deviceSn}]);
    },
    fail(res) {

    }
  });
},
/**
 * 请求数据
 */
  requestDatas: function (orderType){
    var that = this;
    var page = this.data.page;
    var params;
    if(orderType == 0){
      params ={
        'pageNo': page
      }
    }else{
      params = {
      'pageNo': page,
      'orderType': orderType-1
      }
    }
    netutil.getRequest(constant.URL_ORDER_LIST,params,function(success){
        var results = success.data.rows;
        if(util.isBlank(results) ||  results.length == 0){
          that.setData({
            loadingStr:"已经到底啦",
          });
          return;
        }
        for(var index in results){
          results[index].createTime = util.formatTime(results[index].createTime);
          var startTime = results[index].startTime;
          var actualEndTime = results[index].actualEndTime;
          var durationTime = (actualEndTime - startTime)/1000;
          if (actualEndTime == null || startTime == null){
            console.log("start or end time is null");
            results[index].buyTime = util.generateAllTimeStr(results[index].buyDuration * 60);
          }else{
            results[index].buyTime = util.generateAllTimeStr(durationTime);
          }
          results[index].depositPrice = results[index].depositPrice/100;
          results[index].servicePrice = results[index].servicePrice / 100;
          results[index].refundMoney = results[index].refundMoney / 100;
          results[index].refundingMoney = results[index].refundingMoney / 100;
          results[index].totalPrice = results[index].servicePrice + results[index].depositPrice;
          results[index].statu = that.getStatuString(results[index].orderState);
          results[index].payStatu = that.getPayStatu(results[index].orderState);
          results[index].titleStatu = that.getTitleStatu(results[index].orderState);
          results[index].btnStr = that.getBtnStr(results[index].orderState);
        }
        if (that.data.page != 1) {
          results = that.data.datas.concat(results);
        }
        that.data.page++;
        that.setData({
          datas: results,
          hasDatas: util.isBlank(results) ? false : true,
          loadingHidden: true,
        })
    },function(fail){
      that.setData({
        loadingHidden: true
      })
    }); 
  },

  /**
   * 滑动到底请求
   */
  onReachBottom:function(){
      var that= this;
      that.setData({
        loadingHidden:false
      })
      this.requestDatas(this.data.currentTab);       
  },


//按钮文字
getBtnStr: function (orderState){
  var btnStr = "";
  switch (orderState) {
    case 0:
      btnStr = '立即支付';
      break;
    case 2:
      btnStr = '结束退押金';
      break;
  }
  return btnStr;
}
,
//
getTitleStatu:function(orderState){
  var statuStr;
  switch (orderState) {
    case 0:
      statuStr = '待支付：';
      break;
    case 1:
      statuStr = '未支付：';
      break;
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
      statuStr = '已支付：';
      break;
  }
  return statuStr;
},
//获取支付状态
  getPayStatu: function (orderState){
    var statuStr;
    switch (orderState) {
      case 0:
      case 1:
        statuStr = '未支付';
        break;
      case 2:
        statuStr = "待返还";
        break;
      case 3:
      case 4:
      case 5:
      case 6:
        statuStr = '已返还';
        break;
    }
    return statuStr;
  },

/**
 * 获取状态
 */
  getStatuString: function(orderState){
    var statuStr;
    switch(orderState){
      case 0:
        statuStr = '待支付';
        break;
      case 1:
        statuStr = '已取消';
        break;
      case 2:
        statuStr = '充电中';
        break;
      case 3:
        statuStr = '已完成';
        break;
      case 4:
      case 5:
        statuStr = '已退款';
        break;
      case 6:
        statuStr = '退款中';
        break;
    }
    return statuStr;
  },

  onShareAppMessage: function () {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }


  
})