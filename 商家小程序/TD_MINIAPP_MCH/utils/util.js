import {
  orderStatus,
  refundStatus,
  orderBtnType,
  CANCEL,
  DEPOSIT,
  REFUND,
  phoneNumber,
  withdrawalState,
} from './enum';
import {
  API_HOST,
} from '../config/config.js';

export const formatTime = (date, hasHour = true, hasSec = false) => {
  if (!date) return '';
  if (!(date instanceof Date)) {
    date = new Date(date);
  }
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours()
  const minute = date.getMinutes()
  const second = date.getSeconds()

  let time = [year, month, day].map(formatNumber).join('-');
  if (hasHour) {
    time += ' ' + [hour, minute].map(formatNumber).join(':');
  }
  if (hasSec) {
    time += ':' + formatNumber(second);
  }
  return time;
}

export const dateFormatter = (date, fmt) => {
  if (!(date instanceof Date)) {
    date = new Date(date);
  }
  var o = {
    "M+": date.getMonth() + 1, //月份 
    "d+": date.getDate(), //日 
    "h+": date.getHours(), //小时 
    "m+": date.getMinutes(), //分 
    "s+": date.getSeconds(), //秒 
    "q+": Math.floor((date.getMonth() + 3) / 3), //季度 
    "S": date.getMilliseconds() //毫秒 
  };
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
  }
  for (var k in o) {
    if (new RegExp("(" + k + ")").test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    }
  }
  return fmt;
}

export const getNextDay = (startDate) => {
  if (!startDate) return '';
  if (!(startDate instanceof Date)) {
    startDate = new Date(startDate);
  }
  return dateFormatter(new Date(startDate.getTime() + 24 * 60 * 60 * 1000), 'yyyy-MM-dd');
}

export const formatNumber = n => {
  n = n.toString()
  return n[1] ? n : '0' + n
}

export const getStorageItem = key => {
  try {
    return wx.getStorageSync(key);
  } catch (e) {
    console.log(`get ${key} form storage error: `, e);
    return null;
  }
}

export const setStorageItem = (key, data) => {
  wx.setStorageSync(key, data);
}

export const removeStorageItem = key => {
  wx.removeStorageSync(key);
}

export const moneyAddPre = (money, precision = 2) => {
  money = Number(money).toFixed(precision);
  return money >= 0 ? '￥' + money : '-￥' + Math.abs(money).toFixed(precision);
}

export const formatMoney = (num,  n = 2) => {
  if (isNaN(num) || +num === 0) num = 0;
  return parseFloat(num).toFixed(n);
}

// 收益明细列表
export function formatOrderData(order) {

  const formatItem = (item, index) => {
    let orderState = item.orderStateWeb;
    let {
      orderContent,
    } = formatOrderItem(item, orderState);

    return {
      orderData: {
        orderId: item.orderId,
        content: [
          [{
            name: formatTime(item.createTime, true, true),
            value: orderStatus[orderState],
          }],
          [{
            name: '订单编号',
            value: item.orderId,
          },
          {
            name: '设备编号',
            value: item.deviceSn,
          },
          ],
          orderContent,
        ]
      },
      profit: item.myProfit || 0,
      hasRefund: (orderState === 3 || orderState === 2) && item.canRefund,
    }
  };

  return order.map(formatItem);
}

function formatOrderItem(item, status) {
  let orderContent = [];

  let finishContent = [{
    name: `订单金额：${item.orderPriceYuan || 0}元`,
  },
  {
    name: `押金：${item.depositPriceYuan || 0}元 （${formatDepositStatus(item.orderStateWeb)}）`,
  },
  ];

  let refundContent = [{
    name: `退款金额：${item.refundMoneyYuan || 0}元`,
  }];

  let cancelContent = [{
    name: `待支付金额：${item.orderPriceYuan || 0}元`,
  }];

  switch (status) {
    case 1:
      orderContent = cancelContent;
      break;
    case 2:
      orderContent = finishContent;
      break;
    case 3:
      orderContent = finishContent;
      break;
    case 4:
      orderContent = cancelContent;
      break;
    case 5:
    case 6:
      orderContent = refundContent;
      break;
  }
  return {
    orderContent,
  }
}

// 提现明细列表
export function formatWithdrawal(order) {
  order = order || [];
  const formatItem = (item, index) => {
    let orderState = formatWithdrawalState(item.withdrawState);
    const isWechat = item.isPublic === 2;

    return {
      withdrawId: item.withdrawId,
      key: item.withdrawId,
      orderState: orderState.code,
      content: [
        [{
          name: formatTime(item.createTime, true, true),
          value: orderState.value,
        }],
        [{
          name: isWechat ? '微信昵称' : '账户姓名',
            value: item.accountName,
          },
          {
            name: isWechat ? '提现方式' : '提现卡号',
            value: isWechat ? item.bankName : item.bankId,
          },
          {
            name: '提现金额',
            value: formatMoney(item.withdrawMoneyTotalYuan) + '元',
          },
          {
            name: '手续费',
            value: formatMoney(item.auxiliaryExpensesYuan) + '元',
          },
          {
            name: '实际到账',
            value: formatMoney(item.withdrawMoneyYuan) + '元',
          },
        ],
      ]
    }
  };

  return order.map(formatItem);
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
  }
  return {
    code: result,
    value: withdrawalState[result],
  };
}

export function formatProfit(profitData) {
  if (!profitData || !Array.isArray(profitData)) return [];

  const calProfit = (item) => {
    let {
      profitOrderYuan,
      profitRefundYuan
    } = item;
    return (Number(profitOrderYuan) - Number(profitRefundYuan)).toFixed(2);
  };

  const formatItem = (item, index) => {
    let canWithdrawal = item.canWithDrawDate < (new Date().getTime()) ? '可提现' : '不可提现';
    return {
      orderId: item.orderId,
      content: [
        [{
          name: formatTime(item.profitDate, false),
          value: canWithdrawal,
          customStyle: {
            value: 'font-weight: 600;'
          },
        },],
        [{
          name: '收益金额',
          value: moneyAddPre(calProfit(item)),
        },
        {
          name: '设备分润收入',
          value: moneyAddPre(item.profitOrderYuan),
        },
        {
          name: '退款分润扣除',
          value: moneyAddPre(-(item.profitRefundYuan || 0)),
        },
        {
          name: '预计收益计提时间',
          value: formatTime(item.canWithDrawDate, false)
        }
        ]
      ],
    };
  }
  return profitData.map(formatItem);
};

/**
 * 格式化银行数据以适应下拉选择
 */
export function formatBankData(bankList) {
  const format = bank => {
    return {
      ...bank.node,
      name: bank.node.bank_name
    }
  }
  return bankList.map(format);
};

const _transformCityList = (cityList) => {
  let result = [];
  cityList.map((val) => {
    let tmp = {};
    tmp.value = `${val.city_code || '-1'}&${val.city_name}`;
    tmp.name = val.city_name;
    val.children && (tmp.children = _transformCityList(val.children));
    result.push(tmp);
    return null;
  });
  return result;
};

/**
 * 格式化城市数据
 */
export const formatCityData = (cityList) => {
  if (!cityList) return [];
  return _transformCityList(cityList);
};

/**
 * 显示提示
 * @msg String
 */
export function showMessage(msg, duration = 1500) {
  if (!msg) throw new Error('msg 不能为空');
  wx.hideToast();
  wx.showToast({
    title: msg,
    icon: 'none',
    duration: 1500,
    mask: true,
  });
}

export function getCurrentPageInstance() {
  let pages = getCurrentPages();
  return pages[pages.length - 1];
}

export function getCurrentPagePath() {
  let pages = getCurrentPages();
  return pages[pages.length - 1].route;
}

export function stopPulldownRefresh(isRefresh) {
  isRefresh && wx.stopPullDownRefresh();
}

export function formatDepositStatus(orderState) {
  // console.log(orderState);
  let statusText = '';
  switch (orderState) {
    case 2:
      statusText = '未返还';
      break;
    case 3:
      statusText = '已返还';
      break;
    default:
      break;
  }
  return statusText;
}

export function makePhoneCall(number = phoneNumber) {
  wx.makePhoneCall({
    phoneNumber: number,
  })
}

/**
 * 打开扫码
 */
export function openScanCode() {
  return new Promise((resolve, reject) => {
    wx.scanCode({
      onlyFromCamera: true,
      scanType: 'qrCode',
      success: res => {
        resolve(res);
      },
      fail: err => {
        reject(err);
      },
    });
  });
}

export function vaildateUrl(url) {
  let reg = new RegExp(`^(${API_HOST.split('appserver')[0]})`);
  return reg.test(url);
}

export function formatBankCode(code) {
  let codeArr = code.split('');
  let length = codeArr.length;
  let result = [];
  codeArr.concat().map((val, index) => {
    result.push(val);
    if (index < length - 1 && (index + 1) % 4 === 0) {
      result.push(' ');
    }
  });
  return result.join('');
}

// 从规则中获取起提金额
export function getMoneyStart(rules) {
  let start = -1;
  rules.forEach(rule => {
    if (start === -1) {
      start = rule.withdrawStartNumYuan;
    } else {
      start = Math.min(start, rule.withdrawStartNumYuan);
    }
  });
  return start;
}
