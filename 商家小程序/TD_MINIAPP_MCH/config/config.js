let all_host = {
  dev: "https://admin.tandianvip.com/api",                       // 开发版
  real: "https://admin.tandianvip.com/api",               // 仿真环境
  release: "https://admin.tandianvip.com/api",              // 正式环境
};

const config = {
  mode: 'release',                            // 切换模式
  shareTitle: '炭电商家版',       // 用于分享的标题语  
  version: '1.7.0',
}
export const API_HOST = all_host[config.mode];

config['API_HOST'] = all_host[config.mode];

export default config;
 