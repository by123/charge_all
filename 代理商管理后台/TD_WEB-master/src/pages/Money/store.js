import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { push } from '@/store/router-helper';
import { message } from 'antd';
import { createReducer, mergeState, formatEmptyListData } from '../../utils';

function fetchInfo() {
  return {
    type: types.fetchMoneyInfo,
    payload: get(api.moneyInfo),
  };
}

const changeTab = (category) => {
  return (dispatch, getState) => {
    dispatch({
      type: types.changeMoneyTab,
      payload: category,
    });
    const { location } = getState().router;
    // delete query.startDate;
    // delete query.endDate;
    // location.query = query;
    dispatch(push({ ...location, query: { category, startDate: '', endDate: '' } }));
  };
};

function formatQuery(data) {
  if (data) {
    if (!data.startDate) delete data.startDate;
    if (!data.endDate) delete data.endDate;
  }
  return data;
}

function fetchMoneyWithdrawalList() {
  return (dispatch, getState) => {
    let query = getState().router.location.query;
    query = formatQuery(query);
    dispatch({
      type: types.fetchMoneyWithdrawalList,
      payload: get(api.moneyWithdrawalList, query),
    });
  };
}

function showWithdrawal(show) {
  return {
    type: types.showWithdrawalModal,
    payload: show,
  };
}

function queryWithdrawalTax(withdrawalMoney) {
  return {
    type: types.queryWithdrawalTax,
    payload: api.queryWithdrawalTax(withdrawalMoney),
  };
}

export const action = {
  fetchMoneyList(data) {
    return {
      type: types.fetchMoneyBalanceList,
      payload: get(api.moneyBalanceList, data),
    };
  },
  changeTab,
  fetchMoneyDetail(withDrawId) {
    return {
      type: types.fetchMoneyDetail,
      payload: get(api.fetchMoneyDetail, { withDrawId }),
    };
  },
  toggleMoneyDetail(visible) {
    return {
      type: types.togleMoneyDetail,
      visible,
    };
  },
  fetchInfo,
  showWithdrawal,
  fetchMoneyWithdrawalList,
  // 获取提现规则
  fetchWithdrawalRule(nextAction) {
    return (dispatch, getState) => {
      const { mchType } = getState().global.profile;
      dispatch({
        type: types.fetchWithdrawalRule,
        payload: get(api.fetchWithdrawalRule, {
          mchType,
        }),
        nextAction,
      });
    };
  },
  moneyWithdrawal(data) {
    return {
      type: types.moneyWithdrawal,
      payload: post(api.moneyWithdrawal, data),
      nextAction: this.withdrawalSuccess(),
    };
  },
  withdrawalSuccess() {
    return (dispatch) => {
      dispatch(showWithdrawal(false));
      message.success('提现成功');
      // 刷新余额数据
      dispatch(fetchInfo());
      // 切换列表
      dispatch(changeTab('withdrawal'));
      dispatch(fetchMoneyWithdrawalList());
    };
  },
  toggleEmptyBank(visible) {
    return {
      type: types.toggleEmptyBank,
      visible,
    };
  },
  queryWithdrawalTax,
};

export const reducer = createReducer({
  moneyData: {},
  moneyInfo: {},
  category: 'balance',
  date: '',
  accountInfo: {},
  moneyDetail: {},
  moneyDetailVisible: false,
  withdrawalRule: {},
  withdrawalList: {},
  emptyBankModalVisible: false,
  showWithdrawal: false,
  queryWithdrawalTaxResult: {},
},
{
  [types.fetchMoneyBalanceList](state, { payload }) {
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'moneyData');
  },
  [types.fetchMoneyWithdrawalList](state, { payload }) {
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'withdrawalList');
  },
  [types.changeMoneyTab](state, { payload }) {
    return {
      ...state,
      category: payload,
    };
  },
  [types.fetchMoneyInfo](state, { payload }) {
    return mergeState(state, payload, 'moneyInfo');
  },
  // 提现部分
  [types.fetchWithdrawalInfo](state, { payload }) {
    return mergeState(state, payload, 'accountInfo');
  },
  [types.moneyWithdrawal](state, { payload }) {
    return {
      ...state,
      accountInfo: { ...payload },
    };
  },
  [types.showWithdrawalModal](state, { payload }) {
    return {
      ...state,
      showWithdrawal: payload,
    };
  },
  [types.fetchMoneyDetail](state, { payload }) {
    return {
      ...state,
      moneyDetail: payload,
    };
  },
  [types.togleMoneyDetail](state, { visible }) {
    return {
      ...state,
      moneyDetailVisible: visible,
    };
  },
  [types.fetchWithdrawalRule](state, { payload }) {
    return {
      ...state,
      withdrawalRule: payload,
    };
  },
  [types.toggleEmptyBank](state, { visible }) {
    return {
      ...state,
      emptyBankModalVisible: visible,
    };
  },
  [types.queryWithdrawalTax](state, { payload }) {
    return mergeState(state, payload, 'queryWithdrawalTaxResult');
  },
});
