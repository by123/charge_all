import React from 'react';
import { Route, Switch } from 'react-router';
import Loadable from 'react-loadable';
import { NotFound } from './pages/error';
import { Spin } from 'antd';

const Loading = () => (<div style={{ paddingTop: 100, textAlign: 'center' }}>
  <Spin size="large" />
</div>);

const asyncComponent = (component) => {
  return Loadable({
    loader: component,
    loading: Loading,
  });
};

const AppDoc = asyncComponent(() => import(/* webpackChunkName: "DocPage" */ './pages/AppDoc'));

const route = (
  <Switch>
    <Route exact path="/doc/:filename" component={AppDoc} />
    <Route exact path="/doc/app" component={NotFound} />
  </Switch>
);

export default route;
