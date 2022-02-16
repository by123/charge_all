import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Row, Col, Progress, Spin, Divider, Tabs } from 'antd';
import isEqual from 'lodash/isEqual';
import { action } from './store';
import { Card } from '../../components/Card';
import { DetailList } from '../../components/DetailList';
import { GroupedColumn } from '../../components/Charts/GroupedColumn';
import ReportCenter from './index';
import DeviceReportPage from './DeviceReportPage';
import { formatMoney, formatAgentType, concatLabel, datetimeFormat, checkIsSuperAdmin } from '../../utils';
import './style.less';
import { REPORT_TYPE_PROFIT } from '../../utils/constants';

const { TabPane } = Tabs;

const sheetStyle = { marginBottom: 30 };
const LeftColProps = { xs: 24, xl: 16, style: sheetStyle };
const RightColProps = { xs: 24, xl: 8, style: sheetStyle };

class MchHomePage extends React.Component {
  constructor(props) {
    super(props);
    const { mchType = 0 } = props.location.query;
    const { match: { params: { category } } = {} } = props;
    this.state = {
      isTaxi: mchType === '-2',
      category,
      tabCurrent: category === REPORT_TYPE_PROFIT ? '1' : '2',
    };
  }

  componentDidMount() {
    const { mchId } = this.props;
    this.fetchInitData(mchId);
  }

  componentWillUpdate(nextState) {
    if (!isEqual(nextState.mchId, this.props.mchId)) {
      this.fetchInitData(nextState.mchId);
    }
  }

  fetchInitData(mchId) {
    const { dispatch, onCheckDetail } = this.props;
    const { isTaxi } = this.state;
    if (mchId) {
      let paramsData = { mchId };
      isTaxi && (paramsData.mchType = -2);
      dispatch(action.fetchDashboard(paramsData));
      if (isTaxi) return;
      dispatch(action.fetchMchDetail(paramsData, (_, getState) => {
        const { reportCenter: { agentDetailResult: { result } } } = getState();
        const { mchId: id, mchName, mchType } = result || {};
        let item = {
          route: `/reportCenter/mchHomePage/${REPORT_TYPE_PROFIT}/${id}?mchType=${mchType}`,
          name: mchName,
        };
        onCheckDetail && onCheckDetail(item, true);
      }));
    }
  }

  handleTabChange = (activeKey) => {
    this.setState({
      tabCurrent: activeKey,
    });
  }

  render() {
    const {
      dashboardResult: {
        result,
        loading,
      },
      profile,
      agentDetailResult,
    } = this.props;
    let {
      deviceActiveNum = 0,
      deviceTotalNum = 0,
      incomeThisWeek,
    } = result || {};
    const activePercent = parseFloat((deviceActiveNum * 100 / deviceTotalNum).toFixed(2));
    const agentDetail = agentDetailResult.result || {};
    const isSuperAdmin = checkIsSuperAdmin(profile);
    const getDateStr = (dayCount = 7) => {
      let time = new Date(new Date().setHours(0, 0, 0, 0));
      let arr = [];
      for (let index = 1; index <= dayCount; index++) {
        arr.push({
          direction: 0,
          profit: 0,
          profitDate: `${time - 1000 * 60 * 60 * 24 * index}`,
        });
      }
      return arr.reverse();
    };
    let income;
    if (incomeThisWeek && incomeThisWeek.length > 0) {
      let incomeArr = incomeThisWeek;
      let _incomeArr = getDateStr();
      _incomeArr.map((item) => {
        for (let i = 0; i < incomeArr.length; i++) {
          if (Number(item.profitDate) === incomeArr[i].profitDate) {
            item.direction = incomeArr[i].direction;
            item.profit = isSuperAdmin ? formatMoney(incomeArr[i].profit) : incomeArr[i].profit;
            item.profitDate = incomeArr[i].profitDate;
          }
        }
        return _incomeArr;
      });
      income = _incomeArr;
    } else {
      income = getDateStr();
    }
    let averageIncome = () => {
      let _averageIncome = 0;
      if (incomeThisWeek && incomeThisWeek.length > 0) {
        income.forEach((item) => {
          _averageIncome += item.profit;
        });
        return formatMoney(_averageIncome / 7);
      }
      return _averageIncome;
    };
    const weekIncome = (<div>最近一周收入<span style={{ float: 'right', marginRight: '5%' }}>{averageIncome()}  平均日收入（元）</span></div>);

    const detailColumns = [
      { key: 'mchType', label: '账户类型', render: (agentType, record) => formatAgentType(agentType, record.level) },
      { key: 'contactUser', label: '代理姓名' },
      { key: 'contactPhone', label: '联系电话' },
      { key: 'createTime', label: '创建日期', render: text => datetimeFormat(text) },
      { key: 'totalPercent', label: '分润比例', render: (text) => concatLabel(text, '%') },
      {
        key: 'detailAddr',
        label: '位置地域',
        render: (text, record) => {
          const area = record.area ? `${record.province} ${record.city} ${record.area}` : '';
          return text ? area + text : area;
        },
      },
      { key: 'agentLevel2Total', label: '市代总数' },
      { key: 'agentLevel3Total', label: '区县代数' },
      { key: 'agentLevel4Total', label: '连锁门店' },
      { key: 'tenantTotal', label: '终端商户' },
    ];
    return (<div className="mch-home-page-container">
      {!this.state.isTaxi && (<div>
        <Spin spinning={!!agentDetailResult.loading}>
          <div className="mch-title-container">
            <span className="mch-name">{agentDetail.mchName}</span>
            <span className="mch-id">{agentDetail.mchId}</span>
          </div>
          <DetailList columns={detailColumns} dataSource={agentDetail} />
        </Spin>
        <Divider />
      </div>)}
      <Spin spinning={!!loading}>
        <Row gutter={30} style={{ marginTop: 14 }}>
          <Col {...LeftColProps}>
            <Card title={weekIncome} isCenter={false}>
              <GroupedColumn dataSource={income} />
            </Card>
          </Col>
          <Col {...RightColProps}>
            <Card title="设备激活率" isCenter={false}>
              <div className="device-active">
                <Progress strokeLinecap="square" type="dashboard" width={250} percent={activePercent} />
                <p className="count">设备总数：<span>{deviceTotalNum}</span></p>
                <p className="count">激&nbsp;&nbsp;活&nbsp;&nbsp;数：<span>{deviceActiveNum}</span></p>
                <p className="count">暂未激活：<span>{deviceTotalNum - deviceActiveNum}</span></p>
              </div>
            </Card>
          </Col>
        </Row>
      </Spin>
      <Divider />
      <div className="content-wrapper">
        <Tabs size="large" onChange={this.handleTabChange} activeKey={this.state.tabCurrent} >
          <TabPane tab="渠道设备使用与收益" key="1">
            <ReportCenter
              location={this.props.location}
              mchId={this.props.mchId}
              key={this.props.mchId}
              isTaxi={this.state.isTaxi}
              onCheckDetail={this.props.onCheckDetail}
              createTime={agentDetail.createTime}
            />
          </TabPane>
          <TabPane tab="设备激活统计" key="2">
            <DeviceReportPage
              location={this.props.location}
              mchId={this.props.mchId}
              key={this.props.mchId}
              onCheckDetail={this.props.onCheckDetail}
              createTime={agentDetail.createTime}
            />
          </TabPane>
        </Tabs>
      </div>
    </div>);
  }
}

MchHomePage.propTypes = {
  dispatch: PropTypes.func.isRequired,
  profile: PropTypes.object.isRequired,
  mchId: PropTypes.string.isRequired,
  location: PropTypes.object.isRequired,
  onCheckDetail: PropTypes.func.isRequired,
  dashboardResult: PropTypes.object,
  agentDetailResult: PropTypes.object,
};

MchHomePage.defaultProps = {
  dashboardResult: {},
  agentDetailResult: {},
};


const mapStateToProps = ({ reportCenter: { agentDetailResult, dashboardResult }, global: { profile } }) => {
  return { dashboardResult, profile, agentDetailResult };
};
export default connect(mapStateToProps)(MchHomePage);
