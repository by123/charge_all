/**
 *  包含左侧导航菜单，Header，Footer的主页面布局
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Layout } from 'antd';

import { Bread, Sidebar, Header, Footer } from './components/Layout';
import { MENU_COLLAPSE_KEY } from '@/utils/constants';
import { connect } from 'react-redux';
import { getDocType } from '@/utils';
import MenuList, { pcMenu } from './menu';
import routes from './routes';
import AppDoc from './pages/AppDoc';
import ErrorBoundary from './components/ErrorBoundary';
import './components/Layout/layout.less';

const { Content } = Layout;
const DocTypeList = {
  biz: 'biz',
  pc: 'pc',
  app: 'app',
};

class MainLayout extends React.Component {
  static propTypes = {
    location: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props);
    const docType = getDocType(props.location.pathname);
    this.state = {
      menu: MenuList[`${docType}Menu`] || [],
      docType,
      siderFold: true,
    };
  }

  handleSwitchSider = (collapsed) => {
    const siderFold = !collapsed;
    this.setState({ siderFold });
    window.localStorage.setItem(MENU_COLLAPSE_KEY, siderFold ? '1' : '0');
  };

  componentDidMount = () => {
    this.getContent();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(location, this.props.location)) {
      const docType = getDocType(this.props.location.pathname);
      this.setState({
        docType,
        menu: MenuList[`${docType}Menu`],
      });
      this.getContent();
    }
  }

  getContent = () => {
    const { location: { pathname }, match: { params: { filename } } } = this.props;
    const docType = getDocType(pathname);
    if (!docType || !filename) return;
    const getContent = () => require(`./pages/${docType}/${filename}.md`).default;
    this.setState({
      content: getContent(),
    });
  }

  render() {
    const { location = {}, dispatch } = this.props;
    const { menu } = this.state;
    return (
      // <ErrorBoundary>
      <Layout className="ant-layout-has-sider page-container doc-page-container">
        <Sidebar
          menu={menu}
          siderFold={this.state.siderFold}
          location={location}
          onSwitchSider={this.handleSwitchSider}
          dispatch={dispatch}
        />
        <Layout className="pagr-content-wrap">
          <Header
            siderFold={this.state.siderFold}
            onSwitchSider={this.handleSwitchSider}
            location={location}
          />
          <Content className="page-main">
            {/* <Bread menu={menus} location={this.props.location} /> */}
            <Layout id="dashboard_main_wrap" className="content">
              <AppDoc content={this.state.content} location={location} />
            </Layout>
          </Content>
          {/* <Footer /> */}
        </Layout>
      </Layout>
      // </ErrorBoundary>
    );
  }
}

export default connect()(MainLayout);
