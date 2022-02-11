var deviceId;
var i = 0;
var serviceId = [];
var characteristicId = [];
Page({
  data: {

  },
  onLoad: function () {
    wx.onBluetoothAdapterStateChange(function (res) {
      console.log('adapterState changed, now is', res)
    })

  },

  openadapter: function () {
    wx.openBluetoothAdapter({
      success: function (res) {
        console.log(res, "success")
      },
      fail: function (res) {
        console.log(res, "fail")
      },
    })
    // wx.getBluetoothAdapterState({
    //   complete: function (res) {
    //     console.log("currentstate:",res)
    //   }
    // })
  },
  closeadapter: function () {
    wx.closeBluetoothAdapter({
      success: function (res) {
        console.log(res, "success")
      },
      fail: function (res) {
        console.log(res, "fail")
      },
    })
    // wx.getBluetoothAdapterState({
    //   complete: function (res) {
    //     console.log("currentstate:", res)
    //   }
    // })
  },

  opendiscovery: function () {
    wx.startBluetoothDevicesDiscovery({
      services: [],
      success: function (res) {
        console.log(res)
      },
      fail: function (res) {
        console.log(res, "fail")
      },
    })
  },

  closediscovery: function () {
    wx.stopBluetoothDevicesDiscovery({
      success: function (res) {
        console.log(res)
      },
      fail: function (res) {
        console.log(res, "fail")
      },
    })
  },

  getdevice: function () {
    function ab2hex(buffer) {
      var hexArr = Array.prototype.map.call(
        new Uint8Array(buffer),
        function (bit) {
          return ('00' + bit.toString(16)).slice(-2)
        }
      )
      return hexArr.join('');
    }
    wx.getBluetoothDevices({
      success: function (res) {
        console.log(res)
        i = 0;
        while (res.devices[i]) {
          console.log(i);
          console.log(res.devices[i].name, res.devices[i].deviceId);
          if (res.devices[i].name == 'XHD_AC01') {
            deviceId = res.devices[i].deviceId;
            console.log(deviceId);
          }
          i++;
        }
      }
    })
  },

  getconnecteddevice: function () {
    wx.getConnectedBluetoothDevices({
      //services:[],
      success: function (res) {
        console.log(res)
      }
    })
  },
  connecteddevice: function () {
    wx.createBLEConnection({
      deviceId: deviceId,
      success: function (res) {
        console.log(res);
      },
    })
  },
  getservice: function () {
    wx.getBLEDeviceServices({
      deviceId: deviceId,
      success: function (res) {
        console.log(res.services);
        i = 0;
        while (res.services[i]) {
          serviceId[i] = res.services[i].uuid;
          console.log(serviceId[i]);
          i++;
        }
      },
    })
  },
  getcharacteristics: function () {
    wx.getBLEDeviceCharacteristics({
      deviceId: deviceId,
      serviceId: serviceId[0],
      success: function (res) {
        console.log('device getBLEDeviceCharacteristics:', res.characteristics)
      }
    })
    wx.getBLEDeviceCharacteristics({
      deviceId: deviceId,
      serviceId: serviceId[1],
      success: function (res) {
        i = 0;
        while (res.characteristics[i]) {
          characteristicId[i] = res.characteristics[i].uuid;
          console.log(characteristicId[i]);
          i++;
        }
      }
    })
  },
  startread: function () {
    wx.readBLECharacteristicValue({
      deviceId: deviceId,
      serviceId: serviceId[1],
      characteristicId: characteristicId[0],
      success: function (res) {
        console.log('readBLECharacteristicValue:', res.errCode)
      }
    })
  },
  startnotify: function () {
    wx.notifyBLECharacteristicValueChange({
      state: true,
      deviceId: deviceId,
      serviceId: serviceId[1],
      characteristicId: characteristicId[0],
      success: function (res) {
        console.log('notifyBLECharacteristicValueChange success', res.errMsg)
      }
    })
    function ab2hex(buffer) {
      var hexArr = Array.prototype.map.call(
        new Uint8Array(buffer),
        function (bit) {
          return ('00' + bit.toString(16)).slice(-2)
        }
      )
      return hexArr.join('');
    }
    wx.onBLECharacteristicValueChange(function (res) {
      console.log('characteristic value comed:', ab2hex(res.value))
    })
  },
  startwrite: function () {
    // let buffer = this.hexStringToArrayBuffer('111400100000033');
    var buffer = new ArrayBuffer(13);
    let dataView = new DataView(buffer)
    dataView.setUint8(0, 0xaa);
    dataView.setUint8(1, 0x03);
    dataView.setUint8(2, 0xff);
    dataView.setUint8(3, 0xff);
    dataView.setUint8(4, 0x10);
    dataView.setUint8(5, 0x00);
    dataView.setUint8(6, 0x03);
    dataView.setUint8(7, 0xa2);
    dataView.setUint8(8, 0xff);
    dataView.setUint8(9, 0xff);
    dataView.setUint8(10, 0xff);
    dataView.setUint8(11, 0xff);
    // dataView.setUint8(8, 0x00);
    // dataView.setUint8(9, 0x00);
    // dataView.setUint8(10, 0x00);
    // dataView.setUint8(11, 0x0f);
    dataView.setUint8(12, 0x55);
    wx.writeBLECharacteristicValue({
      deviceId: deviceId,
      serviceId: serviceId[1],
      characteristicId: characteristicId[1],
      value: buffer,
      success: function (res) {
        console.log('writeBLECharacteristicValue success', res.errMsg)
      },
      fail:function(res){
        console.log(res.errMsg);
      }

    })
  },
  hexStringToArrayBuffer(str) {
    if (!str) {
      return new ArrayBuffer(0);
    }

    var buffer = new ArrayBuffer(str.length);
    let dataView = new DataView(buffer)

    let ind = 0;
    for (var i = 0, len = str.length; i < len; i += 1) {
      let code = parseInt(str.substr(i, 1), 16)
      dataView.setUint8(ind, code)
      ind++
    }

    return buffer;
  },
  arrayBufferToHexString:function(buffer) {
    let bufferType = Object.prototype.toString.call(buffer)
    if (buffer != '[object ArrayBuffer]') {
      return
    }
    let dataView = new DataView(buffer)

    var hexStr = '';
    for (var i = 0; i < dataView.byteLength; i++) {
      var str = dataView.getUint8(i);
      var hex = (str & 0xff).toString(16);
      hex = (hex.length === 1) ? '0' + hex : hex;
      hexStr += hex;
    }

    return hexStr.toUpperCase();
  },



})
