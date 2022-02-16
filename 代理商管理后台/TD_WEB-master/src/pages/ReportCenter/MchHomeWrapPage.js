import React, { Component } from 'react';
import { withRouter, Link } from 'react-router-dom';
// import { IndexLink } from 'react-router';
import { Breadcrumb, Icon, Divider } from 'antd';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import MchHomePage from './MchHomePage';
import { push } from '../../store/router-helper';
import './style.less';
import { REPORT_TYPE_PROFIT, REPORT_TYPE_DEVICE } from '../../utils/constants';

class MchHomeWrapPage extends Component {
  state = {
    breadcrumbList: [],
  };

  // 查看代理商下级数据时保存名称和id用于面包屑导航
  onCheckDetail = (data, isFirst) => {
    let { breadcrumbList } = this.state;
    const { route, name } = data;
    if (isFirst && breadcrumbList.length) return;
    breadcrumbList.push({
      route,
      name,
    });
    this.setState({
      breadcrumbList: breadcrumbList.concat(),
    });
  }

  onBreadcrumbClick = (index) => {
    let { breadcrumbList } = this.state;
    this.props.dispatch(push(breadcrumbList[index].route));
    breadcrumbList = breadcrumbList.filter((val, ind) => {
      return ind <= index;
    });
    this.setState({
      breadcrumbList: breadcrumbList.concat(),
    });
  }

  getBasePath = () => {
    const { match: { params: { category } } = {} } = this.props;
    let result = {};
    if (category === REPORT_TYPE_PROFIT) {
      result.path = '/reportCenter';
      result.name = '渠道收益';
    } else if (category === REPORT_TYPE_DEVICE) {
      result.path = '/reportCenter/device';
      result.name = '设备激活';
    }
    return result;
  }

  render() {
    const { match: { params = {} } = {} } = this.props;
    const { mchId } = params;
    const { breadcrumbList } = this.state;
    const basePath = this.getBasePath();
    return (
      <div>
        <div style={{ paddingLeft: '20px' }}>
          <Breadcrumb style={{ fontSize: '18px' }}>
            <Breadcrumb.Item key="home">
              <Icon type="left" style={{ fontSize: '18px' }} />
              <Link to={basePath.path} style={{ marginLeft: '10px' }}>{basePath.name}</Link>
            </Breadcrumb.Item>
            {breadcrumbList.map((val, ind) => {
              return (<Breadcrumb.Item key={val.route}>
                {ind === breadcrumbList.length - 1 ? (
                  <span style={{ color: '#FFCE00' }}>{val.name}</span>
                ) : (
                  <a onClick={() => this.onBreadcrumbClick(ind)}>{val.name}</a>
                )}
              </Breadcrumb.Item>);
            })}
          </Breadcrumb>
        </div>
        <Divider />
        <MchHomePage
          mchId={mchId}
          location={this.props.location}
          match={this.props.match}
          onCheckDetail={this.onCheckDetail}
        />
      </div>
    );
  }
}

MchHomeWrapPage.propTypes = {
  match: PropTypes.object.isRequired,
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
};

export default connect()(withRouter(MchHomeWrapPage));
