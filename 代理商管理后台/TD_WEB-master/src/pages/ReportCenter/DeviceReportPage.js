/**
 * 该页面同时作为商户主页的内容页
 */
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { connect } from 'react-redux';
import { Tabs, Button, Icon, message, Row, Col, Modal, Form, DatePicker } from 'antd';
import { PageList } from '../../containers/PageList';
import { OperationLink } from '../../components/OperationLink';
import { DataCard } from '../../components/Charts/DataCard';
import { DownloadModal } from '../DownloadModal';
import { action as downloadAction } from '../DownloadModal/store';
import { dateFormat, getId, momentToFormatDate, addDateZero, addEndTime, checkIsTypeChain, formatDateToMoment } from '../../utils';
import { action as reportCenterActions } from './store';
import { push } from '../../store/router-helper';
import './style.less';
import { ACTION_WIDTH, REPORT_TYPE_DEVICE, DEVICE_REPORT_DOWNLOAD } from '../../utils/constants';

const FormItem = Form.Item;
const { RangePicker } = DatePicker;
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
  labelCol: {
    xs: {
      span: 4,
    },
    sm: {
      span: 4,
    },
    xl: {
      span: 4,
    },
  },
};
const today = dateFormat(moment());

class DeviceReportPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      tabCurrent: '1',
      visible: false,
      downloadDate: '',
      showTable: false,
      selectedDate: this.getQueryDate('1'),
    };
  }

  componentDidMount = () => {
    this.getData();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  getData = () => {
    this.getDeviceReportData();
    this.fetchList();
  }

  // 数据模块
  getDeviceReportData = () => {
    const { dispatch, mchId = '' } = this.props;
    const { selectedDate } = this.state;
    let queryData = {};
    if (mchId) {
      queryData.mchId = mchId;
    }
    if (selectedDate) {
      const [startDay, endDay] = selectedDate;
      queryData.startDay = startDay;
      queryData.endDay = endDay;
    }
    dispatch(reportCenterActions.getDeviceReportData(queryData));
  }

  getQueryDate = (tabCurrent) => {
    let startDay = '';
    let endDay = '';
    if (tabCurrent === '1') {
      startDay = today;
      endDay = today;
    } else if (tabCurrent === '2') {
      startDay = this.getDayBefore(6);
      endDay = today;
    } else if (tabCurrent === '3') {
      startDay = this.getDayBefore(14);
      endDay = today;
    }
    return startDay && endDay ? [startDay, endDay] : null;
  }

  getDayBefore = (days) => {
    return dateFormat(moment().subtract(days, 'days'));
  }

  // 昨日列表数据
  fetchDeviceUsingYesterDayList = () => {
    const { dispatch, location: { query }, mchId = '', isTaxi } = this.props;
    let paramsData = {
      pageSize: 15,
      pageId: 1,
      ...query,
      mchId,
      queryDate: this.state.queryDate,
    };
    isTaxi && (paramsData.mchType = -2);
    dispatch(reportCenterActions.getChildrenDeviceUsingCondition(paramsData));
  }

  // 查询列表数据
  fetchDeviceUsingTotalList = () => {
    const { dispatch, location: { query }, mchId = '', isTaxi } = this.props;
    const queryData = { ...query, mchId };
    isTaxi && (queryData.mchType = -2);
    dispatch(reportCenterActions.getChildrenDeviceUsingCondition(queryData));
  }

  // 选择时间查询列表数据
  fetchDeviceUsingSelectList = () => {
    const { dispatch, location: { search, query }, mchId = '', isTaxi } = this.props;
    if (search !== '') {
      if (getId('queryDate') === today) {
        message.warning('查询时间不能为今天！');
      } else {
        const queryData = { ...query, mchId };
        isTaxi && (queryData.mchType = -2);
        dispatch(reportCenterActions.getChildrenDeviceUsingCondition(queryData, 'childConditionByDate'));
      }
    }
  }

  fetchList = () => {
    const { dispatch, location: { query }, mchId = '' } = this.props;
    const queryData = { ...query, mchId };
    const { selectedDate } = this.state;
    if (selectedDate) {
      const [startDay, endDay] = selectedDate;
      queryData.startDay = startDay;
      queryData.endDay = endDay;
    }
    dispatch(reportCenterActions.getDeviceReportList(queryData));
  }

  fetchAllList = () => {
    const { dispatch, location: { query }, mchId = '' } = this.props;
    const queryData = { ...query, mchId };
    dispatch(reportCenterActions.getAllDeviceReportList(queryData));
  }

  fetchAllData = () => {
    const { mchId = '' } = this.props;
    this.props.dispatch(reportCenterActions.getAllDeviceReportData({ mchId }));
  }

  handleTabChange = (activeKey) => {
    let selectedDate = this.getQueryDate(activeKey);
    this.setState({
      tabCurrent: activeKey,
      showTable: false,
      selectedDate,
    }, () => {
      if (activeKey !== '5' && activeKey !== '4') {
        this.getData();
      } else if (activeKey === '4') {
        this.fetchAllList();
        this.fetchAllData();
      }
    });
  }

  toggleDownloadReport = (visible) => {
    this.setState({ visible });
  }

  downloadReportDetail = () => {
    const { downloadDate } = this.state;
    const { dispatch, mchId } = this.props;
    if (!downloadDate) {
      message.info('请选择要下载的日期');
    } else {
      const [startDay, endDay] = momentToFormatDate(downloadDate);
      dispatch(reportCenterActions.generateDeviceReport({ startDay, endDay, mchId }, () => {
        this.toggleDownloadReport(false);
        this.toggleDownloadManage(true);
      }));
    }
  }

  generateParams = (dateArr) => {
    const formated = momentToFormatDate(dateArr);
    const [startDay, endDay] = formated;
    return {
      startDay: addDateZero(startDay, true),
      endDay: addEndTime(endDay, true),
    };
  }

  onDateChange = (value) => {
    this.setState({
      downloadDate: value,
    });
  }

  onQueryDateChange = (value) => {
    const selectedDate = momentToFormatDate(value);
    const [startDay, endDay] = selectedDate;
    const start = moment(startDay);
    const end = moment(endDay);
    // 一共多少天
    const days = end.diff(start, 'days') + 1;
    if (days <= 31) {
      this.setState({
        selectedDate,
      }, () => {
        this.getData();
      });
    } else {
      message.error('单次最多可查看31天数据');
    }
  }

  disabledDate = (current) => {
    let { createTime, profile } = this.props;
    // 作为子组件时取传入的时间
    createTime = createTime || profile._mchCreateTime;
    let startDate = moment(createTime - 1 * 24 * 60 * 60 * 1000);
    let dayBefore = new Date().getTime();
    return current < startDate || current > moment(dayBefore);
  }

  openDetail = (data) => {
    const { onCheckDetail, dispatch, mchId } = this.props;
    const route = `/reportCenter/mchHomePage/${REPORT_TYPE_DEVICE}/${data.mchId}?mchType=${data.mchType}`;
    dispatch(push(route));
    if (mchId && onCheckDetail) {
      onCheckDetail({
        route,
        name: data.mchName,
      });
    }
  }

  renderLabel = () => {
    const { tabCurrent } = this.state;
    let labelName = '设备激活数';
    let labelName1 = '设备总数';
    let labelName2 = '设备激活率';
    if (tabCurrent === '1') {
      labelName = '今日设备激活数';
    } else if (tabCurrent === '2') {
      labelName = '最近一周激活数';
    } else if (tabCurrent === '3') {
      labelName = '最近十五天激活数';
    } else if (tabCurrent === '4') {
      labelName = '设备总激活数(实际激活)';
    }

    return {
      labelName,
      labelName1,
      labelName2,
    };
  }

  generateColumns = () => {
    const { tabCurrent, selectedDate } = this.state;
    const { authCode } = this.props;
    const hasAuth = authCode[1] === '1';
    const nameItems = [
      { dataIndex: 'mchName', title: '渠道名称' },
      { dataIndex: 'mchId', title: '代理商账户' },
    ];
    let newItems = [];
    if (tabCurrent === '1') {
      newItems = [
        {
          dataIndex: 'lstNum0', title: dateFormat(moment()),
        },
      ];
    } else if (tabCurrent === '2') {
      newItems = this.generateTableItem(7);
    } else if (tabCurrent === '3') {
      newItems = this.generateTableItem(15);
    } else if (tabCurrent === '4') {
      newItems = [
        { dataIndex: 'deviceTotalNum', title: '设备总数' },
        { dataIndex: 'activeDeviceTotalNum', title: '设备总激活数' },
        { dataIndex: 'activeRatio', title: '设备激活率', render: text => (text || text === 0 ? `${text}%` : '') },
      ];
    } else if (tabCurrent === '5') {
      if (selectedDate) {
        const [startDay, endDay] = selectedDate;
        const start = moment(startDay);
        const end = moment(endDay);
        // 一共多少天
        const days = end.diff(start, 'days') + 1;
        const offset = moment().diff(end, 'days');
        newItems = this.generateTableItem(days, offset);
      }
    }
    const actionItem = {
      dataIndex: 'x',
      title: '操作',
      width: ACTION_WIDTH,
      render: (_, record) => {
        const options = [
          { text: '查看详情', action: () => { this.openDetail(record); } },
        ];

        let hasAction = record.mchType === 0 && (hasAuth || checkIsTypeChain(record));
        return hasAction ? <OperationLink options={options} /> : null;
      },
    };
    const fixed = newItems.length > 7;
    if (fixed) {
      actionItem.fixed = 'right';
      nameItems[0].fixed = 'left';
      nameItems[0].width = 100;
      nameItems[1].fixed = 'left';
      nameItems[1].width = 120;
    }
    const tabColumns = [
      ...nameItems,
      ...newItems,
      actionItem,
    ];
    return tabColumns;
  }

  generateTableItem = (count, offset = 0) => {
    let array = [];
    let i = 0;
    while (i < count) {
      array.push({
        dataIndex: `lstNum${i}`, title: this.getDayBefore(i + offset),
      });
      i++;
    }
    return array;
  }

  handleSearch = () => {
    if (this.state.selectedDate) {
      this.getData();
    }
  }

  resetSearch = () => {
    this.setState({
      selectedDate: null,
    });
  }

  toggleDownloadManage = (visible) => {
    this.props.dispatch(downloadAction.toggleDownloadModal(visible, DEVICE_REPORT_DOWNLOAD));
  }

  render() {
    //filter
    const {
      getDeviceReportListResult: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      } = {},
      generateDeviceReportResult,
      getDeviceReportDataResult,
      getAllDeviceReportDataResult: {
        result: allDeviceReportData = {},
      },
    } = this.props;
    const { tabCurrent } = this.state;
    const {
      sum = 0,
    } = getDeviceReportDataResult.result || {};
    const {
      deviceTotalNum = 0,
      activeDeviceTotalNum = 0,
      activeRatio = 0,
    } = allDeviceReportData;

    const { labelName, labelName1, labelName2 } = this.renderLabel();
    let dataList = [
      {
        label: labelName,
        value: sum,
        icon: {
          type: 'money-collect',
        },
      },
    ];
    if (tabCurrent === '4') {
      dataList = [
        {
          label: labelName,
          value: activeDeviceTotalNum,
          icon: {
            type: 'money-collect',
          },
        },
        {
          label: labelName1,
          value: deviceTotalNum,
          icon: {
            type: 'reconciliation',
          },
          background: '#2DB6F4',
        },
        {
          label: labelName2,
          value: `${activeRatio}%`,
          icon: {
            type: 'hourglass',
          },
          background: '#87D067',
        },
      ];
    }
    const tabColumns = this.generateColumns();
    const listProps = {
      loading,
      rowKey: 'mchId',
      pagination: {
        current,
        total,
        pageSize,
      },
      dataSource,
      columns: tabColumns,
    };
    if (tabColumns.length > 15) {
      listProps.scroll = { x: (tabColumns.length - 3) * 98 + 300 };
    }
    const showTable = !!this.state.selectedDate;
    let pickerValue;
    if (this.state.selectedDate) {
      pickerValue = formatDateToMoment(this.state.selectedDate);
    }

    const tab1 = (<TabPane tab="今日" key="1">
      <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>
      <PageList {...listProps} />
    </TabPane>);

    const tab2 = (<TabPane tab="最近一周" key="2">
      <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>
      <PageList {...listProps} />
    </TabPane>);

    const tab3 = (<TabPane tab="最近十五天" key="3">
      <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>
      <PageList {...listProps} />
    </TabPane>);

    const tab4 = (<TabPane tab="全部" key="4">
      <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>
      <PageList {...listProps} />
    </TabPane>);

    const tab5 = (<TabPane tab="时间选择" key="5">
      {/* <PageFilter {...filterProps} /> */}
      <Form>
        <FormItem label="请选择时间：" {...formItemLayout}>
          <RangePicker
            value={pickerValue}
            onChange={this.onQueryDateChange}
            disabledDate={this.disabledDate}
          />
          <Button type="primary" className="range-picker-btns" onClick={this.handleSearch}>搜索</Button>
          <Button className="range-picker-btns" onClick={this.resetSearch}>清除</Button>
        </FormItem>
      </Form>
      {showTable && <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>}
      {showTable && <PageList {...listProps} />}
    </TabPane>);

    const modalOpts = {
      title: '数据下载',
      visible: this.state.visible,
      width: 600,
      footer: null,
      onCancel: () => this.toggleDownloadReport(false),
      maskClosable: false,
      destroyOnClose: true,
    };

    return (
      <div className="page-report-center">
        <div className="content-header">
          <h2>设备激活统计</h2>
          {!this.props.isTaxi && <div className="operation">
            <Button className="g-btn-black" type="primary" onClick={() => this.toggleDownloadReport(true)}>
              <Icon type="download" theme="outlined" />报表下载
            </Button>
            <Button
              style={{ marginLeft: 30 }}
              className="g-btn-black"
              type="primary"
              onClick={() => this.toggleDownloadManage(true)}
            >
              下载管理
            </Button>
          </div>}
        </div>
        <div className="content-wrapper">
          <Tabs size="large" onChange={this.handleTabChange} activeKey={this.state.tabCurrent} >
            { [tab1, tab2, tab3, tab4, tab5] }
          </Tabs>
        </div>
        <Modal {...modalOpts} className="download-modal">
          <Form>
            <p className="text">设备使用情况数据，支持按时间段下载excel表格。</p>
            <FormItem label="请选择时间：" {...formItemLayout}>
              <RangePicker onChange={this.onDateChange} disabledDate={this.disabledDate} />
            </FormItem>
            <div className="download-btn">
              <Button
                type="primary"
                onClick={this.downloadReportDetail}
                loading={generateDeviceReportResult.loading}
              >
                生成报表
              </Button>
            </div>
          </Form>
        </Modal>

        <DownloadModal taskType={DEVICE_REPORT_DOWNLOAD} />
      </div>
    );
  }
}

DeviceReportPage.propTypes = {
  dispatch: PropTypes.func.isRequired,
  mchId: PropTypes.string,
  isTaxi: PropTypes.bool,
  location: PropTypes.object.isRequired,
  createTime: PropTypes.number,
  profile: PropTypes.object.isRequired,
  onCheckDetail: PropTypes.func,
  getDeviceReportListResult: PropTypes.object.isRequired,
  downloadLink: PropTypes.object.isRequired,
  getDeviceReportDataResult: PropTypes.object.isRequired,
  getAllDeviceReportDataResult: PropTypes.object.isRequired,
  authCode: PropTypes.string.isRequired,
  generateDeviceReportResult: PropTypes.object,
};

DeviceReportPage.defaultProps = {
  mchId: '',
  isTaxi: false,
  createTime: 0,
  onCheckDetail: null,
  generateDeviceReportResult: {},
};


export default connect(({ reportCenter: {
  getDeviceReportListResult,
  downloadLink,
  getDeviceReportDataResult,
  getAllDeviceReportListResult,
  getAllDeviceReportDataResult,
  generateDeviceReportResult,
}, global: { profile, authCode } }) => ({
  getDeviceReportListResult,
  downloadLink,
  profile,
  getDeviceReportDataResult,
  authCode,
  getAllDeviceReportListResult,
  getAllDeviceReportDataResult,
  generateDeviceReportResult,
}))(DeviceReportPage);
