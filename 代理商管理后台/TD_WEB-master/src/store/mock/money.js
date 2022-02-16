
export const moneyInfo = {
  balance: 45687,
  available: 45621,
  historyTotal: 100980,
  freeze: 4000,
};

export const moneyBalanceList = {
  totalCount: 100,
  pageSize: 10,
  pageId: 1,
  'rows|10': [{
    'orderId|+1': 0,
    a: '@datetime("T")',
    b: '@string',
    c: '@string',
    d: '@float(0, 1000, 0, 2)',
    e: /(4)|(5)/,
  }],
};

export const moneyWithdrawalList = {
  totalCount: 100,
  pageSize: 10,
  pageId: 1,
  'rows|10': [{
    'orderId|+1': 0,
    a: '@datetime("T")',
    b: '@string',
    c: '@float(0, 100000, 0, 2)',
    d: '@float(0, 100000, 0, 2)',
    e: /(0)|(1)|(2)|(4)|(5)/,
    f: '@datetime("T")',
  }],
};

export const moneyAccount = {
  name: '@string',
  account: '@string',
  bank: '测试银行',
  handlingFee: 3,
  balance: 10002,
};

