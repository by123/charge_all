// import { applyMiddleware, createStore, compose } from 'redux';
// import thunkMiddleware from 'redux-thunk';
// import { createBrowserHistory } from 'history';
//
// import { connectRouter, routerMiddleware } from 'connected-react-router';
// import promiseMiddleware from '../middlewares/promise-middleware';
// import queryStringMiddleware from '../middlewares/query-string-middleware';
// import rootReducer from './combine-reducers';
//
// const history = createBrowserHistory();
//
// const composeEnhancer = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;
//
// export const store = createStore(
//   connectRouter(history)(rootReducer),
//   composeEnhancer(
//     applyMiddleware(
//       routerMiddleware(history),
//       queryStringMiddleware,
//       thunkMiddleware,
//       promiseMiddleware,
//     ),
//   ),
// );
//
// export function observeStore(select, onChange) {
//   let currentState;
//
//   function handleChange() {
//     let nextState = select(store.getState());
//     if (nextState !== currentState) {
//       currentState = nextState;
//       onChange(currentState);
//     }
//   }
//
//   let unsubscribe = store.subscribe(handleChange);
//   handleChange();
//   return unsubscribe;
// }
