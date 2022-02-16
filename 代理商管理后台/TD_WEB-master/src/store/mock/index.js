/* eslint-disable no-unused-vars */
import Mock from 'mockjs';

import { api } from '../api';
import { roles } from './auth';
import { moneyInfo, moneyAccount, moneyBalanceList, moneyWithdrawalList } from './money';

import { positions, adList } from './banner';

import { agentList, agentDetail } from './agent';
import { orderList } from './order';
import { deviceList } from './device';
import { accountDetail, bankInfo } from './account';

// mock(api.users, userData);
const success = {
  status: '0',
  msk: 'ok',
};
const token = {
  status: '0',
  msk: 'ok',
  token: '',
};

function mock(url, result) {
  if (!url) {
    throw new Error('mock请求url不能为空');
  }
  Mock.mock(new RegExp(url), result);
}

// 产品管理
// mock(api.productList, productList);
// mock(api.unshelveProduct, success);
// mock(api.shelveProduct, success);
// mock(api.productDetail, productDetail);
// mock(api.channelList, channelList);
// mock(api.saveProduct, success);


// 广告管理
// mock(api.adPositions, positions);
// mock(api.advList, adList);
// mock(api.addAdv, success);
// mock(api.qiniuToken, token);

// mock(api.orderList, { ...success, data: orderList });

// mock(api.deviceList, { ...success, data: deviceList });

// mock(api.agentList, { ...success, data: agentList });
// mock(api.agentDetail, { ...success, data: agentDetail });

// mock(api.updatePassword, success);

// mock(api.login, {
//   ...success,
//   data: {
//     access_token: 'eyJhbGciOiJI3r4Zw',
//     channel_admin: 0,
//     channel_code: '',
//     expires_in: 604799,
//     fund_party_id: null,
//     id: 162,
//     jti: '3fc98bc0-338a-4a0b-bea1-d8d29d294d67',
//     name: '蔡德伍',
//     organization_id: 0,
//     refresh_token: 'eyJhbGciOiJIUzI1NiS5PZuMFYghUk7E',
//     scope: 'all',
//     token_type: 'bearer',
//     user_type: 'staff',
//   },
// });

// 人员管理
// mock(api.personnelList, {
//   ...success,
//   data: {
//     totalCount: 50,
//     pageSize: 20,
//     pageId: 1,
//     'rows|20': [{
//       'personnelId|+1': 0,
//       a: '@cname',
//       b: '@float(0, 100000, 0, 0)',
//       c: '@float(0, 1000, 0, 0)',
//       d: '@float(0, 1000, 0, 0)',
//       e: '@datetime("T")',
//       f: /^1[0-9]{10}$/,
//     }],
//   },
// });

// mock(api.personnelAdd, {
//   ...success,
//   data: {
//     account: '@string',
//     password: /^[0-9]{6}$/,
//   },
// });

// 资金管理
// mock(api.moneyInfo, { ...success, data: moneyInfo });
// mock(api.moneyBalanceList, { ...success, data: moneyBalanceList });
// mock(api.moneyWithdrawalList, { ...success, data: moneyWithdrawalList });
// mock(api.moneyWithdrawalList, success);
// mock(api.moneyAccount, { ...success, data: moneyAccount });
// mock(api.moneyWithdrawal, success);

// 账户管理
// mock(api.accountDetail, { ...success, data: accountDetail });
// mock(api.bankInfo, { ...success, data: bankInfo });
// mock(api.addBankCard, success);
