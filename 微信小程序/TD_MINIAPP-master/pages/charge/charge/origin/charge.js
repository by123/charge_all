// pages/charge/charge/origin/charge.js
var netutil = require("../../../../utils/netutil.js");
var util = require("../../../../utils/util.js");
var constant = require("../../../../utils/constant.js");
var analysis = require("../../../../utils/analysis.js");


let adPage = '../../../ad/ad';
let whitelistPage = '../whitelist/charge';
let deviceErrorPage = '../../deviceerror/deviceerror';
let orderPage = '../../../mine/order/order';
let startPage = '../../../start/start';
let chargeCodePage = '../../chargecode/origin/chargecode';
let chargeHelpPage = '../../chargeHelp/chargeHelp';
let taxiPage = '../../../taxi/taxiPage'
let taxiChargePage = '../taxi/charge'
let taxiChargeCodePage = '../../chargecode/taxi/chargecode';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    img_select: getApp().globalData.sk + "/icon_select.png",
    img_check: getApp().globalData.sk + "/icon_rightarrow_light.png",
    img_charge_time: getApp().globalData.sk + "/icon_rightarrow.png",
    img_time: getApp().globalData.sk + "/icon_time.png",
    items: [],
    contentHeight: 0,
    bodyHeight: 0,
    totalPrice: 0,
    selectIndex: -1,
    scanUrl: "",
    pledgeStr: 0,
    hiddeenPledge: true,
    hiddeenPledgeTitle: false,
    actionPay: false,
    formId: "",
    openUrl: ""
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {

    var app = getApp();
    var that = this;
    this.data.scanUrl = decodeURIComponent(options.scanUrl);
    this.setData({
      contentHeight: app.globalData.windowH,
      bodyHeight: app.globalData.windowH - app.globalData.windowW * 55 / 375,
    });
    console.log("解析二维码：" + this.data.scanUrl)
    var snStr = this.data.scanUrl.slice(constant.scanUrl.length);
    console.log("截取的sn号：" + snStr)
    this.getPriceList(snStr);

    //显示广告
    var adview = this.selectComponent("#adBannerView")
    adview.showAdWithSn(snStr); 
  },

  //获取价格列表
  getPriceList: function(snStr) {
    var that = this;
    var params = {
      "deviceSN": snStr
    };
    netutil.getRequest(constant.URL_GETDEVICE_PRICE, params, function(success) {
      var result = success.data;
      var params = [{'key': 'deviceSn','value': snStr},
        { 'key': 'duration', 'value': result.duration}];
      //白名单
      var isOnOrderWhiteList = result.isOnOrderWhiteList;
      if (isOnOrderWhiteList) {
        getApp().reLunchPage(whitelistPage, params);
      }
      //出租车设备已激活
      else if (result.deviceType == 1) {
        if (result.isDriver) {
          //司机扫码
          var psw = result.driverPwd;
          var params = [{
            'key': 'psw',
            'value': psw
          }];
          getApp().openPageWithoutBack(taxiChargeCodePage, params)
        } else {
          //乘客扫码
          var service = JSON.parse(result.service);
          if (util.isBlank(service)) {
            util.showToast('未获取到价格');
          } else {
            util.audioPlay({
              authorization: getApp().globalData.authorization,
              audioUrl: '/audio/audio1.mp3'
            });
            var item = service[0];
            var params = [{
                'key': 'price',
                'value': item.price
              },
              {
                'key': 'scale',
                'value': item.scale
              },
              {
                'key': 'deviceSn',
                'value': snStr
              },
              {
                'key': 'time',
                'value': item.time
              }
            ];
            getApp().openPageWithoutBack(taxiChargePage, params)
          }
        }
      } else {
        //正常流程
        that.parseData(result);
        that.selectDefaultPrice();
        util.audioPlay({
          authorization: getApp().globalData.authorization,
          audioUrl: '/audio/audio1.mp3'
        });
      }
    }, function(fail) {
      var result = fail.data;
      //设备未激活
      if (result == null) {
        getApp().openPageWithoutBack(deviceErrorPage, [{
          'key': 'msg',
          'value': encodeURIComponent(fail.msg)
        }]);
        return;
      }
      if (result.deviceType == 1) {
        //出租车设备未激活流程
        getApp().reLunchPage(taxiPage, params);
      } else {
        //普通设备未激活流程
        getApp().openPageWithoutBack(deviceErrorPage, [{
          'key': 'msg',
          'value': encodeURIComponent(fail.msg)
        }]);
      }
    });
  },

  //数据解析
  parseData: function(result) {
    var app = getApp();
    //押金
    var pledge = result.pledge / 100;
    //设备版本
    var deviceVersion = result.deviceVersion;
    wx.setStorage({
      key: "deviceVersion",
      data: deviceVersion
    });
    //档位
    var temps = JSON.parse(result.service);
    for (var index in temps) {
      temps[index].checked = false;
      temps[index].timeStr = util.generateHmStr(temps[index].time);
    };
    this.setData({
      hiddeenPledgeTitle: (pledge > 0) ? false : true,
      pledgeStr: pledge,
      items: temps,
      bodyHeight: (pledge > 0) ? (app.globalData.windowH - app.globalData.windowW * 76 / 375) : (app.globalData.windowH - app.globalData.windowW * 55 / 375),
    });
  },

  //选中默认价格
  selectDefaultPrice: function() {
    var items = this.data.items;
    var selectData = items[0];
    items[0].checked = true;
    var selectAbs = Math.abs(selectData.price - 250);
    for (var index in items) {
      var item = items[index];
      if (selectAbs >= Math.abs(item.price - 250)) {
        selectAbs = Math.abs(item.price - 250);
        selectData = item;
        item.checked = true;
        items[0].checked = false;
      }
    }
    this.onSelectItem(selectData);
  },

  onHistoryTap: function() {
    getApp().openPage(orderPage, null);
  },

  onItemTap: function(e) {
    this.onSelectItem(e.currentTarget.dataset.name);
  },

  onSelectItem: function(item) {
    if (this.data.pledgeStr > 0) {
      this.setData({
        hiddeenPledge: false
      })
    }
    console.log(item)
    for (var index in this.data.items) {
      this.data.items[index].checked = false;
      if (this.data.items[index].scale == item.scale) {
        this.data.selectIndex = index;
      }
    }
    this.data.items[this.data.selectIndex].checked = true;
    this.setData({
      items: this.data.items,
      totalPrice: item.price / 100 + this.data.pledgeStr,
      selectIndex: this.data.selectIndex
    });
  },
  submit: function(e) {
    console.log("点击支付");
    if(getApp().globalData.synWx == 1){
      this.startPay(e);
    }else{
    var that = this;
    wx.getUserProfile({
      desc: '用于完善会员资料',
      success: (res) => {
         netutil.bindUser(res);
         that.startPay(e);
      },
      fail : (res) => {
        that.startPay(e);
      }
    })}
  },
  
  startPay: function(e) {
    if (this.data.selectIndex == -1) return;

    var item = this.data.items[this.data.selectIndex];
    var snStr = this.data.scanUrl.slice(constant.scanUrl.length);
    var data = {
      "deviceSn": snStr,
      "latitude": getApp().globalData.latitude,
      "longitude": getApp().globalData.longitude,
      "location": "",
      "renewFlag": 0,
      "scale": item.scale,
      "formId": e.detail.formId,
      'model': getApp().globalData.model,
      'brand': getApp().globalData.brand,
      'system': getApp().globalData.system,
      'version': getApp().globalData.version,
      'platform': getApp().globalData.platform
    };
    console.log('创建订单=>' + JSON.stringify(data));
    console.log("formId = " + e.detail.formId);
    var that = this;
    netutil.postRequest(constant.URL_CREATE_ORDER, JSON.stringify(data), function(success) {
      var data = success.data;
      var status = success.status;
      if (status == netutil.STATU_REPEAT_ORDER) {
        getApp().reLunchPage(startPage, null);
      } else {
        var mark = {
          "statu": 1,
          "orderid": data.orderId
        };
        analysis.markData("create_order", mark);
        that.doWxPay(data, item);
      }
    }, function(fail) {
      var mark = {
        "statu": 0,
        "orderid": data.orderId
      };
      analysis.markData("create_order", mark);
    })
  },

  doWxPay: function(data, item) {
    this.data.actionPay = true;
    var that = this;
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
        wx.setStorage({
          key: "charge_statu",
          data: 1
        });
        var time = item.time * 60;
        var snStr = that.data.scanUrl.slice(constant.scanUrl.length);
        console.log("by测试->微信支付回调获取支付状态" + snStr);
        getApp().reLunchPage(chargeCodePage, [{
          'key': 'time',
          'value': time
        }, {
          'key': 'orderId',
          'value': data.orderId
        }, {
          'key': 'sn',
          'value': snStr
        }]);
      },
      fail(res) {
        var mark = {
          "statu": 0,
          "orderid": data.orderId
        };
        analysis.markData("pay", mark);
      }
    });
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function() {
    //解决支付完成后，可能处于后台状态跳转失败的bug
    var that = this;
    if (this.data.actionPay) {
      console.log("by测试->重新回到页面获取支付状态");
      netutil.getRequest(constant.URL_GETLASTCHARGE_STATU, null, function(success) {
        var data = success.data;
        if (data.chargingFlag == 1) {
          var time = parseInt(data.remainTime / 1000);
          var orderId = data.orderId;
          console.log(time);
          console.log(orderId);
          var snStr = that.data.scanUrl.slice(constant.scanUrl.length);
          getApp().reLunchPage(chargeCodePage, [{
            'key': 'time',
            'value': time
          }, {
            'key': 'orderId',
            'value': orderId
          }, {
            'key': 'sn',
            'value': snStr
          }]);
        }
      }, function(fail) {});
    }
  },

  /**
   * 点击广告
   */
  onAdTap: function() {
    var openUrl = encodeURIComponent(this.data.openUrl);
    getApp().openPage(adPage, [{
      'key': 'url',
      'value': openUrl
    }]);
  },

  onHelpTap: function() {
    getApp().openPage(chargeHelpPage, null);
  },

  onShareAppMessage: function() {
    return util.shareContent();
  },

  onPageTap: function () {
    console.log('page touch')
  }

})