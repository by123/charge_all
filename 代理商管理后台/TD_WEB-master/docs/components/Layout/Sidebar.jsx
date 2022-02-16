import React from 'react';
import PropTypes from 'prop-types';
import { Layout, Menu, Icon } from 'antd';
import { Link } from 'react-router-dom';
import pathToRegexp from 'path-to-regexp';
import { push } from '@/store/router-helper';

import { arrayToTree, queryArray, getDocType } from '@/utils';
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

  componentDidUpdate({ location, menu }) {
    if (!Object.is(location, this.props.location) || !Object.is(menu, this.props.menu)) { // 路由发生改变时
      this.findCurrentMenu(this.props.menu); // 选中对应菜单，展开选中菜单
    }
  }

  componentDidMount() {
    this.findCurrentMenu(this.props.menu);
  }

  keysAddDocType = (openKeys) => {
    const docType = getDocType(this.props.location.pathname);
    return openKeys.map(key => {
      return `${docType}${key}`;;
    });
  }

  getNumber = (str) => {
    const num = /\s*(\d+)$/.exec(str);
    return num ? +num[0] : -1;
  }

  handleOpenChange = (openKeys) => {
    const latestOpenKey = openKeys.find(key => this.state.openKeys.indexOf(key) === -1);
    if (!latestOpenKey) {
      openKeys = this.keysAddDocType(openKeys);
      this.setState({
        openKeys,
      });
    } else if (this.getNumber(latestOpenKey) < 100) {
      const currentMenu = this.props.menu.find(item => item.id === this.getNumber(latestOpenKey));
      if (currentMenu.router !== this.props.location.pathname) {
        this.props.dispatch(push(currentMenu.router));
        window.scrollTo(0, 0);
      } else {
        this.setState({
          openKeys: [latestOpenKey],
        });
      }
    }
  }

  getPathArray = (array, current, pid, id) => { // 找出当前选中的菜单和相关父级菜单
    const result = [String(current[id])];
    const getPath = (item) => {
      if (item && item[pid]) {
        result.unshift(String(item[pid]));
        getPath(queryArray(array, item[pid], id));
      }
    };
    getPath(current);
    return result;
  }

  getCurrentMenu = () => {
    const { menu } = this.props;
    let currentMenu;
    for (const item of menu) {
      if (item.router && pathToRegexp(item.router).exec(this.props.location.pathname)) {
        currentMenu = item;
        break;
      }
    }
    return currentMenu;
  }

  findCurrentMenu = (menu) => {
    let currentMenu = this.getCurrentMenu();

    if (currentMenu) {
      const selectedKeys = this.getPathArray(menu, currentMenu, 'bpid', 'id');
      let openKeys = selectedKeys.slice();
      openKeys = this.keysAddDocType(openKeys);
      this.setState({
        // selectedKeys,
        openKeys,
      });
    }
  }
  render() {
    const { menu, siderFold, onSwitchSider, location } = this.props;
    const { openKeys, selectedKeys } = this.state;
    // 寻找选中路由
    const collapsed = !siderFold;
    const mode = collapsed ? 'vertical' : 'inline';
    const menuTree = arrayToTree(menu.filter(_ => _.mpid !== -1), 'id', 'mpid');
    const docType = getDocType(location.pathname);

    // 递归生成菜单
    const getMenus = (menuTreeN = [], siderFoldN) => {
      return menuTreeN.map(item => {
        if (item.children) {
          return (
            <SubMenu
              key={`${docType}${item.id}`}
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
          <Menu.Item key={`${docType}${item.id}`}>
            {!item.mpid && <Link to={item.router}>
              {item.icon && <Icon type={item.icon} theme="filled" />}
              <span>{item.name}</span>
            </Link>}
            {!!item.mpid && <a href={`#${item.name.replace(/\.*/g, '')}`}>
              {item.icon && <Icon type={item.icon} theme="filled" />}
              <span>{item.name}</span>
            </a>}
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
      mode,
      selectedKeys,
    };
    return (
      <Sider
        width={300}
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
  dispatch: PropTypes.func.isRequired,
};

export default Sidebar;
