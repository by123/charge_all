export const deviceStatus = {
  0: '未投放',
  1: '未激活',
  2: '已激活',
};

// 提现状态
export const withdrawalStatus = {
  0: '提现中',
  1: '提现成功',
  2: '提现失败',
  3: '可提现',
  4: '不可提现',
};

// 订单状态
export const orderStatus = {
  "-1": '全部',
  "1": '未支付',
  "2": '已支付',
  "3": '已完成',
  "4": '已取消',
  "5": '退款中',
  "6": '已退款'
};

export const TOKEN_KEY = 'bearer-token';

export const refundStatus = {
  0: '未返还',
  1: '已返还',
};

// 押金退款状态
export const depositRefundStatus = {
  0: '未发起退款',
  1: '退款中',
  2: '退款成功',
  3: '退款失败',
};

export const payTypeObj = {
  0: '微信支付',
  1: '支付宝支付',
};

export const CANCEL = 'cancel';
export const REFUND = 'refund';
export const DEPOSIT = 'deposit';

export const orderBtnType = {
  [CANCEL]: {
    name: '取消',
    value: 'cancel',
  },
  [REFUND]: {
    name: '退款',
    value: 'refund',
  },
  [DEPOSIT]: {
    name: '退押金',
    value: 'deposit',
  },
}

export const industries = {
  0: '宾馆/经济连锁酒店',
  1: '星级酒店',
  2: '中餐／茶馆',
  3: '西餐咖啡厅',
  4: '酒吧/KTV',
  5: '电影院',
  6: '洗浴/会所',
  7: '足疗按摩',
  8: '棋牌室',
  9: '网吧网咖',
  10: '美容行业',
  11: '培训机构',
  12: '医院',
  13: '综合商场',
  14: '其它',
};

export const phoneNumber = '‭4008818319';

export const withdrawalTypes = {
  '-3': '审核不通过',
  '-2': '挂起',
  '-1': '待审核',
  '0': '审核通过',
  '1': '提现中',
  '2': '提现成功',
  '3': '提现失败',
  '4': '需要人工确认',
};

export const withdrawalState = {
  '0': '申请成功',
  '1': '提现中',
  '2': '提现完成',
  '3': '提现失败',
};

export const bankCardType = {
  0: '个人账户',
  1: '对公账户',
  2: '微信钱包',
};

export const WITHDRAWAL_TYPE = 'withdrawal_type';
