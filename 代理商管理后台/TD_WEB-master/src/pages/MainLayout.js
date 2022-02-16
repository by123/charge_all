/**
 *  包含左侧导航菜单，Header，Footer的主页面布局
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Layout } from 'antd';
import { connect } from 'react-redux';

import { action as commonActions } from '@/store/global';

import { Bread, Sidebar, Header, Footer } from '@/components/layout';
import { MENU_COLLAPSE_KEY, AUTH_TOKEN_KEY } from '@/utils/constants';
import { replace } from '../store/router-helper';
import { childRoutes } from '../routes';
import './MainLayout.less';

const { Content } = Layout;
class MainLayout extends React.Component {
  static propTypes = {
    location: PropTypes.object.isRequired,
    dispatch: PropTypes.func.isRequired,
    menus: PropTypes.array.isRequired,
    profile: PropTypes.object.isRequired,
  }
  static defaultProps = {
    status: '',
  }

  state = {
    siderFold: window.localStorage.getItem(MENU_COLLAPSE_KEY) !== '0' || false,
  };

  componentDidMount() {
    // 尚未登录跳转至登录页
    const { dispatch } = this.props;
    const isLoggedIn = !!window.localStorage.getItem(AUTH_TOKEN_KEY);
    if (!isLoggedIn) {
      dispatch(replace('/login'));
    }
    dispatch(commonActions.getCurrentUser((_, getState) => {
      const { profile } = getState().global;
      dispatch(commonActions.fetchMenuList());
      if (profile.mchType !== 2) {
        dispatch(commonActions.getAdAuthList(() => {
          const { getAdAuthListResult: { result: adAuthList } } = getState().global;
          if (profile.mchId in adAuthList) {
            dispatch(commonActions.menuAddAdItem());
          }
        }));
      }
    }));
  }

  handleSwitchSider = (collapsed) => {
    const siderFold = !collapsed;
    this.setState({ siderFold });
    window.localStorage.setItem(MENU_COLLAPSE_KEY, siderFold ? '1' : '0');
  };

  render() {
    const { menus, profile, location } = this.props;
    return (
      <Layout className="ant-layout-has-sider page-container">
        <Sidebar menu={menus} siderFold={this.state.siderFold} location={location} onSwitchSider={this.handleSwitchSider} />
        <Layout> {/*这个id是给弹层组件提供定位的*/}
          <Header profile={profile} siderFold={this.state.siderFold} onSwitchSider={this.handleSwitchSider} />
          <Content className="page-main">
            <Bread menu={menus} location={this.props.location} />
            <Layout id="dashboard_main_wrap" className="content">
              {childRoutes}
            </Layout>
          </Content>
          <Footer />
        </Layout>
      </Layout>
    );
  }
}

const mapStateToProps = ({ global: { menuData, profile, status } }) => {
  const menus = menuData.result || [];
  return {
    menus,
    profile,
    status,
  };
};

export default connect(mapStateToProps)(MainLayout);
