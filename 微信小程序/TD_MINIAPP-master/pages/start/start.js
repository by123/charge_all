// pages/start/start.js
var netutil = require("../../utils/netutil.js");
var util = require("../../utils/util.js");
var constant = require("../../utils/constant.js");

let chargePage = '../charge/charge/origin/charge';
let chargePrePage = '../charge/charge/pre/charge'
let homePage = '../home/home';
var chargecodePage = '../charge/chargecode/origin/chargecode';
var chargecodePrePage = '../charge/chargecode/pre/chargecode'
var chargecodeWTPage = '../charge/chargecode/whitelist/chargecode';
let whitelistPage = '../charge/charge/whitelist/charge';

Page({
  data: {
    productName: getApp().globalData.productName,
    img_lunch: getApp().globalData.sk + "/luncher.png",
    img_about: getApp().globalData.sk + "/ic_about.png",
    wxScan: null,
    tempToken: "",
    hiddenLuncherUI: false,
    skipTimer: null,
    canvasHidden: true,
    statu: false,
    clickAd: false,
    lastData: null
  },
  onLoad: function (options) {
    //如果是扫码进入
    this.data.wxScan = decodeURIComponent(options.q);
    util.printData("扫描到二维码:" + this.data.wxScan);
    this.setNavigationBar();
    this.getLocation();
    this.start();
  },

  //
  setNavigationBar: function () {
    wx.setNavigationBarTitle({
      title: getApp().globalData.productName,
    });
    wx.setNavigationBarColor({
      frontColor: getApp().globalData.product == 0 ? '#000000' : '#ffffff',
      backgroundColor: getApp().globalData.product == 0 ? '#ffffff' : '#fd5750'
    });
  },

  //获取地理位置
  getLocation: function () {
    wx.getLocation({
      type: 'gcj02',
      success: function (res) {
        getApp().globalData.latitude = res.latitude;
        getApp().globalData.longitude = res.longitude;
        util.printData('获取地理位置成功');
      }
    });
  },

  getAd: function () {
    if (!util.isBlank(this.data.wxScan)) {
      var adview = this.selectComponent("#adfullview")
      adview.showAdWithSn(this.data.wxScan.slice(constant.scanUrl.length));
      util.printData('广告使用的sn号:' + this.data.wxScan.slice(constant.scanUrl.length));
    }
  },

  start: function () {
    var that = this;
    var timerId = setInterval(function () {
      //检测是否登录
      wx.getStorage({
        key: constant.KEY_TOKEN,
        success: function (res) {
          if (util.isBlank(res.data)) {
            util.printData('本地不存在token');
            that.getLoginCode();
          } else {
            util.printData('本地存在token=' + res.data);
            wx.getStorage({
              key: constant.KEY_TOKEN_TYPE,
              success: function (res) {
                if (res.data == 0) {
                  util.printData('本地存在tokenType=' + res.data);
                  getApp().globalData.authorization = res.data;
                  that.getUserStatu();
                } else {
                  util.printData('本地存在tokenType=' + res.data);
                  that.data.tempToken = res.data;
                  that.setData({
                    hiddenLuncherUI: true
                  })
                }
              },
              fail: function (res) {
                util.printData('tokenType未定义');
                that.getLoginCode();
              }
            });
          }
        }, fail:function(){
          util.printData('token未定义');
          that.getLoginCode();
        }
      });
      clearInterval(timerId);
    }, 1000);
  },

  /**
   * 获取登录code
   */
  getLoginCode: function () {
    this.clearSkpiTimer();
    var that = this;
    wx.login({
      success: res => {
        that.doLogin(res.code);
      },
      fail: res => {
        util.showToast('微信code获取失败' + res.errMsg);
      }
    });
  },

  /**
   * 请求登录
   */
  doLogin: function (code) {
    var that = this;
    var params = {
      'code': code
    };
    netutil.getRequest(constant.URL_LOGIN, params,
      function (success) {
        var result = success.data;
        getApp().globalData.synWx = result.synWx;
        if (result.tokenType == 0) {
          console.log("保存token = " + result.token);
          wx.setStorage({
            key: constant.KEY_TOKEN,
            data: result.token,
            success: function (res) {
              console.log("token保存成功")
            }
          });
          netutil.setAuthrization(result.token);
          that.getUserStatu();
        } else {
          that.data.tempToken = result.token;
            wx.showModal({
              title: '温馨提示',
              content: '炭电需要获取您的个人信息登录',
              showCancel: true,
              success: function (res) {
                 if (res.confirm) {
                  that.getUserInfo();
                 }
              },
              fail: function (res) { },//接口调用失败的回调函数
              complete: function (res) { },//接口调用结束的回调函数（调用成功、失败都会执行）
           })
          that.setData({
            hiddenLuncherUI: true
          })
        }
        wx.setStorage({
          key: constant.KEY_TOKEN_TYPE,
          data: result.tokenType
        });
      },
      function (fail) { });
  },

  /**
   * 获取当前用户充电状态
   * chargingFlag 
   * 0 未充电
   * 1 已充电
   */
  getUserStatu: function () {
    util.printData('获取用户充电状态')
    var that = this;
    netutil.getRequest(constant.URL_GETLASTCHARGE_STATU, null, function (success) {
      var data = success.data;
      wx.setStorage({
        key: "charge_statu",
        data: data.chargingFlag
      });
      getApp().globalData.lastOrderData = data;
      that.data.lastData = data;
      that.drawSkip();
      // that.getAd();

    }, function (fail) {
      util.printData('获取充电状态失败')
    });
  },

  goNextPage: function () {
    var data = this.data.lastData;
    if (data.chargingFlag == 0) {
      //未充电，没有扫描二维码打开
      if (this.data.wxScan == "undefined") {
        util.printData('未充电，没有扫描二维码打开')
        if (!this.data.clickAd) {
          getApp().openPageWithoutBack(homePage, null);
        }
      } else {
        var snStr = this.data.wxScan.slice(constant.scanUrl.length);
        //未充电，扫描充电器上的二维码打开
        util.printData('未充电，扫描充电器上的二维码打开')
        if (!this.data.clickAd) {
          var params = {
            "deviceSN": snStr
          };
          var that = this
          netutil.getRequest(constant.URL_GETDEVICE_PRICE, params, function (success) {
            var result = success.data;
            var params = [{ 'key': 'deviceSn', 'value': snStr },
            { 'key': 'duration', 'value': result.duration }];
            //白名单
            var isOnOrderWhiteList = result.isOnOrderWhiteList;
            if (isOnOrderWhiteList) {
              getApp().reLunchPage(whitelistPage, params);
            }
            else {
              getApp().openPageWithoutBack(result.serviceType == 1 ? chargePage : chargePrePage, [{
                'key': 'scanUrl',
                'value': encodeURIComponent(that.data.wxScan)
              }]);
            }
          }, function (fail) {
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
        }
      }
    } else if (data.chargingFlag == 1) {
      //已经有设备正在充电
      var ramainTime = parseInt(data.remainTime / 1000);
      //0白名单，1非白名单
      if (data.whiteListFlag == 0) {
        util.printData('已充电，白名单用户打开')
        if (!this.data.clickAd) {
          var param = [{ 'key': 'sn', 'value': data.deviceSn }];
          getApp().openPageWithoutBack(chargecodeWTPage, param);
        }
        return;
      }
      var snStr = "";
      if (!util.isBlank(constant.scanUrl)) {
        snStr = this.data.wxScan.slice(constant.scanUrl.length);
      }
      if (snStr == data.deviceSn || this.data.wxScan == "undefined") {
        util.printData('设备相同或者非扫设备二维码进入')
        //设备相同或者非扫设备二维码进入，跳转到充电密码页面
        if (!this.data.clickAd) {
          getApp().openPageWithoutBack(data.serviceType == 1 ? chargecodePage : chargecodePrePage, [{
            'key': 'time',
            'value': ramainTime
          },
          {
            'key': 'orderId',
            'value': data.orderId
          },
          {
            'key': 'sameDevice',
            'value': 1
          },
          {
            'key': 'password',
            'value': data.password
          },
          {
            'key': 'sn',
            'value': data.deviceSn
          },
          {
            'key': 'showFinish',
            'value': data.chargingFlag
          }
          ]);
        }
      } else {
        util.printData('设备不同，跳转到充电密码页面')
        //设备不同，跳转到充电密码页面
        if (!this.data.clickAd) {
          getApp().openPageWithoutBack(data.serviceType == 1 ? chargecodePage : chargecodePrePage, [{
            'key': 'time',
            'value': ramainTime
          },
          {
            'key': 'orderId',
            'value': data.orderId
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
        console.log("设备不相同")
      }
    }
  },
  /**
   * 授权用户
   */
  getUserInfo: function () {
      var that = this
      wx.getUserProfile({
        desc: '用于完善会员资料',
        success: (res) => {
           that.bindUser(res)
        }
      })
  },

  /**
   * 上传用户信息
   */
  bindUser: function(res){
    var that = this;
    var encryptedData = res.encryptedData;
    var iv = res.iv;
    var rawData = res.rawData;
    var signature = res.signature;
    var jsonObj = {
      "encryptedData": encryptedData,
      "iv": iv,
      "rawData": rawData,
      "signature": signature
    };
    var header = {
      'content-type': 'application/json',
      'token': this.data.tempToken,
      "latitude": getApp().globalData.latitude,
      "longitude": getApp().globalData.longitude
    };
    netutil.postRequestWithHeader(constant.URL_BINDUSER, header, JSON.stringify(jsonObj), function (success) {
      netutil.setAuthrization(success.data.token)
      if (that.data.wxScan == "undefined") {
        getApp().openPageWithoutBack(homePage, null);
      } else {
        getApp().openPageWithoutBack(chargePage, [{
          'key': 'scanUrl',
          'value': encodeURIComponent(that.data.wxScan)
        }]);
        wx.setStorage({
          key: constant.KEY_NEW_USER,
          data: 1,
        });
      }
    }, function (fail) {
      wx.clearStorage();
      that.getLoginCode();
    });
  },

  onShareAppMessage: function () {
    return util.shareContent();
  },


  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  drawSkip: function () {
    // var that = this;
    // var step = 1, //计数动画次数
    //   num = 0, //计数倒计时秒数（n - num）
    //   start = 1.5 * Math.PI, // 开始的弧度
    //   end = -0.5 * Math.PI, // 结束的弧度
    //   animation_interval = 1000,
    //   n = 5;
    // // 动画函数
    // function animation() {
    //   if (step <= n) {
    //     end = end + 2 * Math.PI / n;
    //     ringMove(start, end);
    //     step++;
    //   } else {
    //     clearInterval(that.data.skipTimer);
        this.goNextPage();
      // }
    // };
    // // 画布绘画函数
    // function ringMove(s, e) {
    //   var left = 16;
    //   var top = 16;
    //   var r = 16;
    //   var context = wx.createCanvasContext('secondCanvas')

    //   // 绘制圆形
    //   context.arc(left, top, r, 0, Math.PI * 2, false)
    //   context.setFillStyle('white')
    //   context.fill()

    //   // 绘制圆环
    //   context.setStrokeStyle('#FFCE00')
    //   context.beginPath()
    //   context.setLineWidth(2)
    //   context.arc(left, top, r, s, e, true)
    //   context.stroke()
    //   context.closePath()

    //   // 绘制倒计时文本
    //   context.beginPath()
    //   context.setLineWidth(2)
    //   context.setFontSize(10)
    //   context.setFillStyle('#757685')
    //   context.setTextAlign('center')
    //   context.setTextBaseline('middle')
    //   context.fillText('跳过', left, top, r * 2)
    //   context.fill()
    //   context.closePath()

    //   context.draw()

    //   // 每完成一次全程绘制就+1
    //   num++;
    // }
    // // 倒计时前先绘制整圆的圆环
    // ringMove(start, end);
    // // 创建倒计时
    // that.data.skipTimer = setInterval(animation, animation_interval);
  },

  //无广告跳过
  onAdSkip: function () {
    console.log('无广告');
    this.onSkipTap();
  },
  //点击跳转广告详情
  onAdClick: function () {
    this.data.clickAd = true;
    this.clearSkpiTimer();
  },
  //有广告显示跳过按钮
  onAdShow: function () {
    console.log('有广告');
    this.setData({
      canvasHidden: false
    })
  },

  onSkipTap: function () {
    this.goNextPage();
    this.clearSkpiTimer();
  },

  //清除广告倒计时
  clearSkpiTimer: function () {
    clearInterval(this.data.skipTimer);
    this.setData({
      canvasHidden: true
    })
  },

})