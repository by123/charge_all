import { API_HOST } from '../config/config.js';

// import {
//   login,
// } from './user.js';
import {
  getStorageItem,
} from './util.js';
import { TOKEN_KEY } from './enum.js';
import CustomEvent from './event.js';

function HandleMethod(method, url, data, otherOptions) {
  return new Promise((resolve, reject) => {
    if (/^(http|https):\/\//.test(url))
      url = url;
    else
      url = API_HOST + url;

    if (Object.prototype.toString.call(data) !== '[object Object]') {
      data = {}
    }

    request();

    function request() {
      let header = {
        'Content-Type': 'application/json'
      }
      const bearerToken = getStorageItem(TOKEN_KEY);
      
      if (bearerToken) {
        header['authorization'] = `${bearerToken.indexOf('Bearer') === -1 ? 'Bearer;' : ''}${bearerToken}`;
      }
      const token = getStorageItem('token');
      if (token) {
        header['token'] = token;
      }

      let options;

      new Promise((resolve1, reject1) => {
          options = {
            url: url,
            data: data,
            method: method,
            header: header,
            success: res => resolve1(res),
            fail: res => reject1(res),
            ...otherOptions,
          };
          wx.request(options);
        })
        .then((d) => {
          // console.log('response', d.data);
          if (d.data && d.data.status === '90') {
            // wx.clearStorage('bearer-token');
            CustomEvent.emit('reLogin', request);
            // login(request);
          } else if (d.data && d.data.success === true) {
            resolve(d.data);
          } else {
            _showError(d);
            reject(d);
          }
        })
        .catch(function(err) {
          console.log('Error :', err);
          _showError(err);
          reject(err);
        });
    }

  });
}

function _showError(err) {
  // console.log(err.data.msg);
  const { data, statusCode } = err || {};
  let { msg = '', status } = data || {};
  let errMsg = '';
  console.log('错误消息', msg, status === '24');
  if (msg && status !== '90' && status !== '24') {
    errMsg = msg;
  } else if (statusCode === 500 || statusCode === 501 || statusCode === 502) {
    errMsg = '网络超时';
  }

  if (errMsg) {
    wx.showToast({
      title: msg,
      icon: 'none',
      duration: 1000
    });
  }
  // wx.hideToast();
}

function _get(url, data) {
  let obj = {
    _timestamp: new Date().getTime()
  };

  if (Object.prototype.toString.call(data) === '[object Object]') {
    data['_timestamp'] = data['_timestamp'] ? data['_timestamp'] : new Date().getTime();
    obj = data;
  }

  return HandleMethod('GET', url, obj);
}

function _post(url, data) {
  return HandleMethod('POST', url, data);
}

function _put(url, data) {
  return HandleMethod('PUT', url, data);
}

function _delete(url, data) {
  return HandleMethod('DELETE', url, data);
}

export const get = _get;
export const post = _post;
export const put = _put;
export const request = HandleMethod;

export default {
  'get': _get,
  'post': _post,
  'put': _put,
  'delete': _delete,
  'request': HandleMethod
}