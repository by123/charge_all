import React from 'react';
import PropTypes from 'prop-types';
import { hot } from 'react-hot-loader';
import { ConnectedRouter } from 'connected-react-router';
import { Helmet } from 'react-helmet';
import routes from './routes';
import { SYSTEM_NAME } from './utils/constants';
import './styles/global.less';
import './styles/theme.less';

import { CheckVersion } from './containers/CheckVersion';

console.log('PUBLISH_ENV: ', process.env.PUBLISH_ENV);
console.log('VERSION: ', process.env.VERSION);


const App = ({ history }) => {
  return (
    <div>
      <Helmet>
        <title>{SYSTEM_NAME}</title>
      </Helmet>
      <ConnectedRouter history={history} >
        {routes}
      </ConnectedRouter>
      {process.env.NODE_ENV === 'production' ? <CheckVersion /> : null}
    </div>
  );
};
App.propTypes = {
  history: PropTypes.object.isRequired,
};
export default hot(module)(App);
