/**
 * 该页面同时作为商户主页的内容页
 */
import React, { Component } from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Tabs, Button, message, Row, Col, Table, Tooltip, Form } from 'antd';
import { EditableTable } from '../../containers/EditableTable';
import { momentToFormatDate, mapArrayToOptions } from '../../utils';
import { action } from './store';
import { push } from '../../store/router-helper';
import { STATISTIC_KEY, REPORT_TYPE_PROFIT } from '../../utils/constants';
import { DatePicker, Select } from '../../components/pop/index';
import './style.less';

const FormItem = Form.Item;
const { RangePicker, MonthPicker } = DatePicker;
const { TabPane } = Tabs;
const ColProps = {
  xs: 24,
  lg: 12,
  xl: 6,
  style: {
    marginBottom: 16,
  },
};
const formItemLayout = {
  wrapperCol: {
    xs: {
      span: 16,
    },
    sm: {
      span: 16,
    },
    xl: {
      span: 16,
    },
  },
};
const tooltipStyle = { maxWidth: 400 };
const renderTime = (time) => {
  if (!time) return '总计';
  const week = {
    1: '星期一',
    2: '星期二',
    3: '星期三',
    4: '星期四',
    5: '星期五',
    6: '星期六',
    7: '星期日',
  };
  time = moment(time);
  return `${time.format('YYYY-MM-DD')} ${week[time.format('E')]}`;
};

class ProductionStatistic extends Component {
  constructor(props) {
    super(props);
    this.state = {
      tabCurrent: '1',
      factoryId: '',
      isEdit: false,
      year: '',
      month: '',
      lastUpdateTime: momentToFormatDate(moment(), true),
      random: localStorage.getItem(STATISTIC_KEY),
    };
  }

  // 生产统计头部数据
  getStatisticsData = () => {
    const { dispatch } = this.props;
    const { factoryId, random } = this.state;
    this.setState({
      lastUpdateTime: momentToFormatDate(moment(), true),
    });
    dispatch(action.getStatisticsData({ factoryId, random }));
  }

  // 生产统计列表数据
  getStatisticsList = () => {
    const { dispatch } = this.props;
    const { factoryId, random, startDate, endDate } = this.state;
    let paramsData = {
      startDate,
      endDate,
      factoryId,
      random,
    };
    dispatch(action.getStatisticsList(paramsData));
  }

  // 上报计划头部数据
  getPlanData = () => {
    const { factoryId, random } = this.state;
    this.props.dispatch(action.getPlanData({ factoryId, random }));
  }

  // 上报计划列表数据
  getPlanList = () => {
    const { dispatch } = this.props;
    const { factoryId, random, year, month } = this.state;
    const paramsData = {
      factoryId,
      random,
      year,
      month,
    };
    dispatch(action.getPlanList(paramsData));
  }

  // 更新计划数据
  postPlanList = (data) => {
    const { dispatch } = this.props;
    const { factoryId, random } = this.state;
    dispatch(action.postPlanList(factoryId, random, { factoryId, planList: data }, () => {
      message.success('更新生产计划成功');
      this.getPlanList();
    }));
  }

  // 上报发货头部数据
  getDeliverData = () => {
    const { factoryId, random } = this.state;
    this.props.dispatch(action.getDeliverData({ factoryId, random }));
  }

  // 上报发货列表数据
  getDeliverList = () => {
    const { dispatch } = this.props;
    const { factoryId, random, year, month } = this.state;
    dispatch(action.getDeliverList({ year, month, factoryId, random }));
  }

  // 上报发货数据
  postDeliverList = (deliverList) => {
    const { dispatch } = this.props;
    const { factoryId, random } = this.state;
    dispatch(action.postDeliverList(factoryId, random, { factoryId, deliverList }, () => {
      message.success('更新发货数据成功');
      this.getDeliverList();
    }));
  }

  fetchList = () => {
    const { tabCurrent } = this.state;
    if (tabCurrent === '1') { // 生产统计
      this.getStatisticsData();
      this.getStatisticsList();
    } else if (tabCurrent === '2') { // 上报计划
      this.getPlanData();
      this.getPlanList();
    } else { // 上报发货
      this.getDeliverData();
      this.getDeliverList();
    }
  }

  handleTabChange = (activeKey) => {
    this.setState({
      tabCurrent: activeKey,
      ...this.getQueryDate(activeKey),
    }, () => {
      // const query = this.getQueryDate();
      // dispatch(push({ ...location, query }));
      this.fetchList();
    });
  }

  componentDidMount = () => {
    // this.fetchDeviceUsingCondition();
    const { profile: { mchType, roleType, userId } } = this.props;
    if (mchType === 2 && roleType === 7) {
      this.setState({
        factoryId: userId,
      }, () => {
        this.handleTabChange('3');
      });
      return;
    }
    this.getFactoryList((_, getState) => {
      const { active: { factoryListResult } } = getState();
      const factoryList = factoryListResult.result || [];
      if (!factoryList[0]) return;
      this.setState({
        factoryId: factoryList[0].factoryName,
      }, () => {
        this.handleTabChange('1');
      });
    });
  }

  getQueryDate = (active) => {
    const tabCurrent = active || this.state.tabCurrent;
    if (tabCurrent === '1') {
      const endDate = moment().format('YYYY-MM-DD');
      const startDate = moment().subtract(30, 'days').format('YYYY-MM-DD');
      return {
        startDate,
        endDate,
      };
    }
    const date = moment().format('YYYY-MM').split('-');
    return {
      year: date[0],
      month: date[1],
    };
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  disabledDate = (current) => {
    let { createTime, profile } = this.props;
    // 作为子组件时取传入的时间
    createTime = createTime || profile._mchCreateTime;
    let startDate = moment(createTime - 1 * 60 * 60 * 1000);
    let dayBefore = new Date().getTime();
    return current < startDate || current > moment(dayBefore);
  }

  openDetail = (data) => {
    const { onCheckDetail, dispatch, mchId } = this.props;
    const route = `/reportCenter/mchHomePage/${REPORT_TYPE_PROFIT}/${data.mchId}`;
    dispatch(push(route));
    if (mchId && onCheckDetail) {
      onCheckDetail({
        route,
        name: data.mchName,
      });
    }
  }

  toggleEdit = (isEdit) => {
    this.setState({
      isEdit,
    });
  }

  getListData = () => {
    const dataObj = {
      1: 'statisticsList',
      2: 'planList',
      3: 'deliverList',
    };
    const { tabCurrent } = this.state;
    return this.props[dataObj[Number(tabCurrent)]] || {};
  }

  onDateChange = (value) => {
    const [beginDate, endDate] = momentToFormatDate(value);
    this.setState({
      startDate: beginDate,
      endDate,
    }, () => {
      this.getStatisticsList();
    });
    // this.props.dispatch(push());
  }

  onMonthChange = (value) => {
    const month = value.format('YYYY-MM').split('-');
    this.setState({
      year: month[0],
      month: month[1],
    }, () => {
      this[this.state.tabCurrent === '2' ? 'getPlanList' : 'getDeliverList']();
    });
  }

  handleSave = (result) => {
    const { tabCurrent } = this.state;
    if (tabCurrent === '2') {
      result = result.filter(val => {
        return val.planDate;
      });
      this.postPlanList(result);
    } else {
      result = result.filter(val => {
        return val.deliverDate;
      });
      this.postDeliverList(result);
    }
  }

  getFactoryList = (nextAction) => {
    const { random } = this.state;
    this.props.dispatch(action.getFactoryList({ random }, nextAction));
  }

  changeFactory = (factoryId) => {
    this.setState({
      factoryId,
    }, () => {
      this.fetchList();
    });
  }

  rateRender = (text) => {
    return text || text === 0 ? `${text}%` : text;
  }

  produceNumRender = (text, record) => {
    const { version } = record;
    if (version) {
      const versionText = version.split(',').map(val => {
        return `V${val}`;
      }).join('，');
      text = `${text}（${versionText}）`;
    }
    return text;
  }

  render() {
    //filter
    const {
      statisticsData,
      planData,
      deliverData,
      deliverList,
      factoryListResult,
      profile,
    } = this.props;
    const { tabCurrent } = this.state;
    const isAgent = profile.roleType !== 7;
    const todayStatistics = statisticsData.result || {};
    const planDataResult = planData.result || {};
    const deliverDataResult = deliverData.result || {};
    const { result: dataSource, loading } = this.getListData();
    const factoryList = factoryListResult.result || null;
    const renderDiff = (diff) => {
      return diff && diff < 0 ? <span className="production-red-text">{diff}</span> : diff;
    };

    const getExpandedData = (record) => {
      const {
        chargerCompleteRate,
        todayChargerNum,
        todayChargerPlanNum,
        diffChargerNum,
        todayChargerDeliverNum,
        todayUsbCableDeliverNum,
        chargerVersion,
        todayTaxiLineNum,
        usbCableCompleteRate,
        todayUsbCableNum,
        todayUsbCablePlanNum,
        diffUsbCableNum,
        todayTaxiLinePlanNum,
        diffTaxiLineNum,
        taxiLineCompleteRate,
        todayTaxiLineDeliverNum,
        usbCableVersion,
        taxiLineVersion,
      } = record || {};
      const charge = {
        name: '充电器',
        produceNum: todayChargerNum,
        planNum: todayChargerPlanNum,
        diffNum: diffChargerNum,
        completeRate: chargerCompleteRate,
        deliverNum: todayChargerDeliverNum,
        version: chargerVersion,
      };
      const usb = {
        name: 'USB线',
        produceNum: todayUsbCableNum,
        planNum: todayUsbCablePlanNum,
        diffNum: diffUsbCableNum,
        completeRate: usbCableCompleteRate,
        deliverNum: todayUsbCableDeliverNum,
        version: usbCableVersion,
      };
      const taxi = {
        name: '出租车线',
        produceNum: todayTaxiLineNum,
        planNum: todayTaxiLinePlanNum,
        diffNum: diffTaxiLineNum,
        completeRate: taxiLineCompleteRate,
        deliverNum: todayTaxiLineDeliverNum,
        version: taxiLineVersion,
      };
      return [charge, usb, taxi];
    };
    // 展开行
    const expandedRowRender = (record) => {
      const columns = [
        { title: '商品', dataIndex: 'name', key: 'name' },
        { title: '生产量', dataIndex: 'produceNum', key: 'produceNum', render: this.produceNumRender },
        { title: '计划量', dataIndex: 'planNum', key: 'planNum' },
        { title: '差额', dataIndex: 'diffNum', key: 'diffNum', render: renderDiff },
        { title: '计划完成率', dataIndex: 'completeRate', key: 'completeRate', render: this.rateRender },
        { title: '发货量', dataIndex: 'deliverNum', key: 'deliverNum' },
      ];
      const data = getExpandedData(record);
      return (
        <Table
          className="production-expanded-table"
          columns={columns}
          dataSource={data}
          pagination={false}
          bordered={false}
        />
      );
    };

    function getVal(obj, key, defaultValue = '', unit) {
      let result = obj[key] || obj[key] === 0 ? obj[key] : defaultValue;
      if (!unit) {
        return result;
      }
      return (result || result === 0) && result !== defaultValue ? `${result}${unit}` : result;
    }

    function generateTooltip(obj, category) {
      let charge = 0;
      let usb = 0;
      let taxi = 0;
      switch (category) {
        case 'diff':
          charge = obj.monthChargerDiff || 0;
          usb = obj.monthUsbCableDiff || 0;
          taxi = obj.monthTaxiLineDiff || 0;
          break;
        case 'produce':
          charge = obj.monthChargerNum || 0;
          usb = obj.monthUsbCableNum || 0;
          taxi = obj.monthTaxiLineNum || 0;
          break;
        case 'lastProduce':
          charge = obj.lastMonthChargerNum || 0;
          usb = obj.lastMonthUsbCableNum || 0;
          taxi = obj.lastMonthTaxiLineNum || 0;
          break;
        case 'lastDiff':
          charge = obj.lastMonthChargerDiff || 0;
          usb = obj.lastMonthUsbCableDiff || 0;
          taxi = obj.lastMonthTaxiLineDiff || 0;
          break;
        case 'lastPlan':
          charge = obj.lastMonthChargerPlanNum || 0;
          usb = obj.lastMonthUsbCablePlanNum || 0;
          taxi = obj.lastMonthTaxiLinePlanNum || 0;
          break;
        case 'plan':
          charge = obj.monthChargerPlanNum || 0;
          usb = obj.monthUsbCablePlanNum || 0;
          taxi = obj.monthTaxiLinePlanNum || 0;
          break;
        case 'nextPlan':
          charge = obj.nextMonthChargerPlanNum || 0;
          usb = obj.nextMonthUsbCablePlanNum || 0;
          taxi = obj.nextMonthTaxiLinePlanNum || 0;
          break;
        default:
          break;
      }
      return `充电器：${charge}  USB线：${usb}  出租车线：${taxi}`;
    }

    const listProps = {
      loading,
      rowKey: 'dateStr',
      showPagination: false,
      dataSource,
      expandRowByClick: true,
    };
    tabCurrent === '1' && (listProps.expandedRowRender = expandedRowRender);
    const dataList1 = [
      {
        label: '今日生产量',
        value: getVal(todayStatistics, 'todayNum', '-'),
        children: [
          { label: '充电器', value: getVal(todayStatistics, 'todayChargerNum') },
          { label: 'usb线', value: getVal(todayStatistics, 'todayUsbCableNum') },
          { label: '出租车线', value: getVal(todayStatistics, 'todayTaxiLineNum') },
        ],
      },
      {
        label: '今日计划量',
        value: getVal(todayStatistics, 'todayPlanNum', '-'),
        children: [
          { label: '充电器', value: getVal(todayStatistics, 'todayChargerPlanNum') },
          { label: 'usb线', value: getVal(todayStatistics, 'todayUsbCablePlanNum') },
          { label: '出租车线', value: getVal(todayStatistics, 'todayTaxiLinePlanNum') },
        ],
      },
      {
        label: '差额',
        value: getVal(todayStatistics, 'diffNum', '-'),
        children: [
          { label: '充电器', value: getVal(todayStatistics, 'diffChargerNum') },
          { label: 'usb线', value: getVal(todayStatistics, 'diffUsbCableNum') },
          { label: '出租车线', value: getVal(todayStatistics, 'diffTaxiLineNum') },
        ],
      },
      {
        label: '计划完成率',
        value: getVal(todayStatistics, 'completeRate', '-', '%'),
        children: [
          { label: '充电器', value: getVal(todayStatistics, 'chargerCompleteRate', '', '%') },
          { label: 'usb线', value: getVal(todayStatistics, 'usbCableCompleteRate', '', '%') },
          { label: '出租车线', value: getVal(todayStatistics, 'taxiLineCompleteRate', '', '%') },
        ],
      },
    ];
    const dataList2 = [
      {
        label: '上月计划量',
        value: getVal(planDataResult, 'lastMonthPlanNum', '-'),
        tooltip: generateTooltip(planDataResult, 'lastPlan'),
        children: [
          { label: '实际生产量', value: getVal(planDataResult, 'lastMonthNum'), tooltip: generateTooltip(planDataResult, 'lastProduce') },
          { label: '差额', value: getVal(planDataResult, 'lastMonthDiff'), tooltip: generateTooltip(planDataResult, 'lastDiff') },
        ],
      },
      {
        label: '本月计划量',
        value: getVal(planDataResult, 'monthPlanNum', '-'),
        tooltip: generateTooltip(planDataResult, 'plan'),
        children: [
          { label: '实际生产量', value: getVal(planDataResult, 'monthNum'), tooltip: generateTooltip(planDataResult, 'produce') },
          { label: '差额', value: getVal(planDataResult, 'monthDiff'), tooltip: generateTooltip(planDataResult, 'diff') },
        ],
      },
      {
        label: '下月计划量',
        value: getVal(planDataResult, 'nextMonthPlanNum'),
        tooltip: generateTooltip(planDataResult, 'nextPlan'),
      },
    ];
    const dataList3 = [
      {
        label: '上月发货量',
        value: getVal(deliverDataResult, 'lastMonthDeliverNum', '-'),
        children: [
          { label: '充电器', value: getVal(deliverDataResult, 'lastMonthChargerDeliverNum') },
          { label: 'USB线', value: getVal(deliverDataResult, 'lastMonthUsbCableDeliverNum') },
          { label: '出租车线', value: getVal(deliverDataResult, 'lastMonthTaxiLineDeliverNum') },
        ],
      },
      {
        label: '本月发货量',
        value: getVal(deliverDataResult, 'monthDeliverNum', '-'),
        children: [
          { label: '充电器', value: getVal(deliverDataResult, 'monthChargerDeliverNum') },
          { label: 'USB线', value: getVal(deliverDataResult, 'monthUsbCableDeliverNum') },
          { label: '出租车线', value: getVal(deliverDataResult, 'monthTaxiLineDeliverNum') },
        ],
      },
    ];
    const tab1Columns = [
      { dataIndex: 'dateStr', title: '时间', render: renderTime },
      { dataIndex: 'todayNum', title: '生产量' },
      { dataIndex: 'todayPlanNum', title: '计划量' },
      { dataIndex: 'diffNum', title: '差额', render: renderDiff },
      { dataIndex: 'completeRate', title: '计划完成率', render: this.rateRender },
      { dataIndex: 'todayDeliverNum', title: '发货量' },
    ];
    const tab2Columns = [
      { dataIndex: 'planDate', title: '时间', render: renderTime },
      { dataIndex: 'chargerPlanNum', title: '充电器计划量', editable: true },
      { dataIndex: 'usbCablePlanNum', title: 'usb线计划量', editable: true },
      { dataIndex: 'taxiLinePlanNum', title: '出租车线计划量', editable: true },
      { dataIndex: 'planNum', title: '合计' },
    ];
    const tab3Columns = [
      { dataIndex: 'deliverDate', title: '时间', render: renderTime },
      { dataIndex: 'chargerDeliverNum', title: '充电器发货量', editable: true },
      { dataIndex: 'usbCableDeliverNum', title: 'usb线发货量', editable: true },
      { dataIndex: 'taxiLineDeliverNum', title: '出租车线发货量', editable: true },
      { dataIndex: 'deliverNum', title: '合计' },
    ];
    const {
      loading: deliverLoading = false,
      result: deliverDataSource,
    } = deliverList || {};
    const { queryDate } = this.state;
    const tab3ListProps = Object.assign({}, listProps, {
      loading: deliverLoading,
      showPagination: false,
      dataSource: deliverDataSource,
      columns: tab3Columns,
      queryDate,
    });

    const renderItem = (item) => {
      return (<div>
        {item.tooltip
          ? (<Tooltip title={item.tooltip} overlayStyle={tooltipStyle} placement="topLeft">
            <div className="data-name">{item.label}</div>
            <div className={`data-value ${item.value < 0 ? 'production-red-text' : ''}`}>{item.value}</div>
          </Tooltip>)
          : (<div>
            <div className="data-name">{item.label}</div>
            <div className={`data-value ${item.value < 0 ? 'production-red-text' : ''}`}>{item.value}</div>
          </div>)
        }
        {item.children && (<div>
          {item.children.map(val => {
            if (val.tooltip) {
              return (<Tooltip key={val.label} title={val.tooltip} overlayStyle={tooltipStyle} placement="topLeft">
                <div key={val.label}>{val.label} {val.value}</div>
              </Tooltip>);
            }
            return <div key={val.label}>{val.label} {val.value}</div>;
          })}
        </div>)}
      </div>);
    };

    const renderTable = (props, editable) => {
      props = {
        size: 'middle',
        pagination: false,
        bordered: true,
        ...props,
        editing: this.state.isEdit,
      };
      return !editable ? (<Table
        {...props}
      />) : <EditableTable {...props} />;
    };

    let defaultDate = null;
    if (tabCurrent === '1') {
      const { startDate, endDate } = this.getQueryDate();
      defaultDate = [moment(startDate), moment(endDate)];
    } else {
      const { year, month } = this.getQueryDate();
      defaultDate = moment(`${year}-${month}`);
    }
    const tab1 = (<TabPane tab="生产统计" key="1">
      <div className="data-collect production-data-pane">
        <Row className="data-pane" gutter={16}>
          {dataList1.map((item, index) => (<Col key={index} {...ColProps}>
            {renderItem(item)}
          </Col>))}
          <div className="data-time">
            <span>数据更新于{this.state.lastUpdateTime}</span>
            <a onClick={this.getStatisticsData}>刷新</a>
          </div>
        </Row>
      </div>
      <Form className="time-wrap">
        <FormItem {...formItemLayout}>
          <span>请选择时间：</span>
          <RangePicker onChange={this.onDateChange} defaultValue={defaultDate} allowClear={false} disabledDate={this.disabledDate} />
          <Button type="primary" className="search-button" onClick={this.fetchList}>搜索</Button>
        </FormItem>
      </Form>
      {/* <PageFilter {...filterProps} /> */}
      {renderTable({ ...listProps, columns: tab1Columns })}
      {/* <PageList {...listProps} columns={tab1Columns} queryDate={queryDate} /> */}
    </TabPane>);

    const tab2 = (<TabPane tab="上报计划" key="2">
      <div className="data-collect production-data-pane">
        <Row className="data-pane" gutter={16}>
          {dataList2.map((item, index) => (<Col key={index} {...ColProps}>
            {renderItem(item)}
          </Col>))}
        </Row>
      </div>
      <FormItem {...formItemLayout}>
        <span>请选择时间：</span>
        <MonthPicker onChange={this.onMonthChange} allowClear={false} defaultValue={defaultDate} />
        <Button type="primary" className="search-button" onClick={this.fetchList}>搜索</Button>
      </FormItem>
      {renderTable({ ...listProps, columns: tab2Columns, handleSave: this.handleSave }, true)}
    </TabPane>);

    const tab3 = (<TabPane tab="上报发货" key="3">
      <div className="data-collect production-data-pane">
        <Row className="data-pane" gutter={16}>
          {dataList3.map((item, index) => (<Col key={index} {...ColProps}>
            {renderItem(item)}
          </Col>))}
        </Row>
      </div>
      <FormItem {...formItemLayout}>
        <span>请选择时间：</span>
        <MonthPicker onChange={this.onMonthChange} allowClear={false} defaultValue={defaultDate} disabledDate={this.disabledDate} />
        <Button type="primary" className="search-button" onClick={this.fetchList}>搜索</Button>
      </FormItem>
      {renderTable({ ...tab3ListProps, handleSave: this.handleSave }, true)}
    </TabPane>);
    return (
      <div className="page-report-center">
        <div className="content-wrapper production-statics-content">
          {factoryList && isAgent && factoryList[0] && <div className="factory-list">
            <span>请选择工厂：</span>
            <Select className="select-wrap" onChange={this.changeFactory} defaultValue={factoryList[0].factoryName}>
              {mapArrayToOptions(factoryList, 'factoryName', 'factoryDesc')}
            </Select>
          </div>}
          <Tabs size="large" onChange={this.handleTabChange} activeKey={this.state.tabCurrent} >
            { isAgent ? [tab1, tab2, tab3] : [tab3] }
          </Tabs>
        </div>
      </div>
    );
  }
}

ProductionStatistic.propTypes = {
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  profile: PropTypes.object.isRequired,
  createTime: PropTypes.string,
  onCheckDetail: PropTypes.func,
  mchId: PropTypes.string,
  statisticsData: PropTypes.object.isRequired,
  planData: PropTypes.object.isRequired,
  deliverData: PropTypes.object.isRequired,
  deliverList: PropTypes.object.isRequired,
  factoryListResult: PropTypes.object.isRequired,
};

ProductionStatistic.defaultProps = {
  createTime: '',
  onCheckDetail: () => {},
  mchId: '',
};

export default connect(({ active: {
  statisticsData,
  statisticsList,
  planData,
  planList,
  postPlanListResult,
  deliverData,
  deliverList,
  postDeliverListResult,
  factoryListResult,
}, global: { profile } }) => ({
  statisticsData,
  statisticsList,
  planData,
  planList,
  postPlanListResult,
  deliverData,
  deliverList,
  postDeliverListResult,
  profile,
  factoryListResult,
}))(ProductionStatistic);
