import { message } from 'antd';
import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { post } from '@/utils/request';
import { push } from '@/store/router-helper';
import { mergeState, createReducer } from '@/utils';

function exchangeSuccess() {
  return (dispatch) => {
    message.success('售后换线成功');
    dispatch(push('/taxi/device'));
  };
}

function exchangeDevice(data) {
  return {
    type: types.exchangeDevice,
    payload: post(api.changeDevice, data),
    nextAction: exchangeSuccess(),
  };
}

export const action = {
  exchangeDevice,
};

export const reducer = createReducer({
  exchangeDeviceResult: {},
}, {
  [types.fetchGroupDetail](state, { payload }) {
    return mergeState(state, payload, 'exchangeDeviceResult');
  },
});
