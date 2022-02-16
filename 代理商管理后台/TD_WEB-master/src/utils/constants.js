// 七牛上传地址
export const UPLOAD_URL = window.location.protocol === 'https:' ? 'https://up-z2.qbox.me' : 'http://up-z2.qiniu.com';

// 七牛图片地址
export const IMG_HOST = process.env.PUBLISH_ENV === 'production' ? 'https://img.production.com/' : 'http://oyu1zoloe.bkt.clouddn.com/';

export const APP_PREFIX = 'xhd';

export const MENU_COLLAPSE_KEY = `${APP_PREFIX}_menu_collapse`;
export const AUTH_TOKEN_KEY = `${APP_PREFIX}_token`;
export const USER_INFO_KEY = `${APP_PREFIX}_manage_info`;
export const IMG_TOKEN_KEY = `${APP_PREFIX}img_token`;

export const LOADING = 'loading';
export const SUCCESS = 'success';
export const FAILURE = 'failure';

export const COMPANY_NAME = '炭电';
export const SYSTEM_NAME = `${COMPANY_NAME}代理商管理后台`;

// 新增、编辑、详情 标识
export const EDIT = 'edit';
export const ADD = 'add';
export const DETAIL = 'detail';

// 代理商 商户 连锁门店 连锁门店分店
export const AGENT = 'agent';
export const BIZ = 'biz';
export const CHAIN = 'chain';
export const STORE = 'store';

// 银行账户类型
export const PRIVATE = 'private';
export const PUBLIC = 'public';

export const BASIC_TOKEN = 'Basic Z2F0ZXdheS1zZXJ2ZXI6WDMzT2dNWkxKaGl1NzBaRlpNSW43R1lCakVsTVZRWWY=';

export const UPLOADING = 'uploading';

export const pattern = {
  mobile: /^1[2-9]\d{9}$/,
  phone: /^0?\d{5,12}$/, // 电话先模糊一些
  idCard: /^\d{17}[\d|xX]$|^\d{15}$/, // 身份证
  bankCard: /^\d{1,30}$/,
  mchId: /^[a-zA-Z]{1,2}\d{6,13}$/, // 代理商账号
};

export const INDEX_WIDTH = 50;
export const ACTION_WIDTH = 100;
export const ACTION_WIDTH_LARGE = 140;
export const FINANCE_WIDTH = '25%';
export const SN_INPUT_SPLIT_REG = /\s|,|，|\r|\n/;

export const factoryId = 'f20190426001';
export const STATISTIC_KEY = 'statistic_random';

export const TRANSFERAGENT = 'transferAgent';

export const DEVICE_INIT = 'device_init';
export const ORDER_DOWNLOAD = 'order_download';
export const DEVICE_DOWNLOAD = 'device_download';
export const REPORT_DOWNLOAD = 'report_download';
export const DEVICE_REPORT_DOWNLOAD = 'device_report_download';
export const DEVICE_ALLOCATE = 'device_allocate';
export const DEVICE_RECALL = 'device_recall';
export const CUSTOMER_REPORT = 'customer_report';

export const FILE_TYPE_FILE = 'file';
export const FILE_TYPE_IMAGE = 'image';

export const REPORT_TYPE_PROFIT = 'profit';
export const REPORT_TYPE_DEVICE = 'device';

export const AD_TYPE_TOP_BANNER = 'top_banner';
export const AD_TYPE_BOTTOM_BANNER = 'tottom_banner';
export const AD_TYPE_PAGE_BG = 'page_bg';
