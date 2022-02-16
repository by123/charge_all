import React from 'react';
import PropTypes from 'prop-types';
import { Layout, Menu, Icon } from 'antd';
import { Link } from 'react-router-dom';
import pathToRegexp from 'path-to-regexp';

import { arrayToTree, queryArray } from '../../utils';
import './layout.less';
import logo from '../../images/logo.png';
import logo1 from '../../images/logo1.png';

const { Sider } = Layout;
const { SubMenu } = Menu;


class Sidebar extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      openKeys: [],
      selectedKeys: [],
    };
  }

  componentDidMount() {
    this.findCurrentMenu(this.props.menu);
  }

  componentDidUpdate({ location, menu }) {
    if (!Object.is(location, this.props.location) || !Object.is(menu, this.props.menu)) { // 路由发生改变时
      this.findCurrentMenu(this.props.menu); // 选中对应菜单，展开选中菜单
    }
  }
  handleOpenChange = (openKeys) => {
    this.setState({ openKeys });
  };

  findCurrentMenu = (menu) => {
    const getPathArray = (array, current, pid, id) => { // 找出当前选中的菜单和相关父级菜单
      const result = [String(current[id])];
      const getPath = (item) => {
        if (item && item[pid]) {
          result.unshift(String(item[pid]));
          getPath(queryArray(array, item[pid], id));
        }
      };
      getPath(current);
      return result;
    };
    let currentMenu;

    for (const item of menu) {
      if (item.router && pathToRegexp(item.router).exec(location.pathname)) {
        currentMenu = item;
        break;
      }
    }

    if (currentMenu) {
      const selectedKeys = getPathArray(menu, currentMenu, 'bpid', 'id');
      const openKeys = selectedKeys.slice();
      this.setState({
        selectedKeys,
        openKeys,
      });
    }
  }
  render() {
    const { menu, siderFold, onSwitchSider } = this.props;
    const { openKeys, selectedKeys } = this.state;

    // 寻找选中路由
    const collapsed = !siderFold;
    const mode = collapsed ? 'vertical' : 'inline';
    const menuTree = arrayToTree(menu.filter(_ => _.mpid !== -1), 'id', 'mpid');

    // 递归生成菜单
    const getMenus = (menuTreeN = [], siderFoldN) => {
      return menuTreeN.map(item => {
        if (item.children) {
          return (
            <SubMenu
              key={item.id}
              title={<span>
                {item.icon && <Icon type={item.icon} />}
                <span>{(!siderFoldN || menuTree.indexOf(item) < 0) && item.name}</span>
              </span>}
            >
              {getMenus(item.children, siderFoldN)}
            </SubMenu>
          );
        }
        return (
          <Menu.Item key={item.id}>
            <Link to={item.router}>
              {item.icon && <Icon type={item.icon} theme="filled" />}
              <span>{item.name}</span>
            </Link>
          </Menu.Item>
        );
      });
    };
    const openProps = siderFold ? {
      openKeys,
      onOpenChange: this.handleOpenChange,
    } : {};
    const menuProps = {
      ...openProps,
      theme: 'dark',
      mode,
      selectedKeys,
    };
    return (
      <Sider
        width={210}
        collapsible
        collapsed={collapsed}
        trigger={null}
        onCollapse={onSwitchSider}
      >
        <div className="layout-logo">
          {collapsed ? <img alt="logo" src={logo} /> : <img alt="logo1" src={logo1} />}
        </div>
        <Menu {...menuProps}>
          {getMenus(menuTree, collapsed)}
        </Menu>
      </Sider>
    );
  }
}


Sidebar.propTypes = {
  menu: PropTypes.array.isRequired,
  siderFold: PropTypes.bool.isRequired,
  onSwitchSider: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
};

export default Sidebar;
