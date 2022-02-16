import 'babel-polyfill';
import React from 'react';
import ReactDOM from 'react-dom';
import { applyMiddleware, compose, createStore } from 'redux';
import { createBrowserHistory } from 'history';
import { routerMiddleware, connectRouter } from 'connected-react-router';
import thunkMiddleware from 'redux-thunk';
import { Provider } from 'react-redux';
import { ConfigProvider } from 'antd';
// import zhCN from 'antd/lib/locale-provider/zh_CN';
import zhCN from 'antd/lib/locale-provider/zh_CN';
import moment from 'moment';
import 'moment/locale/zh-cn';

import './utils/promise-polyfill';
import promiseMiddleware from './middlewares/promise-middleware';
import './store/mock';

import App from './app';
import rootReducer from './store/combine-reducers';
import { syncRouterQuery } from './store/router-helper';

moment.locale('zh-cn');

const history = createBrowserHistory();

const composeEnhancer = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

export const store = createStore(
  connectRouter(history)(rootReducer),
  composeEnhancer(
    applyMiddleware(
      routerMiddleware(history),
      thunkMiddleware,
      promiseMiddleware,
    ),
  ),
);

syncRouterQuery(store);
ReactDOM.render(
  <Provider store={store}>
    <ConfigProvider locale={zhCN}>
      <App history={history} />
    </ConfigProvider>
  </Provider>
  , document.getElementById('root'));
