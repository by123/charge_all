// pages/addDetail/addDetail.js
var netutil = require("../../utils/netutil.js");
var util = require("../../utils/util.js");
var constant = require("../../utils/constant.js");

let homePage = '../home/home';
let chargePage = '../charge/charge/origin/charge';
var chargecodePage = '../charge/chargecode/origin/chargecode';
var chargecodeWTPage = '../charge/chargecode/whitelist/chargecode';


Page({

  data: {
    datas: [],
    from: '',
    snStr: '',
    name: ''
  },

  onLoad: function(options) {
    var content = decodeURIComponent(options.content);
    this.data.from = options.from;
    this.data.snStr = options.sn;
    getApp().globalData.snStr = options.sn;
    this.setData({
      datas: JSON.parse(content)
    })
    wx.setNavigationBarTitle({
      title: options.name,
    })
  },

  imageLoad: function(e) {
    console.log(e)
    var position = e.target.id;
    var height = util.resizeImageHeight(345, e.detail);
    this.data.datas[position].height = height;
    this.setData({
      datas: this.data.datas
    })
  },

  onUnload: function() {
    var snStr = getApp().globalData.snStr;
    var param = [{
      'key': 'scanUrl',
      'value': encodeURIComponent(constant.scanUrl + snStr)
    }];
    if (this.data.from == 'start') {
      var orderData = getApp().globalData.lastOrderData;
      if (orderData.chargingFlag == 0) {
        if (util.isBlank(snStr)) {
          console.log("***未充电，直接打开***");
          getApp().reLunchPage(homePage, null)
        } else {
          getApp().reLunchPage(chargePage, param);
          console.log("***未充电，扫描二维码***");
        }
      } else if (orderData.chargingFlag == 1) {
        //0白名单，1非白名单
        if (orderData.whiteListFlag == 0) {
          util.printData('***已充电，白名单用户打开***')
          var param = [{ 'key': 'sn', 'value': orderData.deviceSn}];
          getApp().openPageWithoutBack(chargecodeWTPage, param);
          return;
        }
        //已经有设备正在充电
        var ramainTime = parseInt(orderData.remainTime / 1000);
        if (snStr == orderData.deviceSn || util.isBlank(snStr)) {
          util.printData('***设备相同或者非扫设备二维码进入***')
          //设备相同或者非扫设备二维码进入，跳转到充电密码页面
          getApp().openPageWithoutBack(chargecodePage, [{
              'key': 'time',
              'value': ramainTime
            },
            {
              'key': 'orderId',
              'value': orderData.orderId
            },
            {
              'key': 'sameDevice',
              'value': 1
            },
            {
              'key': 'password',
              'value': orderData.password
            },
            {
              'key': 'sn',
              'value': orderData.deviceSn
            }
          ]);
        } else {
          util.printData('***设备不同，跳转到充电密码页面***')
          //设备不同，跳转到充电密码页面
          getApp().openPageWithoutBack(chargecodePage, [{
              'key': 'time',
              'value': ramainTime
            },
            {
              'key': 'orderId',
              'value': orderData.orderId
            },
            {
              'key': 'sameDevice',
              'value': 0
            },
            {
              'key': 'sn',
              'value': snStr
            }
          ]);
        }
      }

    }
  },
  onShareAppMessage: function() {

  }
})