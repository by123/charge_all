const routes = {
  pc: {
    introduce: '/doc/pc/introduce/',
    login: '/doc/pc/login/',
    agent: '/doc/pc/agent/',
    device: '/doc/pc/device/',
    order: '/doc/pc/order/',
    salesman: '/doc/pc/salesman/',
    withdrawal: '/doc/pc/withdrawal/',
    reportCenter: '/doc/pc/reportCenter/',
    account: '/doc/pc/account/',
  },

  app: {
    download: '/doc/app/download/',
    home: '/doc/app/home/',
    login: '/doc/app/login/',
    account: '/doc/app/account/',
    order: '/doc/app/order/',
  },

  biz: {
    introduce: '/doc/biz/introduce/',
    order: '/doc/biz/order/',
  },
};

const pcMenu = [
  {
    id: 1,
    name: '1，简介',
    router: routes.pc.introduce,
  },
  {
    id: 101,
    name: '1.1，系统角色介绍',
    bpid: 1,
    mpid: 1,
    router: routes.pc.introduce,
  },
  {
    id: 102,
    name: '1.2，代理商工作流',
    bpid: 1,
    mpid: 1,
    router: routes.pc.introduce,
  },

  {
    id: 2,
    name: '2.1，账号登录',
    router: routes.pc.login,
  },
  {
    id: 201,
    name: '2.1.1，系统登录',
    bpid: 2,
    mpid: 2,
    router: routes.pc.login,
  },
  {
    id: 202,
    name: '2.1.2，使用账户密码登入',
    bpid: 2,
    mpid: 2,
    router: routes.pc.login,
  },

  {
    id: 3,
    name: '2.2，代理商管理',
    router: routes.pc.agent,
  },
  {
    id: 301,
    name: '2.2.1，添加子代理商',
    bpid: 3,
    mpid: 3,
    router: routes.pc.agent,
  },
  {
    id: 302,
    name: '2.2.2，添加连锁门店',
    bpid: 3,
    mpid: 3,
    router: routes.pc.agent,
  },
  {
    id: 303,
    name: '2.2.3，添加商户',
    bpid: 3,
    mpid: 3,
    router: routes.pc.agent,
  },
  {
    id: 304,
    name: '2.2.4，代理商管理',
    bpid: 3,
    mpid: 3,
    router: routes.pc.agent,
  },

  {
    id: 4,
    name: '2.3，设备管理',
    router: routes.pc.device,
  },
  {
    id: 401,
    name: '2.3.1，设备分配至子代理商',
    bpid: 4,
    mpid: 4,
    router: routes.pc.device,
  },
  {
    id: 402,
    name: '2.3.2，设备激活至商户',
    bpid: 4,
    mpid: 4,
    router: routes.pc.device,
  },
  {
    id: 403,
    name: '2.3.3，编辑计费规则',
    bpid: 4,
    mpid: 4,
    router: routes.pc.device,
  },
  {
    id: 404,
    name: '2.3.4，设备查看与编辑，批量操作',
    bpid: 4,
    mpid: 4,
    router: routes.pc.device,
  },
  {
    id: 405,
    name: '2.3.5，设备解绑',
    bpid: 4,
    mpid: 4,
    router: routes.pc.device,
  },
  {
    id: 406,
    name: '2.3.6，设备转移',
    bpid: 4,
    mpid: 4,
    router: routes.pc.device,
  },

  {
    id: 5,
    name: '2.4，订单管理',
    router: routes.pc.order,
  },
  {
    id: 501,
    name: '2.4.1，查看订单，搜索订单',
    bpid: 5,
    mpid: 5,
    router: routes.pc.order,
  },
  {
    id: 502,
    name: '2.4.2，订单退款',
    bpid: 5,
    mpid: 5,
    router: routes.pc.order,
  },

  {
    id: 6,
    name: '2.5，业务员管理',
    router: routes.pc.salesman,
  },
  {
    id: 601,
    name: '2.5.1，添加业务员',
    bpid: 6,
    mpid: 6,
    router: routes.pc.salesman,
  },
  {
    id: 602,
    name: '2.5.2，查看业务员资料',
    bpid: 6,
    mpid: 6,
    router: routes.pc.salesman,
  },

  {
    id: 7,
    name: '2.6，资金提现',
    router: routes.pc.withdrawal,
  },
  {
    id: 701,
    name: '2.6.1，查看资金与收入情况',
    bpid: 7,
    mpid: 7,
    router: routes.pc.withdrawal,
  },
  {
    id: 702,
    name: '2.6.2，申请提现',
    bpid: 7,
    mpid: 7,
    router: routes.pc.withdrawal,
  },

  {
    id: 8,
    name: '2.7，报表中心',
    router: routes.pc.reportCenter,
  },
  {
    id: 801,
    name: '2.7.1，渠道设备使用率与收益',
    bpid: 8,
    mpid: 8,
    router: routes.pc.reportCenter,
  },

  {
    id: 9,
    name: '2.8，账户管理',
    router: routes.pc.account,
  },
  {
    id: 901,
    name: '2.8.1，账户信息',
    bpid: 9,
    mpid: 9,
    router: routes.pc.account,
  },
  {
    id: 902,
    name: '2.8.2，银行卡信息',
    bpid: 9,
    mpid: 9,
    router: routes.pc.account,
  },
  {
    id: 903,
    name: '2.8.3，修改账号密码',
    bpid: 9,
    mpid: 9,
    router: routes.pc.account,
  },
];

const appMenu = [
  {
    id: 1,
    name: '1.1，下载炭电-代理商版App',
    router: routes.app.download,
  },
  {
    id: 101,
    name: '1.1.1，扫码下载',
    bpid: 1,
    mpid: 1,
    router: routes.app.download,
  },
  {
    id: 102,
    name: '1.1.2，应用市场下载',
    bpid: 1,
    mpid: 1,
    router: routes.app.download,
  },

  {
    id: 2,
    name: '1.2，用户登录',
    router: routes.app.login,
  },
  {
    id: 201,
    name: '1.2.1，用户登录炭电-代理商版App',
    bpid: 2,
    mpid: 3,
    router: routes.app.login,
  },
  {
    id: 202,
    name: '1.2.2，忘记密码',
    bpid: 2,
    mpid: 2,
    router: routes.app.login,
  },

  {
    id: 3,
    name: '1.3，APP首页',
    router: routes.app.home,
  },
  {
    id: 301,
    name: '1.3.1，添加代理商',
    bpid: 3,
    mpid: 3,
    router: routes.app.home,
  },
  {
    id: 302,
    name: '1.3.2，添加商户与绑定商户',
    bpid: 3,
    mpid: 3,
    router: routes.app.home,
  },
  {
    id: 303,
    name: '1.3.3，添加业务员',
    bpid: 3,
    mpid: 3,
    router: routes.app.home,
  },
  {
    id: 304,
    name: '1.3.4，激活设备',
    bpid: 3,
    mpid: 3,
    router: routes.app.home,
  },
  {
    id: 305,
    name: '1.3.5，添加连锁门店',
    bpid: 3,
    mpid: 3,
    router: routes.app.home,
  },
  {
    id: 306,
    name: '1.3.6，设备密码重置',
    bpid: 3,
    mpid: 3,
    router: routes.app.home,
  },

  {
    id: 4,
    name: '1.4，收益和订单',
    router: routes.app.order,
  },

  {
    id: 5,
    name: '1.5，账户信息',
    router: routes.app.account,
  },
  {
    id: 501,
    name: '1.5.1，我的账户信息',
    bpid: 5,
    mpid: 5,
    router: routes.app.account,
  },
  {
    id: 502,
    name: '1.5.2，银行卡信息',
    bpid: 5,
    mpid: 5,
    router: routes.app.account,
  },
  {
    id: 503,
    name: '1.5.3，代理商管理',
    bpid: 5,
    mpid: 5,
    router: routes.app.account,
  },
  {
    id: 504,
    name: '1.5.4，设备解绑',
    bpid: 5,
    mpid: 5,
    router: routes.app.account,
  },
  {
    id: 505,
    name: '1.5.5，充电白名单',
    bpid: 5,
    mpid: 5,
    router: routes.app.account,
  },
  {
    id: 506,
    name: '1.5.6，APP设置',
    bpid: 5,
    mpid: 5,
    router: routes.app.account,
  },
];

const bizMenu = [
  {
    id: 1,
    name: '1，关注炭电公众号',
    router: routes.biz.introduce,
  },

  {
    id: 2,
    name: '2，绑定成功',
    router: routes.biz.order,
  },
  {
    id: 201,
    name: '2.1，资金管理',
    bpid: 2,
    mpid: 2,
    router: routes.biz.order,
  },
  {
    id: 202,
    name: '2.2，订单管理',
    bpid: 2,
    mpid: 2,
    router: routes.biz.order,
  },
  {
    id: 203,
    name: '2.3，账户信息',
    bpid: 2,
    mpid: 2,
    router: routes.biz.order,
  },
  {
    id: 204,
    name: '2.4，银行卡信息',
    bpid: 2,
    mpid: 2,
    router: routes.biz.order,
  },
  {
    id: 205,
    name: '2.5，激活设备',
    bpid: 2,
    mpid: 2,
    router: routes.biz.order,
  },
  {
    id: 206,
    name: '2.6，设备密码重置',
    bpid: 2,
    mpid: 2,
    router: routes.biz.order,
  },
];


export { pcMenu, appMenu, bizMenu, routes };
export default {
  pcMenu,
  bizMenu,
  appMenu,
};
