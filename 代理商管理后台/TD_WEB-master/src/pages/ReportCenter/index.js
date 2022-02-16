/**
 * 该页面同时作为商户主页的内容页
 */
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { connect } from 'react-redux';
import { Tabs, Button, Icon, message, Row, Col, Modal, Form, DatePicker } from 'antd';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { OperationLink } from '../../components/OperationLink';
import { DataCard } from '../../components/Charts/DataCard';
import { dateFormat, getId, momentToFormatDate, addDateZero, addEndTime, getDownloadFileName, checkIsTypeChain } from '../../utils';
import { action as reportCenterActions } from './store';
import { push } from '../../store/router-helper';
import './style.less';
import { ACTION_WIDTH, REPORT_TYPE_PROFIT } from '../../utils/constants';

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
const yesterday = dateFormat(moment().subtract(1, 'days'));
const today = dateFormat(moment().subtract('days'));
function renderMchName(text, record) {
  return record.mchType === -2 || record.mchType === -3 ? '' : text;
}

class ReportCenter extends Component {
  constructor(props) {
    super(props);
    this.state = {
      tabCurrent: '1',
      visible: false,
      downloadDate: '',
      showTable: false,
      queryDate: yesterday,
    };
  }

  // 数据模块
  fetchDeviceUsingCondition = () => {
    const { dispatch, mchId = '', isTaxi } = this.props;
    let queryData = {};
    let dataKey;
    if (mchId) {
      queryData.mchId = mchId;
    }
    if (this.state.tabCurrent === '1') {
      queryData.queryDate = yesterday;
    } else if (this.state.tabCurrent === '3') {
      queryData.queryDate = getId('queryDate');
      dataKey = 'coditionByDate';
    }
    isTaxi && (queryData.mchType = -2);
    dispatch(reportCenterActions.getDeviceUsingCondition(queryData, dataKey));
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
    if (this.state.tabCurrent === '3') { //自由时间选择
      this.fetchDeviceUsingSelectList();
    } else if (this.state.tabCurrent === '2') { //总计
      this.fetchDeviceUsingTotalList();
    } else { //昨天
      this.fetchDeviceUsingYesterDayList();
    }
  }

  handleTabChange = (activeKey) => {
    const { dispatch, location: { query } } = this.props;
    let queryDate = yesterday;
    if (activeKey === '2') {
      queryDate = '';
    } else if (activeKey === '3') {
      queryDate = getId('queryDate');
    }
    this.setState({
      tabCurrent: activeKey,
      showTable: false,
      queryDate,
    }, () => {
      const params = {};
      dispatch(push({ ...query, params }));
    });
  }

  toggleDownloadReport = (visible) => {
    if (!visible) {
      this.props.dispatch(reportCenterActions.cleanDownloadLink());
    }
    this.setState({ visible });
  }

  downloadReportDetail = () => {
    const { downloadDate } = this.state;
    const { dispatch, mchId } = this.props;
    if (!downloadDate) {
      message.info('请选择要下载的日期');
    } else {
      const query = this.generateParams(downloadDate);
      dispatch(reportCenterActions.generateDownloadLink({ ...query, mchId }, () => {
        const { result } = this.props.downloadLink || {};
        if (!result.resourceUrl) {
          message.error('生成下载链接失败，请重试');
          dispatch(reportCenterActions.cleanDownloadLink());
        }
      }));
    }
  }

  generateParams = (dateArr) => {
    const formated = momentToFormatDate(dateArr);
    const [beginDate, endDate] = formated;
    return {
      beginDate: addDateZero(beginDate, true),
      endDate: addEndTime(endDate, true),
    };
  }

  onDateChange = (value) => {
    this.setState({
      downloadDate: value,
    });
  }

  componentDidMount = () => {
    this.fetchDeviceUsingCondition();
    this.fetchList();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location) && this.state.activeKey !== '3') {
      this.fetchList();
      this.fetchDeviceUsingCondition();
    }
  }

  disabledDate = (current) => {
    let { createTime, profile } = this.props;
    // 作为子组件时取传入的时间
    createTime = createTime || profile._mchCreateTime;
    let startDate = moment(createTime - 1 * 24 * 60 * 60 * 1000);
    let dayBefore = new Date().getTime() - 1 * 24 * 60 * 60 * 1000;
    return current < startDate || current > moment(dayBefore);
  }

  openDetail = (data) => {
    const { onCheckDetail, dispatch, mchId } = this.props;
    const route = `/reportCenter/mchHomePage/${REPORT_TYPE_PROFIT}/${data.mchId}?mchType=${data.mchType}`;
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
    let labelName = '我的总收益（元）';
    let labelName2 = '昨日设备订单率';
    let labelName3 = '设备总使用数（个）';
    let labelName4 = '总订单数';
    let mchNameTitle = '渠道名称';
    let mchIdTitle = '代理商账号';
    if (tabCurrent === '1') {
      labelName = '昨日收益（元）';
      labelName3 = '昨日设备使用数（个）';
      labelName4 = '昨日订单数';
    } else if (tabCurrent === '2') {
      labelName2 = '设备使用率';
    } else if (tabCurrent === '3') {
      labelName2 = '设备订单率';
    }
    if (this.props.isTaxi) {
      mchNameTitle = '分组名称';
      mchIdTitle = '分组账号';
    }

    return {
      labelName,
      labelName2,
      labelName3,
      labelName4,
      mchNameTitle,
      mchIdTitle,
    };
  }

  render() {
    //filter
    const {
      location: { search } = {},
      childrenDeviceUsingConditionList: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      } = {},
      downloadLink,
      coditionByDate,
      childConditionByDate,
      deviceUsingConditionList,
      authCode,
    } = this.props;
    const hasAuth = authCode[1] === '1';
    const filterProps = {
      search,
      columns: [
        { dataIndex: 'queryDate', title: '时间选择', type: 'datePicker', notToday: true },
      ],
    };

    const listProps = {
      loading,
      rowKey: 'index',
      pagination: {
        current,
        total,
        pageSize,
      },
      dataSource,
    };
    const { tabCurrent } = this.state;
    const dataKey = tabCurrent === '3' ? coditionByDate : deviceUsingConditionList;
    const {
      total: {
        deviceUsingPercent = 0,
        orderNum = 0,
        usingDeviceNum = 0,
        profitYuan = 0,
        totalIncomeYuan = 0,
        orderPercent = 0,
      } = {},
      // taxi,
    } = dataKey.result || {};

    // const {
    //   // deviceUsingPercent: taxiDeviceUsingPercent = 0,
    //   // orderNum: taxiOrderNum = 0,
    //   // profitYuan: taxiProfitYuan = 0,
    //   // totalIncomeYuan: taxiTotalIncomeYuan = 0,
    //   // usingDeviceNum: taxiUsingDeviceNum = 0,
    //   // orderPercent: taxiOrderPercent = 0,
    // } = taxi || {};

    // const labelName = tabCurrent === '1' ? '昨日收益（元）' : '我的总收益（元）';
    // let labelName2 = '昨日设备订单率';
    // const labelName3 = tabCurrent === '1' ? '昨日设备使用数（个）' : '设备总使用数（个）';
    // const labelName4 = tabCurrent === '1' ? '昨日订单数' : '总订单数';
    // const profit = (tabCurrent === '1' || getId('queryDate') !== undefined) ? profitYuan : totalIncomeYuan;
    let profit = totalIncomeYuan;
    // let taxiProfit = taxiProfitYuan;
    if (tabCurrent === '1' || getId('queryDate') !== undefined) {
      profit = profitYuan;
    }
    let percent = orderPercent;
    // let taxiPercent = taxiOrderPercent;
    if (tabCurrent === '2') {
      percent = deviceUsingPercent;
      // taxiPercent = taxiDeviceUsingPercent;
      // taxiProfit = taxiTotalIncomeYuan;
    } else if (tabCurrent === '3') {
      // labelName2 = '设备订单率';
    }
    const { labelName, labelName2, labelName3, labelName4, mchNameTitle, mchIdTitle } = this.renderLabel();
    const actionItem = {
      dataIndex: 'x',
      title: '操作',
      width: ACTION_WIDTH,
      render: (_, record) => {
        const options = [
          { text: '查看详情', action: () => { this.openDetail(record); } },
        ];

        let hasAction = record.mchType === 0 && (hasAuth || checkIsTypeChain(record));
        // 出租车业务
        hasAction = hasAction || record.mchType === -2;
        return hasAction ? <OperationLink options={options} /> : null;
      },
    };
    const dataList = [
      {
        label: labelName,
        value: profit,
        icon: {
          type: 'money-collect',
        },
        // children: {
        //   label: `出租车${labelName}`,
        //   value: taxiProfit,
        // },
      },
      {
        label: labelName2,
        value: percent === 0 ? percent : `${percent}%`,
        icon: {
          type: 'reconciliation',
        },
        background: '#2DB6F4',
        // children: {
        //   label: `出租车${labelName2}`,
        //   value: taxiPercent === 0 ? taxiPercent : `${taxiPercent}%`,
        // },
      },
      {
        label: labelName3,
        value: usingDeviceNum,
        icon: {
          type: 'hourglass',
        },
        background: '#87D067',
        // children: {
        //   label: `出租车${labelName3}`,
        //   value: taxiUsingDeviceNum,
        // },
      },
      {
        label: labelName4,
        value: orderNum,
        icon: {
          type: 'android',
        },
        background: '#666666',
        // children: {
        //   label: `出租车${labelName4}`,
        //   value: taxiOrderNum,
        // },
      },
    ];
    const tab1Columns = [
      { dataIndex: 'mchName', title: mchNameTitle },
      { dataIndex: 'mchId', title: mchIdTitle, render: renderMchName },
      { dataIndex: 'salesName', title: '关联业务员' },
      { dataIndex: 'activeDeviceTotalNum', title: '截止昨日激活设备总数' },
      // { dataIndex: 'deviceUsingPercent', title: '昨日设备使用率', render: text => { return text !== 0 ? `${text}%` : 0; } },
      // { dataIndex: 'usingDeviceNum', title: '昨日使用设备数' },
      { dataIndex: 'orderNum', title: '昨日订单数' },
      { dataIndex: 'orderServiceNumYuan', title: '订单金额' },
      { dataIndex: 'orderPercent', title: '昨日订单率', render: text => { return text !== 0 ? `${text}%` : 0; } },
      { dataIndex: 'profitYuan', title: '昨日收益（元）' },
      actionItem,
    ];
    const tab2Columns = [
      { dataIndex: 'mchName', title: mchNameTitle },
      { dataIndex: 'mchId', title: mchIdTitle, render: renderMchName },
      { dataIndex: 'salesName', title: '关联业务员' },
      { dataIndex: 'activeDeviceTotalNum', title: '激活设备总数' },
      { dataIndex: 'deviceUsingPercent', title: '设备总使用率', render: text => { return text !== 0 ? `${text}%` : 0; } },
      { dataIndex: 'usingDeviceNum', title: '使用设备总数' },
      { dataIndex: 'orderNum', title: '总订单数' },
      { dataIndex: 'orderServiceNumYuan', title: '订单金额' },
      { dataIndex: 'profitYuan', title: '我的总收益（元）' },
      actionItem,
    ];
    const tab3Columns = [
      { dataIndex: 'mchName', title: mchNameTitle },
      { dataIndex: 'mchId', title: mchIdTitle, render: renderMchName },
      { dataIndex: 'salesName', title: '关联业务员' },
      { dataIndex: 'activeDeviceTotalNum', title: '激活设备总数' },
      // { dataIndex: 'deviceUsingPercent', title: '设备使用率', render: text => { return text !== 0 ? `${text}%` : 0; } },
      // { dataIndex: 'usingDeviceNum', title: '使用设备数' },
      { dataIndex: 'orderNum', title: '订单数' },
      { dataIndex: 'orderServiceNumYuan', title: '订单金额' },
      { dataIndex: 'orderPercent', title: '订单率', render: text => { return text !== 0 ? `${text}%` : 0; } },
      { dataIndex: 'profitYuan', title: '我的收益（元）' },
      actionItem,
    ];
    const {
      loading: condLoading = false,
      current: condCurrent = 1,
      total: condTotal = 0,
      pageSize: condPageSize = 15,
      dataSource: condDataSource,
    } = childConditionByDate || {};
    const { queryDate } = this.state;
    const tab3ListProps = Object.assign({}, listProps, {
      loading: condLoading,
      pagination: {
        current: condCurrent,
        total: condTotal,
        pageSize: condPageSize,
      },
      dataSource: condDataSource,
      columns: tab3Columns,
      queryDate,
    });
    const showTable = getId('queryDate');

    const tab1 = (<TabPane tab="昨日" key="1">
      <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>
      <PageList {...listProps} columns={tab1Columns} queryDate={queryDate} />
    </TabPane>);

    const tab2 = (<TabPane tab="历史总计" key="2">
      <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>
      <PageList {...listProps} columns={tab2Columns} queryDate={queryDate} />
    </TabPane>);

    const tab3 = (<TabPane tab="时间选择" key="3">
      <PageFilter {...filterProps} />
      {showTable && <Row className="data-collect" gutter={16}>
        {dataList.map((item, index) => (<Col key={index} {...ColProps}>
          <DataCard {...item} />
        </Col>))}
      </Row>}
      {showTable && <PageList {...tab3ListProps} />}
      {/* {!showTable && <div>请选择日期</div>} */}
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

    const downloadUrl = downloadLink.result || {};
    const { resourceUrl } = downloadUrl;
    const isGenerareing = !!downloadLink.loading;
    let downloadText = isGenerareing ? '报表生成中' : '生成报表';
    resourceUrl && (downloadText = '生成成功');
    return (
      <div className="page-report-center">
        <div className="content-header">
          <h2>渠道设备使用率与收益</h2>
          {!this.props.isTaxi && <div className="operation">
            <Button className="g-btn-black" type="primary" onClick={() => this.toggleDownloadReport(true)}>
              <Icon type="download" theme="outlined" />报表下载
            </Button>
          </div>}
        </div>
        <div className="content-wrapper">
          <Tabs size="large" onChange={this.handleTabChange} activeKey={this.state.tabCurrent} >
            { [tab1, tab2, tab3] }
          </Tabs>
        </div>
        <Modal {...modalOpts} className="download-modal">
          <Form>
            <p className="text">设备使用情况数据，支持按时间段下载excel表格。</p>
            <FormItem label="请选择时间：" {...formItemLayout}>
              <RangePicker onChange={this.onDateChange} disabledDate={this.disabledDate} />
            </FormItem>
            {resourceUrl && <div className="download-wrap clearfix">
              <span>{getDownloadFileName(resourceUrl)}</span>
              <a style={{ float: 'right' }} href="" onClick={() => window.open(resourceUrl)}>下载报表</a>
            </div>}
            <div className="download-btn">
              <Button type="primary" onClick={this.downloadReportDetail} disabled={!!resourceUrl} loading={isGenerareing}>{downloadText}</Button>
            </div>
          </Form>
        </Modal>
      </div>
    );
  }
}

ReportCenter.propTypes = {
  dispatch: PropTypes.func.isRequired,
  mchId: PropTypes.string,
  isTaxi: PropTypes.bool,
  location: PropTypes.object.isRequired,
  createTime: PropTypes.number,
  profile: PropTypes.object.isRequired,
  onCheckDetail: PropTypes.func,
  childrenDeviceUsingConditionList: PropTypes.object.isRequired,
  downloadLink: PropTypes.object.isRequired,
  coditionByDate: PropTypes.object.isRequired,
  childConditionByDate: PropTypes.object.isRequired,
  deviceUsingConditionList: PropTypes.object.isRequired,
  authCode: PropTypes.string.isRequired,
};

ReportCenter.defaultProps = {
  mchId: '',
  isTaxi: false,
  createTime: 0,
  onCheckDetail: null,
};


export default connect(({ reportCenter: {
  childrenDeviceUsingConditionList,
  deviceUsingConditionList,
  downloadLink,
  childConditionByDate,
  coditionByDate,
}, global: { profile, authCode } }) => ({
  childrenDeviceUsingConditionList,
  deviceUsingConditionList,
  downloadLink,
  profile,
  // createTime: profile._mchCreateTime,
  childConditionByDate,
  coditionByDate,
  authCode,
}))(ReportCenter);
