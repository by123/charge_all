import React from 'react';
import PropTypes from 'prop-types';
import { push } from '@/store/router-helper';
import { Link } from 'react-router-dom';
import { Icon, Menu } from 'antd';
import { connect } from 'react-redux';

import { action as globalActions } from '../../store/global';

import { AUTH_TOKEN_KEY, USER_INFO_KEY } from '../../utils/constants';
import { ModifyPasswordModal } from '../../containers/ModifyPassword';

import './layout.less';

const { SubMenu } = Menu;

class CommonHeader extends React.Component {
  static propTypes = {
    onSwitchSider: PropTypes.func.isRequired,
    siderFold: PropTypes.bool,
    profile: PropTypes.object.isRequired,
    dispatch: PropTypes.func.isRequired,
    globalLoading: PropTypes.bool.isRequired,
  };

  static defaultProps = {
    siderFold: '',
  }
  handleLogOut = (e) => {
    if (e.key === 'logout') {
      window.localStorage.removeItem(AUTH_TOKEN_KEY);
      window.localStorage.removeItem(USER_INFO_KEY);
      this.props.dispatch(push('/login'));
    } else if (e.key === 'modifyPassword') {
      this.props.dispatch(globalActions.toggleMPModal(true));
    }
  };
  render() {
    const { profile, siderFold } = this.props;
    const username = profile ? profile.name : '';
    return (
      <div style={{ paddingLeft: siderFold ? 210 : 80 }} className="layout-header">
        <div className="button" onClick={this.props.onSwitchSider.bind(this, siderFold)}>
          <Icon type={siderFold ? 'menu-fold' : 'menu-unfold'} />
        </div>
        <h2>代理商管理后台</h2>
        <div className="right-wrapper">
          <Menu mode="horizontal" selectable={false} style={{ zIndex: 999 }} onClick={this.handleLogOut}>
            <SubMenu style={{ float: 'right' }} title={<span > <Icon type="user" /> {username} </span>}>
              <Menu.Item key="modifyPassword">
                修改密码
              </Menu.Item>
              <Menu.Item key="logout">
                退出
              </Menu.Item>
            </SubMenu>
          </Menu>
          <Link to="/doc/pc/introduce/">帮助文档</Link>
        </div>
        <ModifyPasswordModal />
        <div className="loading-wrapper">
          { this.props.globalLoading ? <Icon type="loading-3-quarters" className="anticon-spin" /> : null }
        </div>
      </div>
    );
  }
}
const mapStateToProps = ({ global: { globalLoading } }) => {
  return {
    globalLoading,
  };
};
export default connect(mapStateToProps)(CommonHeader);
