//analysis.js
var markData = function(key,data){
    var baseData = {
      "userid": getApp().globalData.userId,
      "brand": getApp().globalData.brand,
      "model": getApp().globalData.model,
      // "network": getApp().globalData.networkType
    };
    for (var i in data) {
      baseData[i] = data[i]
    }
  console.log("key=" + key + "\ndata=");
  console.log(baseData);
  wx.reportAnalytics(key, baseData);
}


module.exports = {
  markData
}