const playgroundItem = {
  id: 0,
  mpid: -1,
  icon: 'laptop',
  name: 'playground',
  router: '/playground',
};

const dashboradItem = {
  id: 1,
  icon: 'home',
  name: '首页',
  router: '/',
};

const agentItem = {
  id: 2,
  icon: 'appstore',
  name: '代理商管理',
  router: '/agent',
};

const deviceItem = [
  {
    id: 3,
    icon: 'api',
    name: '设备管理',
  },
  {
    id: 31,
    name: '设备列表',
    bpid: 3,
    mpid: 3,
    router: '/device',
  },
  {
    id: 33,
    name: '设备分配至子代理',
    bpid: 3,
    mpid: 3,
    router: '/device/bindAgent',
  },
  {
    id: 35,
    name: '设备激活至商户',
    bpid: 3,
    mpid: 3,
    router: '/device/bindBusiness',
  },
  {
    id: 34,
    name: '编辑计费规则',
    bpid: 3,
    mpid: 3,
    router: '/device/editBilling',
  },
  {
    id: 36,
    name: '设备解绑',
    bpid: 3,
    mpid: 3,
    router: '/device/untie',
  },
  {
    id: 37,
    name: '设备转移',
    bpid: 3,
    mpid: 3,
    router: '/device/transfer',
  },
];

const orderItem = {
  id: 4,
  icon: 'profile',
  name: '订单管理',
  router: '/order',
};

const personalItem = {
  id: 5,
  icon: 'contacts',
  name: '业务员管理',
  router: '/personnel',
};

const moneyItem = {
  id: 6,
  icon: 'property-safety',
  name: '资金管理',
  router: '/money',
};

const accountItem = {
  id: 7,
  icon: 'lock',
  name: '账户管理',
  router: '/account',
};

const initMenuItem = {
  id: 8,
  icon: 'mobile',
  name: '设备出厂',
  router: '/initialize',
};

const initMenuListItem = [
  {
    id: 8,
    icon: 'mobile',
    name: '设备出厂',
  },
  {
    id: 81,
    name: '设备出厂',
    bpid: 8,
    mpid: 8,
    router: '/initialize',
  },
  {
    id: 82,
    name: '生产统计',
    bpid: 8,
    mpid: 8,
    router: '/initialize/productionLogin',
  },
  {
    id: 83,
    name: 'SN号管理',
    bpid: 8,
    mpid: 8,
    router: '/initialize/snConfig',
  },
  {
    id: 84,
    name: '设备调拨',
    bpid: 8,
    mpid: 8,
    router: '/initialize/deviceAllocate',
  },
  {
    id: 85,
    name: '设备返厂管理',
    bpid: 8,
    mpid: 8,
    router: '/initialize/deviceRecall',
  },
];

const statisticMenu = [{
  id: 8,
  name: '生产统计',
  icon: 'mobile',
  router: '/initialize/productionLogin',
}];

const financeCenterItem = [{
  id: 10,
  icon: 'bank',
  name: '财务中心',
}, {
  id: 101,
  name: '提现记录',
  bpid: 10,
  mpid: 10,
  router: '/financeCenter',
}, {
  id: 102,
  name: '提现管理',
  bpid: 10,
  mpid: 10,
  router: '/financeCenter/withdrawalManage',
}, {
  id: 103,
  name: '月度对账',
  bpid: 10,
  mpid: 10,
  router: '/financeCenter/financeBill',
}];

const reportCenterItem = [
  {
    id: 11,
    icon: 'book',
    name: '报表中心',
  },
  {
    id: 111,
    name: '渠道收益',
    bpid: 11,
    mpid: 11,
    router: '/reportCenter',
  },
  {
    id: 112,
    name: '设备激活',
    bpid: 11,
    mpid: 11,
    router: '/reportCenter/device',
  },
];

const serviceCenterItem = [
  {
    id: 12,
    icon: 'alert',
    name: '客服中心',
  },
  {
    id: 121,
    name: '400电话处理',
    bpid: 12,
    mpid: 12,
    router: '/serviceCenter/phoneResolveRecord',
  },
  {
    id: 122,
    name: '投诉留言',
    bpid: 12,
    mpid: 12,
    router: '/serviceCenter',
  },
];

const adMenu = [
  {
    id: 15,
    icon: 'fund',
    name: '广告管理',
    router: '/operationCenter/adManage',
  },
];

const operationCenterItem = [
  {
    id: 13,
    icon: 'fund',
    name: '运营中心',
  },
  {
    id: 131,
    name: '商户微信解绑',
    bpid: 13,
    mpid: 13,
    router: '/operationCenter',
  },
  // {
  //   id: 132,
  //   name: '账号权限管理',
  //   bpid: 13,
  //   mpid: 13,
  //   router: '/operationCenter/permission',
  // },
  {
    id: 133,
    name: '广告管理',
    bpid: 13,
    mpid: 13,
    router: '/operationCenter/adManage',
  },
  {
    id: 134,
    name: '消息管理',
    bpid: 13,
    mpid: 13,
    router: '/operationCenter/notice',
  },
];

const taxiItem = [
  {
    id: 14,
    icon: 'car',
    name: '出租车业务',
  },
  {
    id: 141,
    name: '分组管理',
    bpid: 14,
    mpid: 14,
    router: '/taxi/group/groupManage',
  },
  {
    id: 142,
    name: '出租车设备',
    bpid: 14,
    mpid: 14,
    router: '/taxi/device',
  },
  {
    id: 143,
    name: '出租车订单',
    bpid: 14,
    mpid: 14,
    router: '/taxi/order',
  },
  {
    id: 144,
    name: '添加设备至分组',
    bpid: 14,
    mpid: 14,
    router: '/taxi/device/addToGroup',
  },
  {
    id: 145,
    name: '设备解绑',
    bpid: 14,
    mpid: 14,
    router: '/taxi/device/transfer/untie',
  },
  {
    id: 146,
    name: '设备更换分组',
    bpid: 14,
    mpid: 14,
    router: '/taxi/device/transfer/changeGroup',
  },
  {
    id: 147,
    name: '售后换线',
    bpid: 14,
    mpid: 14,
    router: '/taxi/afterSales',
  },
];

const normalMenu = [
  playgroundItem,
  dashboradItem,
  agentItem,
  ...deviceItem,
  orderItem,
  personalItem,
  moneyItem,
  ...reportCenterItem,
  accountItem,
];

// 业务员菜单 不包含 人员信息 和 资金管理
const userMenu = normalMenu.filter(item => item.id !== 5 && item.id !== 6);

// 平台账户菜单
let superMenu = normalMenu.concat();
superMenu.splice(2, 0, ...initMenuListItem);
superMenu.splice(superMenu.length - 1, 0, ...financeCenterItem, ...serviceCenterItem, ...operationCenterItem);

// test
// superMenu.splice(2, 0, ...taxiItem);
// normalMenu.splice(2, 0, ...taxiItem);

// 平台账户下业务员菜单
let superUserMenu = userMenu.concat();
superUserMenu.splice(2, 0, initMenuItem);
superUserMenu.splice(superMenu.length - 1, 0, ...financeCenterItem);
// superUserMenu.splice(superMenu.length - 1, 0, ...serviceCenterItem);

// 客服人员菜单
const serviceMenu = [orderItem, ...serviceCenterItem];

// 仓库人员菜单
const factoryMenu = initMenuListItem;

// 财务人员菜单 代理商管理，订单管理，资金管理，报表中心，财务中心
const financeMenu = [agentItem, orderItem, moneyItem, ...reportCenterItem, ...financeCenterItem];

export {
  superMenu,
  normalMenu,
  userMenu,
  superUserMenu,
  serviceMenu,
  factoryMenu,
  financeMenu,
  statisticMenu,
  taxiItem,
  adMenu,
};
