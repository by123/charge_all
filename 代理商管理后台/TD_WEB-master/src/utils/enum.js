import {
  ADD,
  DETAIL,
  EDIT,
  BIZ,
  STORE,
  DEVICE_INIT,
  DEVICE_DOWNLOAD,
  ORDER_DOWNLOAD,
  REPORT_DOWNLOAD,
  DEVICE_ALLOCATE,
  DEVICE_RECALL,
  DEVICE_REPORT_DOWNLOAD,
  CUSTOMER_REPORT,
  AD_TYPE_BOTTOM_BANNER,
  AD_TYPE_PAGE_BG,
  AD_TYPE_TOP_BANNER,
} from './constants';

export const errorHelp = {
  600: 'response 为空，网络连接异常 转化成600',
  601: '请求结果异常，返回的data数据为空',
  500: '网络异常或未知原因，检查网络是否正常，否则可能是前端API代理的问题',
  504: '服务端异常，找后端同学解决',
  404: 'url异常, 请求没有到后端，请检查API前缀是否正确，否则可能是前端API代理的问题',
};

/**
 * 枚举的状态值通常有两种形式
 * 1. 直接把状态转为文字
 * export const productStatus = {
 *  1: '销售中',
 *  0: '已停售',
 * };
 *
 * 2. 带有状态小圆点的文字
 *
 * export const productStatus = {
 *  1: { text: '销售中', status: 'processing' },
 *  0: { text: '已停售', status: 'default' },
 * };
 *
 */

// 订单状态
export const orderStatus = {
  1: '未支付',
  2: '已支付',
  3: '已完成',
  4: '已取消',
  5: '退款中',
  6: '已退款',
};

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

export const agentTypes = {
  0: '代理商',
  1: '商户',
  2: '平台',
};

export const roleTypes = {
  0: '超级管理员',
  1: '普通管理员',
  2: '代理商业务员',
  3: '商户业务员',
  4: '客服业务员',
  5: '仓库业务员',
  6: '财务业务员',
  7: '工厂业务员',
};

export const agentLevelTypes = {
  2: '市代',
  3: '区／县代',
  4: '连锁门店',
};

export const allAgentLevelTypes = {
  1: '省代',
  ...agentLevelTypes,
};

// 添加编辑
export const editText = {
  [ADD]: '添加',
  [EDIT]: '编辑',
  [DETAIL]: '详情',
};

export const deviceTimes = {
  // 5: '5分钟',
  // 30: '30分钟',
  60: '1小时',
  120: '2小时',
  180: '3小时',
  240: '4小时',
  360: '6小时',
  480: '8小时',
  720: '12小时',
  1440: '24小时',
};

export const TimeToScales = {
  5: 0,
  30: 1,
  60: 2,
  120: 3,
  180: 4,
  240: 5,
  360: 6,
  480: 7,
  720: 8,
  1440: 9,
};

export const payTypes = {
  0: '微信支付',
  1: '支付宝支付',
};
export const endTypes = {
  0: '自动结束',
  1: '用户主动结束',
};

export const loginErrCode = {
  91: 'code',
  92: 'account',
  93: 'password',
};

export const industries = {
  0: '宾馆/经济连锁酒店',
  1: '星级酒店',
  2: '网吧网咖',
  3: '足疗按摩',
  4: '洗浴/会所',
  5: '中餐／茶馆',
  6: '酒吧/KTV',
  7: '美容行业',
  8: '棋牌室',
  9: '电影院',
  10: '西餐咖啡厅',
  11: '培训机构',
  12: '医院',
  13: '综合商场',
  14: '其它',
};

// export const deviceInitStatus = {
//   0: '任务创建',
//   1: '任务进行中',
//   2: '任务完成',
//   3: '任务暂停',
//   4: '任务取消',
// };

export const deviceInitStatus = {
  0: '任务进行中',
  1: '任务进行中',
  2: '任务完成',
};

export const checkState = {
  0: '待提交给支付通道',
  1: '支付通道受理中',
  2: '提现成功',
  3: '风险预警待处理',
  4: '提现失败',
  5: '挂起',
};

export const statusList = [
  {
    id: 0,
    status: checkState[0],
  },
  {
    id: 1,
    status: checkState[1],
  },
  {
    id: 2,
    status: checkState[2],
  },
  {
    id: 3,
    status: checkState[3],
  },
  {
    id: 4,
    status: checkState[4],
  },
  {
    id: 5,
    status: checkState[5],
  },
];

export const withdrawalState = {
  0: '申请成功',
  1: '提现中',
  2: '提现完成',
  3: '提现失败',
};

// export const applyState = {
//   '-3': '审核不通过',
//   '-2': '挂起',
//   '-1': '待审核',
//   0: '审核通过',
//   1: '提现中',
//   2: '提现成功',
//   3: '提现失败',
//   4: '风险预警待处理',
// };

export const applyCheckState = {
  '-3': '不通过',
  0: '通过',
};

export const applyState = {
  '-3': '提现失败',
  '-2': '挂起',
  '-1': '待提交给支付通道',
  0: '待提交给支付通道',
  1: '支付通道受理中',
  2: '提现成功',
  3: '提现失败',
  4: '风险预警待处理',
};

export const agentAccountColProps = {
  md: 24,
  lg: 24,
  xl: 12,
  xxl: 12,
};

export const agentAccountLabel = 'mchName mchId contactUser';

export const agentAccountValue = 'mchId';

export const serviceCenterStatus = {
  0: '待处理',
  1: '处理中',
  2: '已处理',
  3: '已关闭',
};

export const serviceCenterStatusList = [
  {
    id: 0,
    status: serviceCenterStatus[0],
  },
  {
    id: 1,
    status: serviceCenterStatus[1],
  },
  {
    id: 2,
    status: serviceCenterStatus[2],
  },
  {
    id: 3,
    status: serviceCenterStatus[3],
  },
];

export const wireTypes = {
  0: 'USB线',
  1: '充电器',
  2: '出租车线',
};

export const wireTypes1 = {
  0: '普通充电器',
  1: '出租车设备',
};

export const accountState = {
  0: '正常',
  1: '冻结',
};

export const bankAccountType = {
  0: '对私账户',
  1: '对公账户',
  2: '微信零钱',
};

export const bankFilterType = {
  0: '银行卡',
  1: '微信',
};

export const bizTypeList = {
  [BIZ]: '商户',
  [STORE]: '连锁门店分店',
};

export const bizTypes = {
  0: '商户',
  1: '连锁门店分店',
  2: '出租车司机',
};

export const downloadStatus = {
  0: '已创建',
  2: '生成完成',
};

export const downloadTaskType = {
  [DEVICE_INIT]: 0,
  [ORDER_DOWNLOAD]: 1,
  [DEVICE_DOWNLOAD]: 2,
  [REPORT_DOWNLOAD]: 3,
  [DEVICE_ALLOCATE]: 4,
  [DEVICE_RECALL]: 5,
  [DEVICE_REPORT_DOWNLOAD]: 6,
  [CUSTOMER_REPORT]: 7,
};

// 广告状态
export const adOpenState = {
  0: '关闭',
  1: '打开',
};

export const genderObj = {
  0: '全部',
  1: '男',
  2: '女',
};

// 推送对象
export const noticeType = {
  0: '代理商',
  1: '商户',
};

// 投诉类型
export const complaintsType = {
  0: '充电投诉',
  1: '招商咨询',
  2: '代理/商户问题',
  3: '其他',
};

// 投诉解决方法
export const resolveType = {
  0: '电话解决',
  1: '退款处理',
  2: '未解决',
};

// 广告状态
export const adStateList = {
  0: '草稿',
  1: '等待审核',
  2: '审核失败',
  3: '等待投放',
  4: '投放中',
  5: '已下架',
};

const SHOW_CHANNEL_WECHAT = 0;
const SHOW_CHANNEL_ALI = 1;

// 广告渠道
export const adChannelList = {
  [SHOW_CHANNEL_WECHAT]: '微信小程序',
  [SHOW_CHANNEL_ALI]: '支付宝小程序',
};

export const matchTypeList = {
  1: '按商户投放',
  0: '按客人地理位置投放',
};

export const adImgRate = 4;

// 广告位置
export const AdPlaceList = [
  {
    name: '密码页底部Banner',
    value: 0,
    src: () => require('../images/password.png'),
    type: AD_TYPE_BOTTOM_BANNER,
    width: 375,
    height: 110,
  },
  {
    name: '选时长页顶部Banner',
    value: 1,
    src: () => require('../images/home.png'),
    type: AD_TYPE_TOP_BANNER,
    width: 345,
    height: 120,
  },
  {
    name: '小程序启动页背景',
    value: 2,
    src: () => require('../images/start.png'),
    type: AD_TYPE_PAGE_BG,
    width: 375,
    height: 812,
  },
  {
    name: '小程序首页底部Banner',
    value: 3,
    src: () => require('../images/scancode.png'),
    type: AD_TYPE_BOTTOM_BANNER,
    width: 375,
    height: 110,
  },
  {
    name: '订单列表页底部Banner',
    value: 4,
    src: () => require('../images/order.png'),
    type: AD_TYPE_BOTTOM_BANNER,
    width: 375,
    height: 110,
  },
  {
    name: '订单详情页底部Banner',
    value: 5,
    src: () => require('../images/order_detail.png'),
    type: AD_TYPE_BOTTOM_BANNER,
    width: 375,
    height: 110,
  },
  {
    name: '充电帮助页底部Banner',
    value: 6,
    src: () => require('../images/charge_help.png'),
    type: AD_TYPE_BOTTOM_BANNER,
    width: 375,
    height: 110,
  },
];

export const AdMatchTypeObj = {
  biz: '1',
  loc: '0',
};

export const adExamineFailReason = {
  0: '不得使用“国家级”、“最高级”、“最佳”等绝对化用语',
  1: '不得投放虚假或者引人误解的广告',
  2: '不得使用易引人误解的广告创意，故意欺骗、误导消费者',
  3: '不得贬低其他生产经营者的商品或者服务',
  4: '不得在广告中出现“驰名商标”字样',
  5: '不得出现“国家免检产品”等涉及质量免检的内容',
  6: '不得损害国家、民族、社会的形象、利益及安全',
  7: '不得使用未经授权的第三方形象或标识',
  8: '不得违背社会精神文明建设要求，不得违背社会风尚良俗',
  9: '不得使用众筹、1元夺宝等',
  10: '不得使用消极、丑陋、恐怖等可能引起用户不适或反感的元素',
  11: '不得模仿腾讯产品样式，以免造成用户误导',
  12: '广告图片不得出现任何误导/诱导用户操作的元素，如鼠标手、关闭按钮、播放按钮等',
};

export const adExamineStateList = [
  { value: true, label: '审核通过' },
  { value: false, label: '审核不通过' },
];


// 使用计费规则
export const ruleStatus = {
  0: '阶梯收费',
  1: '预付费',
};
