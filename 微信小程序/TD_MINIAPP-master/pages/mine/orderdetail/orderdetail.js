// pages/mine/orderdetail/orderdetail.js
var util = require("../../../utils/util.js");
var netutil = require("../../../utils/netutil.js");
var constant = require("../../../utils/constant.js");

let chargeCompeletePage = '../../charge/chargecompelete/chargecompelete';
let chargeCodePage = '../../charge/chargecode/origin/chargecode';

Page({
  data: {
    product: getApp().globalData.product,
    item:{},
    orderDatas:[],
    productDatas :[],
    merchantDatas:[],
    tradeDatas: [],
    tblOrder:null,
    from : 0
  },

  onLoad: function (options) {
    var that = this;
    var jsonStr = options.data;
    var from = options.from;
    console.log("这是啥"+from);
    var itemObj = JSON.parse(decodeURIComponent(jsonStr));

    var params = {
      'orderId': itemObj.orderId,
    };
    this.setData({
      from: from
    })
    console.log("订单id:"+itemObj.orderId);
    netutil.getRequest(constant.URL_ORDER_DETAIL,params, function (success) {
      var tlbMch = success.data.tblMch;
      var tblOrder = success.data.tblOrder;
      that.data.tblOrder = tblOrder;

      var buyTime;
      if (itemObj.fromCharge == 1){
        buyTime = util.generateAllTimeStr((Date.parse(new Date()) - tblOrder.startTime) / 1000);
      }else{
        if (tblOrder.actualEndTime == null || tblOrder.startTime == null) {
          console.log("start or end time is null");
          buyTime = util.generateAllTimeStr(tblOrder.buyDuration * 60);
        } else {
          buyTime = util.generateAllTimeStr((tblOrder.actualEndTime - tblOrder.startTime) / 1000);
        }
      }
  

      var showTxt =  (that.data.from == 1) ? '待结算' : (tblOrder.servicePrice - tblOrder.refundMoney - tblOrder.refundingMoney)/100 + '元';
      that.setData({
        item: itemObj,
        orderDatas: [
          { title: "订单状态", content: that.getOrderStatuString(tblOrder.orderState)},
          { title: "下单时间", content: util.formatTime(tblOrder.createTime) }
        ],
        productDatas: [
          { title: "设备编号", content: tblOrder.deviceSn }
        ],
        merchantDatas: [
          { title: "商户名称", content: tblOrder.mchName },
          { title: "商户地址", content: tlbMch.province + tlbMch.city + tlbMch.area}
        ]
        , tradeDatas: [
          { title: tblOrder.serviceType == 1 ? "押金" : "预付款", content: tblOrder.serviceType == 1 ? tblOrder.depositPrice/100 + '元' : tblOrder.servicePrice/100 + '元' },
          { title: "状态", content: that.getStatuString(tblOrder.orderState) },
          { title: "计费模式", content: tblOrder.orderName },
          { title: "充电时长", content: buyTime},
          { title: "充电金额", content: tblOrder.serviceType == 1 ?  tblOrder.servicePrice/100 + '元' : showTxt },
          { title: tblOrder.serviceType == 1 ? "支付金额" : "返还金额", content: tblOrder.serviceType == 1 ? (tblOrder.servicePrice + tblOrder.depositPrice)/100  +'元' : (tblOrder.refundMoney / 100) + '元'},
        ],
      });

      //显示广告
      var adview = that.selectComponent("#adview")
      adview.showAdWithSn(tblOrder.deviceSn); 
    
      }, function (fail) {});

  },

  //点击继续支付
  onConfirmTap:function(){
    var that = this;
    var params = {
      'orderId': this.data.item.orderId,
    };
    var that = this;
    netutil.getRequest(constant.URL_PAY_WAITORDER, params, function (success) {
      var data = success.data;
      that.doWxPay(data);
    }, function (fail) {

    });
  },
  //点击结束订单
  onCloseTap:function(){
      var that = this;
      var params = {
        'orderId': this.data.item.orderId,
      };
      netutil.getRequest(constant.URL_CLOSE_ORDER, params, function (success) {
        var status = success.status;
        wx.setStorage({
          key: "charge_statu",
          data: 0
        });
        getApp().reLunchPage(chargeCompeletePage, [{ 'key': 'orderId', 'value': that.data.item.orderId}]);
      }, function (fail) { });
    
  },
  //支付
  doWxPay:function(data){
    var that = this;
    wx.requestPayment({
      timeStamp: data.timeStamp,
      nonceStr: data.nonceStr,
      package: data.package,
      signType: data.signType,
      paySign: data.paySign,
      success(res) {
      var time = that.data.item.buyDuration * 60;
        getApp().reLunchPage(chargeCodePage, [{ 'key': 'time', 'value': time }, { 'key': 'orderId', 'value': that.data.item.orderId }, { 'key': 'sn', 'value': that.data.tblOrder.deviceSn }]);
      },
      fail(res) {

      }
    });
  },
  //点击取消
  onCancelTap:function(){
    var params = {
      'orderId': this.data.item.orderId,
    };
    netutil.getRequest(constant.URL_CANCEL_ORDER,params,function (success){
        wx.navigateBack({})
    },function(fail){
      
    });
  },

  /**
   * 获取订单状态
   */
  getOrderStatuString: function (orderState) {
    var statuStr;
    switch (orderState) {
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
  /**
 * 获取押金状态
 */
  getStatuString: function (orderState) {
    var statuStr;
    switch (orderState) {
      case 0:
        statuStr = '待支付';
        break;
      case 1:
        statuStr = '未支付';
        break;
      case 2:
        statuStr = '待返还';
        break;
      case 3:
        statuStr = '已返还';
        break;
      case 4:
      case 5:
      case 6:
        statuStr = '已返还';
        break;
    }
    return statuStr;
  }


,onShareAppMessage: function () {
  return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }

 
})