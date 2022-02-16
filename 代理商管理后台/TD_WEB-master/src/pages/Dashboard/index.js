import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Row, Col, Progress, Spin, Table } from 'antd';
import moment from 'moment';
import './style.less';
import { Card } from '../../components/Card';
import { DataCard } from '../../components/Charts/DataCard';
import { GroupedColumn } from '../../components/Charts/GroupedColumn';
// import { Gauge } from '../../components/Charts/Gauge';
// import ChinaMap from '../../components/ChinaMap';
import { action } from './store';
import { push } from '../../store/router-helper';
import { action as applyActions } from '../ReportCenter/store';
import { dateFormat, formatMoney, checkIsSuperAdmin } from '../../utils';

const profitRate = 10;
const orderRate = 1;
const ColProps = {
  xs: 24,
  lg: 12,
  xl: 6,
  style: {
    marginBottom: 16,
  },
};

const sheetStyle = {
  marginBottom: 30,
};
const LeftColProps = {
  xs: 24,
  xl: 16,
  style: sheetStyle,
};
const RightColProps = {
  xs: 24,
  xl: 8,
  style: sheetStyle,
};

const yesterday = dateFormat(moment().subtract(1, 'days'));

class Dashboard extends React.Component {
  lookMoreReport = () => {
    this.props.dispatch(push('/reportCenter'));
  }

  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(action.fetchDashboard());
    dispatch(applyActions.getChildrenDeviceUsingCondition({ queryDate: yesterday }));
  }

  render() {
    const { report, profile, childrenDeviceUsingConditionList } = this.props;
    let {
      deviceActiveNum = 0,
      orderNumToday,
      deviceTotalNum = 0,
      incomeThisWeek,
      todayIncome = 0,
      totalIncome = 0,
      todayOrderServiceNum = 0,
      // taxiDeviceCount = 0,
      // taxiTodayIncome = 0,
      // taxiTodayOrderCount = 0,
      // taxiTotalIncome = 0,
    } = report.result || {};
    const activePercent = parseFloat((deviceActiveNum * 100 / deviceTotalNum).toFixed(2));
    const { roleType, mchType } = profile;
    const isSuperAdmin = checkIsSuperAdmin(profile);
    todayIncome = isSuperAdmin ? formatMoney(todayIncome * profitRate) : todayIncome;
    totalIncome = isSuperAdmin ? formatMoney(totalIncome * profitRate) : totalIncome;
    // taxiTodayIncome = isSuperAdmin ? formatMoney(taxiTodayIncome * profitRate) : taxiTodayIncome;
    // taxiTotalIncome = isSuperAdmin ? formatMoney(taxiTotalIncome * profitRate) : taxiTotalIncome;
    orderNumToday = isSuperAdmin ? orderNumToday * orderRate : orderNumToday;
    const { dataSource } = childrenDeviceUsingConditionList;
    const dataList = [
      {
        label: '今日收入（元）',
        value: todayIncome || 0,
        icon: {
          type: 'money-collect',
        },
        // children: {
        //   label: '出租车今日收入（元）',
        //   value: taxiTodayIncome,
        // },
        // background: '#fff',
      },
      {
        label: '今日订单数',
        value: orderNumToday || 0,
        icon: {
          type: 'pushpin',
        },
        background: 'rgb(255,153,0)',
        // children: {
        //   label: '出租车今日订单数',
        //   value: taxiTodayOrderCount,
        // },
      },
      {
        label: '今日订单金额（元）',
        value: todayOrderServiceNum || 0,
        icon: {
          type: 'reconciliation',
        },
        background: '#2DB6F4',
        // children: {
        //   label: '出租车累计总收入（元）',
        //   value: taxiTotalIncome,
        // },
      },
      {
        label: '累计总收入（元）',
        value: totalIncome || 0,
        icon: {
          type: 'hourglass',
        },
        background: '#87D067',
        // children: {
        //   label: '出租车设备总数（个）',
        //   value: taxiDeviceCount,
        // },
      },
    ];
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
            item.profit = isSuperAdmin ? formatMoney(incomeArr[i].profit * profitRate) : incomeArr[i].profit;
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
    const tableProps = {
      size: 'middle',
      columns: [
        { dataIndex: 'mchName', title: '渠道名称' },
        { dataIndex: 'salesName', title: '关联业务员' },
        { dataIndex: 'activeDeviceTotalNum', title: '截止昨日激活设备总数' },
        // { dataIndex: 'deviceUsingPercent', title: '昨日使用率', render: text => { return text !== 0 ? `${text}%` : 0; } },
        // { dataIndex: 'usingDeviceNum', title: '昨日使用设备数' },
        { dataIndex: 'orderNum', title: '昨日订单数' },
        { dataIndex: 'orderPercent', title: '昨日订单率', render: text => { return text !== 0 ? `${text}%` : 0; } },
        { dataIndex: 'profitYuan', title: '昨日收益（元）', render: (text) => formatMoney(text) },
      ],
      dataSource,
      pagination: true,
      rowKey: 'id',
    };
    const isSalesman = (roleType === 2 || mchType === 2) ? 'none' : '';
    const cardTitle = (<div>昨日渠道设备使用率与收益<a onClick={this.lookMoreReport} style={{ float: 'right', marginRight: '5%' }}>查看更多</a></div>);
    const weekIncome = (<div>最近一周收入<span style={{ float: 'right', marginRight: '5%' }}>{averageIncome()}  平均日收入（元）</span></div>);
    return (<div className="dashboard">
      <Spin spinning={!!report.loading}>
        <h2>今日数据</h2>
        <Row className="data-collect" gutter={16}>
          {dataList.map((item, index) => (<Col key={index} {...ColProps}>
            <DataCard {...item} />
          </Col>))}
        </Row>
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
        <Row gutter={30} className="yesterday-row" style={{ display: isSalesman }}>
          <Card title={cardTitle}>
            <Table {...tableProps} />
          </Card>
          {/* <Col {...RightColProps}>
            <Card title="设备区域分布">
              <ChinaMap />
            </Card>
          </Col> */}
        </Row>
      </Spin>
    </div>);
  }
}

Dashboard.propTypes = {
  dispatch: PropTypes.func.isRequired,
  profile: PropTypes.object.isRequired,
  report: PropTypes.object.isRequired,
  childrenDeviceUsingConditionList: PropTypes.object.isRequired,
};

const mapStateToProps = ({ dashboard: { report }, reportCenter: { childrenDeviceUsingConditionList }, global: { profile } }) => {
  return { report, childrenDeviceUsingConditionList, profile };
};
export default connect(mapStateToProps)(Dashboard);
