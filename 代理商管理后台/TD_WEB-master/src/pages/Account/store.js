import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { message } from 'antd';
import axios from 'axios';
import { createReducer, mergeState } from '../../utils';
import { ADD, EDIT } from '../../utils/constants';

function toggleAddBankModal(visible, editType = ADD, initData) {
  return {
    type: types.toggleAddBankModal,
    visible,
    editType,
    initData,
  };
}

function toggleChooseModal(visible) {
  return {
    type: types.toggleChooseModal,
    visible,
  };
}

function changeAddType(accountType) {
  return {
    type: types.changeAddType,
    accountType,
  };
}

export const action = {
  fetchAccountDetail() {
    return (dispatch, getState) => {
      const { global: { profile } } = getState();

      const { mchId, roleType } = profile;
      dispatch({
        type: types.setAccountRoleType,
        roleType,
      });
      dispatch({
        type: types.fetchAccountDetail,
        payload: get(api[roleType === 2 ? 'salesmanDetail' : 'accountDetail'], { mchId }),
      });
    };
  },
  fetchBankInfo(nextAction) {
    return {
      type: types.fetchBankInfo,
      payload: get(api.bankInfo),
      nextAction,
    };
  },
  fetchBankCodeList() {
    return {
      type: types.fetchBankCodeList,
      payload: axios.get(api.getBankCodeList),
    };
  },
  fetchCityCodeList() {
    return {
      type: types.fetchCityCodeList,
      payload: axios.get(api.getCityCodeList),
    };
  },
  toggleAddBankModal,
  toggleChooseModal,
  changeAddType,
  selectAddType(accountType) {
    return (dispatch) => {
      dispatch(changeAddType(accountType));
      dispatch(toggleChooseModal(false));
      dispatch(toggleAddBankModal(true));
    };
  },
  addBankCard(data) {
    return {
      type: types.addBankCard,
      payload: post(api.addBankCard, data),
      nextAction: this.addBankSuccess(),
    };
  },
  editBankCard(data, nextAction) {
    return {
      type: types.editBankInfo,
      payload: post(api.editBankInfo, data),
      nextAction,
    };
  },
  addBankSuccess(editType = ADD) {
    return (dispatch) => {
      let msg = editType === EDIT ? '编辑代理商/商户提现信息成功' : '添加银行卡成功';
      message.success(msg);
      dispatch(toggleAddBankModal(false));
      editType === ADD && dispatch(this.fetchBankInfo());
    };
  },
};

export const reducer = createReducer({
  accountDetail: {},
  bankInfo: {},
  addBankShow: false,
  addBankInfo: {},
  addChooseShow: false,
  editType: undefined,
  accountType: undefined,
  roleType: -1,
  bankCodeList: {},
  cityCodeList: {},
  initData: {}, // 添加银行卡弹窗初始值
}, {
  [types.fetchAccountDetail](state, { payload }) {
    return mergeState(state, payload, 'accountDetail');
  },
  [types.fetchBankInfo](state, { payload }) {
    return {
      ...state,
      bankInfo: payload,
    };
  },
  [types.addBankCard](state, { payload }) {
    return mergeState(state, payload, 'addBankInfo');
  },
  [types.toggleAddBankModal](state, { visible, editType, initData }) {
    return {
      ...state,
      addBankShow: visible,
      editType,
      initData,
    };
  },
  [types.toggleChooseModal](state, { visible }) {
    return {
      ...state,
      addChooseShow: visible,
    };
  },
  [types.changeAddType](state, { accountType }) {
    return {
      ...state,
      accountType,
    };
  },
  [types.setAccountRoleType](state, { roleType }) {
    return {
      ...state,
      roleType,
    };
  },
  [types.fetchBankCodeList](state, { payload }) {
    return {
      ...state,
      bankCodeList: payload,
    };
  },
  [types.fetchCityCodeList](state, { payload }) {
    return {
      ...state,
      cityCodeList: payload,
    };
  },
});
