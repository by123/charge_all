// component/adView.js
var netutil = require("../../utils/netutil.js");
var constant = require("../../utils/constant.js");
var util = require("../../utils/util.js");
let adDetailPage = '../../../../pages/addDetail/addDetail';
let adPage = '../../../../pages/ad/ad';

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
    }
  },

  /**
   * 组件的初始数据
   */
  data: {
    hiddenAd: false,
    adLists: [],
    currentTab: 0,
    snStr: '',
    pointWidth: 0,
    img_close_ad: getApp().globalData.sk + "/ic_close_ad.png",
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
        } else {
          for (var index in data) {
            that.requestShowAd(data[index]);
          }
          that.setData({
            hiddenAd: false,
            adLists: data,
          });
        }
      }, function (fail) {
        console.log('请求失败')
      });
    },
    //展示广告
    requestShowAd: function (data) {
      var that = this;
      var params = {
        'adId': data.adId,
        'showPage': this.properties.showPage,
        'latitude': getApp().globalData.latitude,
        'longitude': getApp().globalData.longitude
      };
      netutil.getRequest(constant.URL_AD_SHOW, params, function (success) {
        var data = success.data;
      }, function (fail) { });
    },
    //点击广告
    requestClickAd: function (data) {
      var that = this;
      var params = {
        'adId': data.adId,
        'showPage': this.properties.showPage,
        'latitude': getApp().globalData.latitude,
        'longitude': getApp().globalData.longitude
      };
      netutil.getRequest(constant.URL_AD_CLICK, params, function (success) {
        var data = success.data;
      }, function (fail) { });
    },
    //点击广告详情
    onAdDetailTap: function (e) {
      var data = this.data.adLists[this.data.currentTab];
      var openUrl = encodeURIComponent(data.adJumpurl);
      console.log('这是啥')
      var contents = JSON.parse(data.adJumpcontent);
      console.log(contents)
      if (!util.isBlank(data.adJumpcontent) && contents.length > 0) {
        if (contents[0].type == 'text' && contents[0].content.substring(0, 4) == 'http') {
          getApp().openPage(adPage, [{
            'key': 'url',
            'value': encodeURIComponent(contents[0].content)
          }, {
            'key': 'adName',
            'value': data.adName
          }]);
        } else {
          getApp().openPage(adDetailPage, [{
            'key': 'url',
            'value': openUrl
          }, {
            'key': 'content',
            'value': encodeURIComponent(data.adJumpcontent)
          }, {
            'key': 'name',
            'value': data.adName
          }]);
        }
        this.requestClickAd(data);
      }
    },

    //滑动切换广告
    onSwipeAdTap: function (e) {
      this.data.currentTab = e.detail.current;
      this.setData({
        currentTab: this.data.currentTab
      })
      console.log(e.detail.current);
    },

    //关闭广告
    onCloseAdTap: function () {
      this.setData({
        hiddenAd: true
      })
    },

  }
})