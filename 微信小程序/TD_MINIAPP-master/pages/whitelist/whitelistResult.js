var netutil = require("../../utils/netutil.js");
var util = require("../../utils/util.js");
var constant = require("../../utils/constant.js");

Page({

  /**
   * 页面的初始数据
   */
  data: {
    img_vip:getApp().globalData.sk+"/bg_vip.png",
    img_scope:getApp().globalData.sk+"/ic_scope.png",
    img_arrow:getApp().globalData.sk+"/ic_down_arrow.png",
    orderWhiteListId:"",
    items: [],
    pageId:1,
    hasMore:true,
    listHeight : 0
  },

 
  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: getApp().globalData.productName
    })
    this.data.orderWhiteListId = options.orderWhiteListId;
    var app = getApp();
    this.setData({
      listHeight: app.globalData.windowH - app.globalData.windowW * 300 / 375,
    })
    this.requestScopeList();
  },

  
  onReachBottom: function () {
     this.data.pageId++;
     this.requestScopeList();
  },

  /**使用范围数据**/
  requestScopeList:function(){
    if(!this.data.hasMore) return;
    var that = this;
    var params = { 
      'orderWhiteListId': this.data.orderWhiteListId,
      'pageId':this.data.pageId,
    };
    netutil.getRequest(constant.URL_WHITELIST_SCOPE, params,
      function (success) {
        var result = success.data;
        var jsonObj = result.tblOrderWhiteListMches;
        var rows = jsonObj.rows;
        that.setData({
          items: that.data.items.concat(rows),
          hasMore: jsonObj.nextPage
        });
        
      },
      function (fail) {});
  },

  onPageTap: function () {
    console.log('page touch')
  }


})