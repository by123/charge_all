//app.js
var netutil = require("/utils/netutil.js");
var constant = require("/utils/constant.js");
var util = require("/utils/util.js");

//0为炭电，1为小红电
let product = 0

App({
  onLaunch: function () {
    //获取手机信息
    var that = this;
    wx.getSystemInfo({
      success: function (res) {
        that.globalData.windowW = res.windowWidth;
        that.globalData.windowH = res.windowHeight;
        //手机品牌
        that.globalData.brand = res.brand;
        //手机型号
        that.globalData.model = res.model;
        //微信版本号
        that.globalData.version = res.version;
        //操作系统版本
        that.globalData.system = res.system;
        //客户端平台
        that.globalData.platform = res.platform;
        console.log("手机品牌 = " + res.brand);
        console.log("手机型号 = " + res.model);
        console.log("微信版本号 = " + res.version);
        console.log("操作系统版本 = " + res.system);
        console.log("客户端平台 = " + res.platform);
        console.log("window width = " + res.windowWidth);
        console.log("window height = " + res.windowHeight);
      }
    });
    // netutil.listenNetwork();
  },



   onShow:function(options){
     var pages = getCurrentPages() //获取加载的页面
     if(pages.length > 0){
       var page = pages[pages.length - 1] //获取当前页面的对象
       var route = page.route;
       var scene = options.scene;
       if (scene == 'undefined') { return; }
       console.log("路径:"+route);
       if (route && route == "pages/charge/charge/origin/charge"){
         if (scene == 1089 || scene == 1001){
         netutil.getRequest(constant.URL_GETLASTCHARGE_STATU,null,function (success) {
              var data = success.data;
              if (data.chargingFlag == 0) {
                wx.setStorage({key: "charge_statu",data: 0});
                getApp().reLunchPage('../start/start',null);
               }else{
                console.log("by测试->首页进入获取支付状态");
                wx.setStorage({key: "charge_statu",data: 1});
               }
            }, function (fail) {

            });
          }
       } else if (route && route == "pages/charge/chargecode/origin/chargecode"){
         console.log("聊天下拉打开密码页");
         if (scene == 1089 || scene == 1001) {
           getApp().globalData.nextStepChargeCode = 1;
         }
      }
     }
    
   },

  /**跳转方法**/

  /**跳转到下一页*/
  openPage:function(url,params){
    wx.navigateTo({
      url: util.buildUrl(url, params)
    });
   },
  /**跳转到下一页，不需要返回*/
  openPageWithoutBack: function (url, params){
    wx.redirectTo({
      url: util.buildUrl(url, params)
    })
  },
  /**打开当前页，清除所有页*/
  reLunchPage:function(url,params){
    setTimeout(function () {
      wx.reLaunch({
        url: util.buildUrl(url, params)  
      });
    }, 200);
  },


 //sk = 0,炭电 sk = 1,小红电
  globalData: {
    windowW: 0,
    windowH: 0,
    latitude:0,
    longitude:0,
    authorization:"",
    userid:"",
    brand:"",
    model:"",
    version:"",
    system:"",
    platform:"",
    gender:0,
    nextStepChargeCode:0,
    product:product,
    productName: "炭电",
    sk: "/imgs/yellow",
    snStr:'',
    lastOrderData:'',
    synWx: 0
  }
})

