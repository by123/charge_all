import React from 'react';
import cloneDeep from 'lodash/cloneDeep';
import moment from 'moment';
import map from 'lodash/map';
import isArray from 'lodash/isArray';
import isString from 'lodash/isString';
import isObject from 'lodash/isObject';
import isBoolean from 'lodash/isBoolean';
import isNumber from 'lodash/isNumber';
import compact from 'lodash/compact';

import { Select, Form, Radio, Tag } from 'antd';
import { parse, stringify } from 'query-string';
import { IMG_HOST, SN_INPUT_SPLIT_REG } from './constants';
import { TimeToScales, withdrawalState, allAgentLevelTypes, bizTypes } from './enum';

const { Option } = Select;

/**
 * 连字符转驼峰
 * @returns {string}
 */
String.prototype.hyphenToHump = function () {
  return this.replace(/-(\w)/g, (...args) => args[1].toUpperCase());
};

/**
 * 驼峰转连字符
 * @returns {string}
 */
String.prototype.humpToHyphen = function () {
  return this.replace(/([A-Z])/g, '-$1').toLowerCase();
};

/**
 * 日期格式化
 * @param format
 * @returns {*}
 */
Date.prototype.format = function (format) {
  const o = {
    'M+': this.getMonth() + 1,
    'd+': this.getDate(),
    'h+': this.getHours(),
    'H+': this.getHours(),
    'm+': this.getMinutes(),
    's+': this.getSeconds(),
    'q+': Math.floor((this.getMonth() + 3) / 3),
    S: this.getMilliseconds(),
  };
  if (/(y+)/.test(format)) {
    format = format.replace(RegExp.$1, `${this.getFullYear()}`.substr(4 - RegExp.$1.length));
  }
  for (const k in o) {
    if (new RegExp(`(${k})`).test(format)) {
      format = format.replace(RegExp.$1, RegExp.$1.length === 1 ? o[k] : (`00${o[k]}`).substr(`${o[k]}`.length));
    }
  }
  return format;
};


/**
 * 获取url中的params参数
 * @param   {String}  name
 * @return  {String}
 */
export const queryURL = (name) => {
  const reg = new RegExp(`(^|&)${name}=([^&]*)(&|$)`, 'i');
  const r = window.location.search.substr(1).match(reg);
  if (r != null) return decodeURI(r[2]);
  return null;
};

/**
 * 数组内查询
 * @param   {array}      array
 * @param   {String}    key
 * @param   {String}    keyAlias
 * @return  {Array}
 */
export const queryArray = (array, key, keyAlias = 'key') => {
  if (!(array instanceof Array)) {
    return null;
  }
  const item = array.filter(_ => _[keyAlias] === key);
  if (item.length) {
    return item[0];
  }
  return null;
};

/**
 * 数组格式转树状结构
 * @param   {array}     array
 * @param   {String}    id
 * @param   {String}    pid
 * @param   {String}    children
 * @return  {Array}
 */
export const arrayToTree = (array, id = 'id', pid = 'pid', children = 'children') => {
  const data = cloneDeep(array);
  const result = [];
  const hash = {};
  data.forEach((item, index) => {
    hash[data[index][id]] = data[index];
  });

  data.forEach((item) => {
    const hashVP = hash[item[pid]];
    if (hashVP) {
      !hashVP[children] && (hashVP[children] = []);
      hashVP[children].push(item);
    } else {
      result.push(item);
    }
  });
  return result;
};

export const getPictrueUrl = (uuid) =>
  IMG_HOST + uuid // 这里可以通过7牛API约束图片大小
  ;


export function loadScript(src) {
  return new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = src;
    script.onload = resolve;
    script.onerror = reject;
    document.head.appendChild(script);
  });
}

/**
 * 格式化金额（默认保留两位小数）
 * @param num String或Number类型
 * @returns {String}
 */
export const formatDecimal = (num, n = 2) => {
  // 默认返回 0.00
  if (isNaN(num) || +num === 0) num = 0;
  return Number(parseFloat(num).toFixed(n));
};

/**
 * 时间戳转 日期间字符串
 * 常用用于页面展示
 * @param timestamp
 * @returns {string}
 */
export const dateFormat = timestamp => (timestamp ? moment(timestamp, 'x').format('YYYY-MM-DD') : '');
export const monthFormat = timestamp => (timestamp ? moment(timestamp, 'x').format('YYYY-MM') : '');
export const monthFormatChina = timestamp => (timestamp ? moment(timestamp, 'x').format('YYYY年MM月') : '');

/**
 * 时间戳转 日期+时间字符串
 * 常用用于页面展示
 *
 * @param timestamp
 * @returns {string}
 */
export const datetimeFormat = (timestamp, format = 'YYYY-MM-DD HH:mm:ss') => {
  return (timestamp ? moment(timestamp, 'x').format(format) : '');
};

/**
 * 日期 ===>>> Moment 对象
 *
 * use case:
 *    formatDateToMoment('2017-12-10')  // 转换字符串日期
 *    formatDateToMoment(['2017-12-1', '2017-12-10']) // 转换日期范围
 *    formatDateToMoment('2017-12-10 12:10:13', true) // 转换字符串时间
 *    formatDateToMoment([1512991237009, 1512991977009]) // 转换日期范围(时间戳类型)
 *
 * @param dates Number or String or Array
 * @param isTime  Boolean
 * @param formatter  String
 * @returns {*}
 */
export const formatDateToMoment = (dates, isTime, formatter) => {
  if (isString(isTime)) {
    formatter = isTime;
  }
  let format = isTime ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD';
  if (formatter) format = formatter; // 特殊的格式处理
  if (Array.isArray(dates)) {
    const [start, end] = dates;
    if (isNumber(start) && isNumber(end)) {
      return [moment(start), moment(end)]; // 时间戳转换成moment
    }
    return start && end ? [moment(start, format), moment(end, format)] : [];
  }
  if (isString(dates)) {
    return moment(dates, format);
  }
  return moment(dates); // 时间戳转换
};

export const addDateZero = (text, addZero) => {
  return `${text}${addZero ? ' 00:00:00' : ''}`;
};

export const addEndTime = (text, addZero) => {
  return `${text}${addZero ? ' 23:59:59' : ''}`;
};

/**
 * moment 对象 ===>>> 时间戳/格式化字符串
 *
 * use case:
 *    momentToFormatDate(moment)    // 格式化为日期
 *    momentToFormatDate(moment, true)  // 格式化为时间
 *
 * @param moments Moment or Moment[]
 * @param format
 * @returns {*}
 */
export const momentToFormatDate = (moments, isTime, formatter, toZero) => {
  if (isString(isTime)) {
    formatter = isTime;
  }
  let format = isTime && !toZero ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD';
  toZero = !!toZero;
  if (formatter) format = formatter; // 特殊的格式处理
  if (Array.isArray(moments)) {
    const [start, end] = moments;
    if (start && start.format && end && end.format) {
      return [addDateZero(start.format(format), toZero), addEndTime(end.format(format), toZero)];
    }
    return [];
  }
  if (moments && moments.format) return addDateZero(moments.format(format), toZero);
};


/**
 * 将DatePicker中的moment对象的时间去除，仅保留日期
 * 因为只选择日期的话，默认的时间是当前时间，而不是当天的00:00
 *
 * @param m Moment对象
 * @returns {number} 当前日期的时间戳
 */
export const getDateTimestamp = (m) => {
  const dateStr = dateFormat(m);
  return formatDateToMoment(dateStr).format('x');
};

/**
 * 将RangePicker中的moment对象数组转成可提交的表单字段
 * 直接赋值到fields中，在业务中不用再合并一次fields
 *
 * @param fields
 * @param dateKey
 * @param startKey
 * @param endKey
 * @param isTime
 */
export const processDateRangeToFields = (fields, dateKey, startKey, endKey, isTime, toZero = true) => {
  const dateArea = fields[dateKey];
  if (dateArea.length) {
    const [startTime, endTime] = momentToFormatDate(dateArea, isTime, null, toZero);
    fields[startKey] = startTime;
    fields[endKey] = endTime;
  } else {
    fields[startKey] = null;
    fields[endKey] = null;
  }
  delete fields[dateKey];
};

/**
 * 将RangePicker中的moment对象数组转成可提交的表单字段
 * @param dateArea
 * @param startKey
 * @param endKey
 * @param isTime
 * @returns {{}}
 */
export const processDateRange = (dateArea, startKey, endKey, isTime) => {
  const ret = {};
  if (dateArea.length) {
    const [startTime, endTime] = momentToFormatDate(dateArea, isTime);
    ret[startKey] = startTime;
    ret[endKey] = endTime;
  }
  return ret;
};

/**
 * 将表单字段转化成RangePicker初始化的moment对象
 * @param fields
 * @param startKey
 * @param endKey
 * @returns {*}
 */
export const initialDateRange = (fields, startKey, endKey, isTime) => {
  return formatDateToMoment([fields[startKey], fields[endKey]], isTime);
};

/**
 * 浮动窗口需要指定该id作为浮动容器层，避免滚动时的错误问题
 * @returns {HTMLElement | null}
 */
export const getPopupContainer = () => document.getElementById('dashboard_main_wrap');

/**
 * 将枚举值转换成Option项
 * @param enumType
 * @param hasAll
 * @returns {*}
 */
export const mapObjectToOptions = (enumType, hasAll) => {
  const Options = map(enumType, (item, index) => {
    item = isObject(item) ? item.text : item;
    return <Option key={index}>{item}</Option>;
  });
  if (hasAll) {
    return [<Option key="" value="">全部</Option>].concat(Options);
  }
  return Options;
};

/**
 * 将数组转换成Option项
 * @param array
 * @param key
 * @param label
 * @param hasAll
 * @returns {*[]}
 */
export const mapArrayToOptions = (array, key = 'value', label = 'label', hasAll) => {
  if (!array || !array.length) return;
  label = label.split(' ');
  const Options = array.map((item) => {
    let value = label.reduce((total, labelItem) => {
      return `${total} ${item[labelItem]}`;
    }, '');
    return <Option key={item[key]}>{value}</Option>;
  });
  if (isBoolean(key)) { // 简化参数
    hasAll = key;
  }
  if (hasAll) {
    return [<Option key="" value="">全部</Option>].concat(Options);
  }
  return Options;
};

/**
 * 将枚举值转换成Radio项
 * @param enumType
 * @returns {Array}
 */
export const mapObjectToRadios = (enumType) => {
  return map(enumType, (item, index) => {
    if (isObject(item)) {
      item = item.text;
    }
    return { label: item, value: index };
  });
};

/**
 * 获取query中的ID字段
 * @param name
 */
export const getId = (name = 'id') => {
  const query = parse(location.search);
  if (query[name]) {
    return query[name];
  }
};


/**
 * 获取URL参数
 * @param name
 * @return String | Object
 */
export const getParam = (name) => {
  const query = parse(location.search);
  if (name) {
    return query[name];
  }
  return query;
};

export const createReducer = (initialState, handlers) => (state = initialState, action) => {
  const handler = handlers[action.type];
  if (handler && handler instanceof Function) {
    return handler(state, action);
  }
  return state;
};

/**
 * 当reducer的状态为对象时，需要通过合并的方式返回一个新的对象才会触发组件更新props
 * 基本的reducer状态合并
 * @param state
 * @param payload
 * @param key
 * @returns {{}}
 */
export const mergeState = (state, payload, key) => {
  return {
    ...state,
    [key]: {
      ...state[key],
      ...payload,
    },
  };
};

export function isPromise(value) {
  if (value !== null && typeof value === 'object') {
    return value.promise && typeof value.promise.then === 'function';
  }
}

export const createChainedAsyncAction = (firstAction, handlers) => {
  if (!isArray(handlers)) {
    throw new Error('[createChainedAsyncAction] handlers should be an array');
  }

  return dispatch => (
    firstAction(dispatch)
      .then((resultAction) => {
        for (let i = 0; i < handlers.length; i += 1) {
          const { status, callback } = handlers[i];
          const expectedStatus = `_${status.toUpperCase()}`;

          if (resultAction.type.indexOf(expectedStatus) !== -1) {
            return callback(resultAction.payload)(dispatch);
          }
        }

        return resultAction;
      })
  );
};

/**
 * 生成页面列表初始化的对象
 * 常用于 mapStateToProps 中
 *
 * @returns {{items: Array, totalRowsCount: number, pageSize: number, pageIndex: number}}
 */
export const createInitialList = () => {
  return {
    items: [],
    totalRowsCount: 0,
    pageSize: 15,
    pageId: 1,
  };
};

/**
 * 打开新窗口
 * @param {String} url
 * @param {Object} query
 * @param {String} name 窗口名称
 * @param {String} origin
 */
export const openWindow = (url, query, name = '_blank', origin = window.location.origin) => {
  if (!/^http/.test(url)) {
    url = `${origin}/${url.replace(/^\/+/, '')}`;
  }
  const params = stringify(query);
  window.open(`${url}${params && `?${params}`}`, name);
};

/**
 * 按照参数的顺序拼接字符串，所有参数必须为String或Number；
 * 若有一个参数不为String或Number，返回''；
 * 该方法主要用于页面显示字段Label的拼接。
 * @param {String} args 要拼接的字符串模块
 * @return {String} 拼接后的字符串
 */
export const concatLabel = (...args) => {
  return args.reduce((pre, item) => {
    if (typeof pre === 'string'
      && typeof item === 'string'
      || typeof item === 'number') {
      return `${pre}${item}`;
    }
    return null;
  }, '') || '';
};

/**
 * 将日期往后推
 * @param {Date} date 参考日期
 * @param {String} date 可选 year month date ，默认 date
 * @param {Number} num 数量级
 */
export const nextDate = (date, type = 'date', num = 1) => {
  date = date || new Date();
  const isStringResult = typeof date === 'string';
  isStringResult && (date = new Date(date));
  if (Object.prototype.toString.call(date) === '[object Date]') {
    type = String.prototype.toLocaleUpperCase.call(type);
    switch (type) {
      case 'YEAR':
        date.setFullYear(date.getFullYear() + num);
        date.setDate(date.getDate() - 1);
        break;
      case 'MONTH':
        date.setMonth(date.getMonth() + num);
        date.setDate(date.getDate() - 1);
        break;
      case 'DATE':
        date.setDate(date.getDate() + num);
        break;
      default:
        date.setDate(date.getDate() + num);
    }
    return isStringResult ? dateFormat(date, 'YYYY-MM-DD') : date;
  }
};

/**
 * 将日期往后推n个月，默认是1
 * @param {Date} date 参考日期
 * @param {Number} num 月数
 */
export const nextMonth = (date, num = 1) => nextDate(date, 'month', num);

/**
 * 获取当天后的一个自然月
 */
export const getNextMonth = () => {
  let nMonth;
  let nYear;
  let nowDate = new Date();
  let year = nowDate.getFullYear();
  let month = nowDate.getMonth() + 1;
  let today = nowDate.getDate();
  if (month === 12) {
    nMonth = 1;
    nYear += 1;
  } else {
    nMonth = month + 1;
    nYear = year;
  }
  if (month < 10) {
    month = `0${month}`;
  }
  const nextLastDay = new Date(nYear, nMonth, 0).getDate();
  const repayBeginDate = `${year}-${month}-${today}`;
  const lastDay = today - 1 > nextLastDay ? nextLastDay : today - 1;
  const repayEndDate = `${nYear}-${nMonth}-${lastDay}`;
  return { repayBeginDate, repayEndDate };
};

/**
 * 格式化金额,如 123456 =》 123,467.00
 * * @param {Number} num 金额
 */
export const formatToThousands = (num, n = 2) => {
  if (isNaN(num) || +num === 0) {
    num = 0;
    return parseFloat(num).toFixed(n);
  }
  return `${num.toFixed(n)}`.replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
};

/**
 * 创建表单域，适用于 Filter 组件的 mapPropsToFields 中
 * @param {Object} form 表单对象
 */
export const createFilterField = (formData) => {
  return Object.keys(formData).reduce((pre, next) => {
    return {
      ...pre,
      [next]: Form.createFormField({ value: formData[next] }),
    };
  }, {});
};

/**
 * 获取过期时间
 * @param timestamp
 * @returns {number}
 */
export const getExpireTime = (timestamp) => {
  return new Date().getTime() + timestamp * 1000;
};

/**
 * 判断时间戳是否过期
 *
 * @param time
 * @returns {boolean}
 */
export const isExpired = (time) => {
  if (!time) return true;
  return time < new Date().getTime();
};

/**
 * 浮点数加法计算, 避免精度丢失的问题
 * @param a
 * @param b
 * @returns {number}
 */
export const add = (a, b) => {
  function initNumber(args) {
    let num = parseFloat(args, 10);
    return isNaN(num) ? 0 : num;
  }

  function getFloatLength(numStr) {
    const numArr = numStr.split('.');
    if (numArr.length !== 2) return 0;
    return numArr[1].length;
  }

  function scaleMultiple(length1, length2) {
    const length = length1 > length2 ? length1 : length2;
    return 10 ** length;
  }
  const numA = initNumber(a);
  const numB = initNumber(b);
  const scale = scaleMultiple(getFloatLength(numA.toString()), getFloatLength(numB.toString()));
  return (numA * scale + numB * scale) / scale;
};

/**
 * 浮点数减法计算, 避免精度丢失的问题
 * @param a
 * @param b
 * @returns {number}
 */
export const sub = (a, b) => {
  function initNumber(args) {
    let num = parseFloat(args, 10);
    return isNaN(num) ? 0 : num;
  }

  function getFloatLength(numStr) {
    const numArr = numStr.split('.');
    if (numArr.length !== 2) return 0;
    return numArr[1].length;
  }

  function scaleMultiple(length1, length2) {
    const length = length1 > length2 ? length1 : length2;
    return 10 ** length;
  }
  const numA = initNumber(a);
  const numB = initNumber(b);
  const scale = scaleMultiple(getFloatLength(numA.toString()), getFloatLength(numB.toString()));
  return (numA * scale - numB * scale) / scale;
};

export const renderHtml = (string) => {
  if (!string) return string;
  /* eslint-disable react/no-danger */
  return <div dangerouslySetInnerHTML={{ __html: string.replace(/\n/g, '<br/>') }} />;
};

export const findDiffProperty = (obj, target) => {
  return Object.keys(obj).find(key => obj[key] !== target[key]);
};


export const mapRowKey = (payload, sourceKey = 'dataSource', pageKey = 'current') => {
  if (!payload[sourceKey]) return payload;
  const { pageSize } = payload;
  const current = payload[pageKey];
  const startId = (current - 1) * pageSize;
  payload[sourceKey] = payload[sourceKey].map((item, index) => {
    if (item.id) {
      item.index = startId + index + 1;
    } else {
      item.id = startId + index + 1;
    }
    return item;
  });
  return payload;
};

// 格式化银行列表数据
export const mapBankList = (bankList) => {

  const Options = map(bankList, (item, index) => {
    return <Option key={index}>{item.node.bank_name}</Option>;
  });
  return Options;
};

export const processBillingRules = (rules) => {
  rules = compact(rules); // 去掉数组中的空项
  rules = rules.map((rule) => ({
    ...rule,
    price: formatDecimal(rule.price * 100, 0), // 转换规则，使用分作单位
    scale: TimeToScales[rule.time],
    time: rule.time,
  }));
  return JSON.stringify(rules);
};

export const processBillingRulesWithPre = (rules) => {
  delete rules[''];
  rules.prepaid = formatDecimal(rules.prepaid * 100, 0);
  rules.maxMoney = formatDecimal(rules.maxMoney * 100, 0);
  rules.minMoney = formatDecimal(rules.minMoney * 100, 0);
  rules.price = formatDecimal(rules.price * 100, 0);
  rules.minMinutes = formatDecimal(rules.minMinutes * 60, 0);
  rules.stepMinutes = formatDecimal(rules.stepMinutes * 60, 0);
  return JSON.stringify(rules);
};

export const isEditDeviceSuccess = (result) => {
  const {
    activeSn,
    notExistSn,
    otherMchSn,
    success,
    noFirstMch,
    unknownSn,
  } = result;
  return (success.length > 0 && activeSn.length === 0 && notExistSn.length === 0 && otherMchSn.length === 0 && unknownSn.length === 0 && noFirstMch.length === 0);
};

export const mapIndustryKey = (value, industry) => {
  let index = 0;
  for (let key in industry) {
    if (industry[key] === value) index = value;
  }
  return index;
};

export const parseString = (taskContent) => {
  if (taskContent && typeof taskContent === 'string') {
    return JSON.parse(taskContent);
  }
};

export const setkey = (obj) => {
  if (obj) {
    obj.forEach((item) => {
      let taskContent = JSON.parse(item.taskContent);
      item.snList = taskContent.snList;
      item.mchName = taskContent.mchName;
    });
  }
  return obj;
};

/**
 * @param {time} 注册时间
 * @returns selectArray
 */
export const downloadMonthSelect = (time) => {
  const nowTime = monthFormat(moment().subtract('month'));
  const registerTime = monthFormat(time);
  const date1 = Number(nowTime.split('-')[0]) * 12 + Number(nowTime.split('-')[1]);
  const date2 = Number(registerTime.split('-')[0]) * 12 + Number(registerTime.split('-')[1]);
  const m = Math.abs(date1 - date2);
  const startMonth = Number(registerTime.split('-')[1]);
  let selectArray = [];
  for (let index = 0; index <= m; index++) {
    selectArray.push({ id: index, month: monthFormatChina(moment(registerTime, 'YYYY年MM月').set('month', startMonth + index - 1)) });
  }
  return selectArray.reverse();
};

//downloadMonthSelect(moment().subtract(50, 'month'));

const _transformCityList = (cityList) => {
  let result = [];
  cityList.map((val) => {
    let tmp = {
      city_code: val.city_code,
      city_name: val.city_name,
    };
    tmp.value = `${val.city_code}&${val.city_name}`;
    tmp.label = val.city_name;
    val.children && (tmp.children = _transformCityList(val.children));
    result.push(tmp);
    return null;
  });
  return result;
};

export const transformCity = (cityList) => {
  if (!cityList) return [];
  return _transformCityList(cityList);
};

const _getCityIndex = (cityList, cityCode, cityName, result, pos) => {
  ++pos;
  let isBreak = false;
  for (let i = 0, len = cityList.length; i < len; i++) {
    result[pos] = i;
    let val = cityList[i];
    if (val.city_code === cityCode && cityName.indexOf(val.city_name) > -1) {
      isBreak = true;
      break;
    }
    if (val.children) {
      isBreak = _getCityIndex(val.children, cityCode, cityName, result, pos);
      if (isBreak) break;
    }
  }
  return isBreak;
};

function generateCityLabel(cityList, posArr) {
  let arr = cityList;
  let tmp;
  return posArr.map(val => {
    tmp = arr[val];
    tmp.children && (arr = tmp.children);
    return `${tmp.city_code}&${tmp.city_name}`;
  });
}

export function getCityIndex(cityList, cityCode, cityName) {
  if (!cityList || !Array.isArray(cityList) || !cityCode) return;
  let result = [];
  let pos = -1;
  _getCityIndex(cityList, cityCode, cityName, result, pos);
  return generateCityLabel(cityList, result);
}

export function formatBankCode(code) {
  if (!code) return '';
  let codeArr = code.split('');
  let length = codeArr.length;
  let result = [];
  codeArr.concat().map((val, index) => {
    result.push(val);
    if (index < length - 1 && (index + 1) % 4 === 0) {
      result.push(' ');
    }
    return null;
  });
  return result.join('');
}

export function formatMoney(money) {
  money = money ? Number(money) : 0;
  return Number(money.toFixed(2));
}

export function formatWithdrawalState(status) {
  let result = 0;
  switch (status) {
    case 3:
      result = 3;
      break;
    case -3:
    case -2:
    case -1:
    case 0:
    case 1:
    case 4:
      result = 1;
      break;
    case 2:
      result = 2;
      break;
    default:
      result = 0;
      break;
  }
  return {
    code: result,
    value: withdrawalState[result],
  };
}

export function formatAgentSelect(list = [], childUseable = false, labelArray) {
  labelArray = labelArray || ['mchName', 'contactUser'];
  return list.map((item) => {
    let label = labelArray.reduce((total, labelItem) => {
      return `${total} ${item[labelItem]}`;
    }, '');
    // isLeaf 为true是最后一个节点，没有下级
    let isLeaf = !(childUseable || item.level === 4) || (item.mchType === 1);
    return {
      value: item.mchId,
      label,
      isLeaf,
      mchType: item.mchType,
      useable: true,
      level: item.level,
      data: item,
    };
  });
}

export function formatSelectMchId(data, key, toArray = true) {
  let tmp = '';
  if (data[key]) {
    !Array.isArray(data[key]) && (data[key] = [data[key]]);
    let mchId = data[key][data[key].length - 1];
    if (mchId === '') {
      tmp = data[key][data[key].length - 2];
      data[key] = toArray ? [tmp] : tmp;
    } else if (!mchId || mchId < 10) {
      delete data[key];
    } else {
      data[key] = toArray ? [mchId] : mchId;
    }
  } else {
    delete data[key];
  }
}

export function getFailDevice(deviceList, key = 'result') {
  return deviceList.filter(device => {
    return !device[key];
  });
}

export function formatMinLength(seconds) {
  seconds = Number(seconds);
  const hour = parseInt(seconds / 3600, 0);
  const minute = parseInt((seconds % 3600) / 60, 0);
  const second = parseInt((seconds % 3600) % 60, 0);
  return `${hour}小时${minute}分${second}秒`;
}

/**
 * 下载文件时截取文件名
 * @param {String} link 下载链接
 */
export function getDownloadFileName(link) {
  let match = link.match(/.+\/(.+\.xlsx)\?.*/);
  return match[1];
}

export function formatAgentType(agentType, level) {
  let result = '';
  if (agentType === 0) {
    result = level ? allAgentLevelTypes[level] : '';
  } else if (agentType === 1) {
    result = bizTypes[level];
  }
  return result || '';
}

export function checkIsTypeChain(mchData) {
  return mchData.mchType === 0 && mchData.level === 4;
}

export function checkIsTypeChainStore(mchData) {
  return mchData.mchType === 1 && mchData.level === 1;
}

export function bizFilter(item, hasAuth) {
  return (hasAuth && item.mchType === 0) || item.mchType === 1 || checkIsTypeChain(item);
}

/**
 *  返回值为null时，清空列表
 * @param {*} payload
 */
export function formatEmptyListData(payload) {
  const { status, result } = payload;
  const defaultData = {
    dataSource: [],
    total: 0,
    pageSize: 15,
    current: 1,
    originalData: null,
  };
  if (status === 'success' && result === null) {
    payload = {
      ...payload,
      ...defaultData,
    };
  }
  return payload;
}

/**
 * 使用统一的分隔符分离sn输入
 */
export function splitSnInput(snInput) {
  if (!snInput) return [];
  return snInput.split(SN_INPUT_SPLIT_REG).filter(val => {
    return !!val;
  });
}

export function formatIndustyToOptions(industry) {
  if (!industry) return [];
  return industry.map(val => {
    return { label: val.industry, value: val.industry };
  });
}
// export function renderGroupPrice(text) {
//   if (!text) return '';
//   const { time, service } = JSON.parse(text || '{}');
//   return `${service}元/${time / 60}小时`;
// }

export function renderGroupPrice(text) {
  if (!text) return '';
  const { time, price } = JSON.parse(text || '[{}]')[0];
  return `${price / 100}元/${time / 60}小时`;
}

export function renderAddress(text, record) {
  const area = record.area ? `${record.province} ${record.city} ${record.area}` : '';
  return text ? area + text : area;
}


export function formatGroupListToRadio(groupList) {
  if (!groupList || !Array.isArray(groupList)) return [];
  return groupList.map(val => {
    return {
      label: val.groupName,
      value: val.groupId,
    };
  });
}

export function getPriceFromService(service) {
  if (!service) return '';
  let current = JSON.parse(service);
  let price = '';
  if (Array.isArray(current) && current[0]) {
    price = current[0].price / 100;
  }
  return price;
}

export function formatBankId(bankId, record) {
  return record.isPublic === 2 ? '微信零钱' : bankId;
}

export function renderAdLocation(locationList) {
  if (!locationList || !Array.isArray(locationList)) return '';
  return (<div
    style={{
      display: '-webkit-box',
      WebkitBoxOrient: 'vertical',
      WebkitLineClamp: '3',
      overflow: 'hidden',
    }}
  >
    {
      locationList.map((val) => {
        const { province, city, area } = val;
        return (<Tag key={`${province}${city}${area}`}>
          {`${province || '全国'} / ${city || '全部城市'} / ${area || '全部区域'}`}
        </Tag>);
      })
    }
  </div>);
}

export function renderAdPlace(posList, posArr) {
  if (!posArr) { return ''; }
  let result = posArr.map((pos) => {
    let label = '';
    posList.forEach(element => {
      if (element.value === pos.showPage) {
        label = element.label;
        return false;
      }
    });
    return label;
  });
  return result.join('，');
}

/**
 * 枚举类型的值生成单选项
 * @param {*} enumType
 */
export function mapObjectToRadioItem(enumType) {
  return mapObjectToRadios(enumType).map(item => {
    return <Radio key={item.value} value={item.value}>{item.label}</Radio>;
  });
}

/**
 * 添加代理层级数据
 * @param {*} dataSource
 */
export function addAgentList(dataSource) {
  let { lstParents } = dataSource || {};
  if (lstParents) {
    lstParents.forEach((agent) => {
      dataSource[`myAgentLevel${agent.level}`] = `${agent.mchName} ${agent.contactUser} ${agent.mchId}`;
    });
  }
  return dataSource;
}


/**
 * 是否是平台账号
 * @param {*} profile
 */
export function checkIsSuperAdmin(profile, roleType) {
  let isRole = (typeof roleType === 'number') ? profile.roleType === roleType : false;
  return profile.mchType === 2 && (profile.roleType <= 1 || isRole);
}

export function getDocType(pathname) {
  let docType = /\/doc\/(biz|app|pc)/.exec(pathname);
  docType = docType ? docType[1] : 'pc';
  return docType;
}
