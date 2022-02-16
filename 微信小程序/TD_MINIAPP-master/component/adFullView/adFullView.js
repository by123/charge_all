// component/adFullView/adFullView.js
var netutil = require("../../utils/netutil.js");
var constant = require("../../utils/constant.js");
var util = require("../../utils/util.js");
let adDetailPage = '../../pages/addDetail/addDetail';

Component({
  /**
   * 组件的属性列表
   */
  properties: {
    snStr: {
      type: String,
      value: '',
    },
    showPage: {
      type: Number,
      value: ''
    },
    clickAd: {
      type: Boolean,
      value: false
    }
  },

  /**
   * 组件的初始数据
   */
  data: {
    hiddenAd: true,
    adData: null,
    height:0,
    top:0
  },

  /**
   * 组件的方法列表
   */
  methods: {

    showAdWithSn: function (snStr) {
      this.properties.snStr = snStr;
      this.requestGetAdList();
    },
    //获取广告
    requestGetAdList: function () {
      var that = this;
      var params = {
        'sn': this.properties.snStr,
        'showpage': this.properties.showPage,
        //全部:0 男:1 女:2
        'gender': getApp().globalData.gender,
        //微信:0 1支付宝:1
        'showChannel': 0
      };
      if (util.isBlank(this.properties.snStr)) {
        delete params.sn
      }

      netutil.getRequest(constant.URL_GET_AD, params, function (success) {
        var data = success.data;
        if (util.isBlank(data) || data.length == 0) {
          that.setData({
            hiddenAd: true,
          });
          that.triggerEvent('adSkip', {
            statu: true
          });
          util.printData('启动页无广告')
        } else {
          that.setData({
            hiddenAd: false,
            adData: data[0]
          });
          that.requestShowAd();
          that.triggerEvent('adShow', null);
          util.printData('启动页有广告')
        }
      }, function (fail) {
        console.log('请求失败')
      });
    },
    imageLoad: function (e) {
      var height = util.resizeImageHeight(375, e.detail);
      this.data.height = height;
      this.setData({
        height: height,
      })
    },
    //展示广告
    requestShowAd: function () {
      var that = this;
      var params = {
        'adId': this.data.adData.adId,
        'showPage': this.properties.showPage,
        'latitude': getApp().globalData.latitude,
        'longitude': getApp().globalData.longitude
      };
      netutil.getRequest(constant.URL_AD_SHOW, params, function (success) {
        var data = success.data;
      }, function (fail) { });
    },
    //点击广告
    requestClickAd: function () {
      var that = this;
      var params = {
        'adId': this.data.adData.adId,
        'showPage': this.properties.showPage,
        'latitude': getApp().globalData.latitude,
        'longitude': getApp().globalData.longitude
      };
      netutil.getRequest(constant.URL_AD_CLICK, params, function (success) {
        var data = success.data;
      }, function (fail) { });
    },
    //点击广告详情
    onAdDetailTap: function () {
      var contents = JSON.parse(this.data.adData.adJumpcontent);
      if (!util.isBlank(this.data.adData.adJumpcontent) && contents.length > 0) {
        getApp().openPage(adDetailPage, [{
          'key': 'content',
          'value': encodeURIComponent(this.data.adData.adJumpcontent)
        }, {
          'key': 'from',
          'value': 'start'
        }, {
          'key': 'sn',
          'value': this.properties.snStr
        }, {
          'key': 'name',
          'value': this.data.adData.adName
        }]);
        this.requestClickAd();
        this.properties.clickAd = true
        this.triggerEvent('adClick', null);
      }
    },




  }
})