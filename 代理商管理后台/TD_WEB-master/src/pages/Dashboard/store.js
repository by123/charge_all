import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get } from '@/utils/request';
import { createReducer } from '@/utils/index';


export const action = {
  fetchDashboard() {
    return {
      type: types.fetchDashboard,
      payload: get(api.fetchDashboard),
    };
  },
};

export const reducer = createReducer({
  report: {},
}, {
  [types.fetchDashboard](state, { payload }) {
    return {
      ...state,
      report: payload,
    };
  },
});
