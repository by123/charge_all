var util = require("util.js");

//格式化时间
const formatTime = number => {
  var date = new Date(number);

  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours()
  const minute = date.getMinutes()
  const second = date.getSeconds()

  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

const formatNumber = n => {
  n = n.toString()
  return n[1] ? n : '0' + n
}


/*获取设备信息*/
var getSystemInfo = function(result) {
  wx.getSystemInfo({
    success: function(res) {
      result(res);
    }
  });
}
/**
 * 是否为空字符串或数组
 */
var isBlank = function(str) {
  if (Object.prototype.toString.call(str) === '[object Undefined]') { //空
    return true
  } else if (
    Object.prototype.toString.call(str) === '[object String]' ||
    Object.prototype.toString.call(str) === '[object Array]') { //字条串或数组
    return str.length == 0 ? true : false
  } else if (Object.prototype.toString.call(str) === '[object Object]') {
    return JSON.stringify(str) == '{}' ? true : false
  } else {
    return true
  }

}

var generateHmStr = function(minutes) {
  var hour = parseInt(minutes / 60);
  var minute = parseInt(minutes % 60);
  if (minute == 0) {
    return hour + '小时';
  }
  if (minute < 10) {
    return hour + '小时0' + minute + '分'
  }
  return hour + '小时' + minute + '分'
}


/**
 * 格式化时间（xx小时xx分xx秒）
 */
var generateAllTimeStr = function(data) {
  var hour = parseInt(data / 3600);
  var minute = parseInt((data - hour * 3600) / 60);
  var seconds = parseInt(data - hour * 3600 - minute * 60)
  return hour + '小时' + minute + '分' + seconds + "秒"
}


/*****
 * 播放音频
 * *****/


var innerAudioContext;
const audioPlay = ({
  authorization,
  audioUrl
}) => {
  //销毁上一个音频
  if (innerAudioContext != null) {
    innerAudioContext.destroy()
  }
  //if (authorization !== '') return;
  //重新创建
  innerAudioContext = wx.createInnerAudioContext();
  innerAudioContext.autoplay = true;
  innerAudioContext.src = audioUrl;
  innerAudioContext.onPlay(() => {
    console.log('开始播放')
  })
  innerAudioContext.onError((res) => {
    console.log(res.errMsg)
  })
}

const destoryPlay = function() {
  if (innerAudioContext == null) return;
  innerAudioContext.destroy()
}

const checkPhoneVal = (val) => {
  if (!(/^1(3|4|5|7|8)\d{9}$/.test(val))) {
    wx.showToast({
      title: '手机号不正确',
      icon: 'loading',
      duration: 1000
    })
    return false;
  }
  return true;
}

var buildUrl = function(url, params) {
  if (isBlank(params)) {
    return url;
  }
  url = url + "?";
  for (var index in params) {
    var item = params[index];
    url = url + item.key + "=" + item.value + "&";
  }
  url = url.slice(0, url.length - 1);
  console.log("跳转链接：" + url);
  return url;
}

var shareContent = function() {
  return {
    title: getApp().globalData.productName,
    path: 'pages/start/start',
    success: function(res) {},
    fail: function(res) {}
  }
}

var showToast = function(titleStr) {
  wx.showToast({
    title: titleStr,
    icon: 'none',
    duration: 1000
  });
}

var printData = function(content) {
  console.log('print(' + content + ')');
}

var resizeImageHeight = function(originWidth, imageSize) {
  return imageSize.height * originWidth / imageSize.width;
}


module.exports = {
  formatTime,
  isBlank,
  generateHmStr,
  generateAllTimeStr,
  audioPlay,
  destoryPlay,
  checkPhoneVal,
  buildUrl,
  shareContent,
  showToast,
  printData,
  resizeImageHeight
}