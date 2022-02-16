/**
 * 该页面同时作为商户主页的内容页
 */
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { connect } from 'react-redux';
import { Tabs, Button, Icon, message, Modal, Form } from 'antd';
import { PageList } from '../../containers/PageList';
import { action as serviceCenterActions } from './store';
import { action as initializeActions } from '../Initialize/store';
import { DownloadModal } from '../DownloadModal';
import { action as downloadAction } from '../DownloadModal/store';
import { push } from '../../store/router-helper';
import { complaintsType, resolveType } from '../../utils/enum';
import { CUSTOMER_REPORT } from '../../utils/constants';
import { DatePicker } from '../../components/pop';
import {
  dateFormat,
  momentToFormatDate,
  addDateZero,
  addEndTime,
  datetimeFormat,
  mapObjectToRadios,
  formatDateToMoment,
} from '../../utils';
import './style.less';

const FormItem = Form.Item;
const { RangePicker } = DatePicker;
const { TabPane } = Tabs;

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
const TabList = [
  { key: '1', actionName: 'getTelRecordStats', title: '来电数据统计' },
  { key: '2', actionName: 'getDeviceProblemStats', title: '设备投诉问题' },
  { key: '3', actionName: 'getTelResolveStats', title: '解决情况' },
  { key: '4', actionName: 'getComplainVersionStats', title: '设备版本' },
  { key: '5', actionName: 'getCompainTypeStats', title: '投诉类型' },
  { key: '6', actionName: 'getTelCustomerStats', title: '处理客服' },
];

class ComplainReportPage extends Component {
  constructor(props) {
    super(props);
    const endDate = moment().format('YYYY-MM-DD');
    const startDate = moment().subtract(7, 'days').format('YYYY-MM-DD');
    this.state = {
      visible: false,
      downloadDate: '',
      queryDate: [startDate, endDate],
    };
  }

  componentDidMount = () => {
    this.getInitData();
    this.fetchList();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  getInitData = () => {
    const { dispatch } = this.props;
    dispatch(serviceCenterActions.getAllCustomer());
    dispatch(serviceCenterActions.getProblemList());
    dispatch(initializeActions.getVersionList());
  }

  getTabCurrent = () => {
    const { location: { query } } = this.props;
    let tabCurrent = query.tab || TabList[0].key;
    return tabCurrent;
  }

  fetchList = () => {
    const { location: { query } } = this.props;
    const tabCurrent = this.getTabCurrent();
    const { queryDate } = this.state;
    const [beginDate, endDate] = queryDate;
    let actionKey = '';
    TabList.forEach((tab, index) => {
      if (tab.key === tabCurrent) {
        actionKey = TabList[index].actionName;
        return false;
      }
    });
    this.props.dispatch(serviceCenterActions[actionKey]({
      pageSize: 7,
      pageId: 1,
      ...query,
      beginDate,
      endDate,
    }));
  }

  handleTabChange = (activeKey) => {
    const { dispatch } = this.props;
    dispatch(push(`/serviceCenter/complainReport?tab=${activeKey}`));
  }

  toggleDownloadReport = (visible) => {
    this.setState({ visible });
  }

  toggleDownloadManage = (visible) => {
    this.props.dispatch(downloadAction.toggleDownloadModal(visible, CUSTOMER_REPORT));
  }

  downloadReportDetail = () => {
    const { downloadDate } = this.state;
    const { dispatch } = this.props;
    if (!downloadDate) {
      message.info('请选择要下载的日期');
    } else {
      const [bgnTime, endTime] = this.generateParams(downloadDate);
      dispatch(serviceCenterActions.applyDownloadComplain({ bgnTime, endTime }, () => {
        this.toggleDownloadReport(false);
        this.toggleDownloadManage(true);
      }));
    }
  }

  generateParams = (dateArr) => {
    const formated = momentToFormatDate(dateArr);
    const [beginDate, endDate] = formated;
    return [addDateZero(beginDate, true), addEndTime(endDate, true)];
  }

  onDateChange = (value) => {
    this.setState({
      downloadDate: value,
    });
  }

  onListDateChange = (dateArr) => {
    this.setState({
      queryDate: momentToFormatDate(dateArr),
    }, this.fetchList);
  }

  disabledDate = (current) => {
    let dayBefore = new Date().getTime();
    return current > moment(dayBefore);
  }

  getTimeItem = () => {
    return {
      dataIndex: 'statisticalDate',
      title: '时间',
      render: text => datetimeFormat(text, 'MM月DD日'),
    };
  }

  getVersionColumns = () => {
    const columns = [
      this.getTimeItem(),
    ];
    const { versionListResult: { result: versionList = [] } } = this.props;
    versionList.forEach(item => {
      columns.push({
        dataIndex: `${item.deviceVersion}`, title: `V${item.deviceVersion}`,
      });
    });
    return columns;
  }

  getProblesColumns = () => {
    const columns = [
      this.getTimeItem(),
      { dataIndex: 'total', title: '总计' },
    ];
    const { getProblemListResult: { result = {} } } = this.props;
    this.listDataToColumns(result, columns);
    return columns;
  }

  listDataToColumns = (enumType, columns) => {
    const dataArray = mapObjectToRadios(enumType);
    dataArray.forEach(item => {
      columns.push({
        dataIndex: item.value, title: item.label,
      });
    });
  }

  getResolveColumns = () => {
    const columns = [
      this.getTimeItem(),
    ];
    this.listDataToColumns(resolveType, columns);
    return columns;
  }

  getComplainTypeColumns = () => {
    const columns = [
      this.getTimeItem(),
    ];
    this.listDataToColumns(complaintsType, columns);
    return columns;
  }

  getCustomerColumns = () => {
    const columns = [
      this.getTimeItem(),
    ];
    const { getAllCustomerResult: { result: customerList = [] } } = this.props;
    customerList.forEach(item => {
      columns.push({
        dataIndex: item.userId, title: item.name,
      });
    });
    return columns;
  }

  getColumns = (index) => {
    const tabColumns0 = [
      this.getTimeItem(),
      { dataIndex: 'receivedCall', title: '已接来电' },
      { dataIndex: 'missedCall', title: '未接来电', editable: true, min: 0 },
      { dataIndex: 'callTotal8319', title: '来电总数8319', editable: true, min: 0 },
      { dataIndex: 'callTotal7553', title: '来电总数7553', editable: true, min: 0 },
      { dataIndex: 'callTotal', title: '真实来电总数', editable: true, min: 0 },
      { dataIndex: 'missedCall2to9', title: '2点-9点未接来电', editable: true, min: 0 },
      { dataIndex: 'missedCall2to9Real', title: '2点到9点真实未接来电', editable: true, min: 0 },
    ];
    const tabColumns1 = this.getProblesColumns();
    const tabColumns2 = this.getResolveColumns();
    const tabColumns3 = this.getVersionColumns();
    const tabColumns4 = this.getComplainTypeColumns();
    const tabColumns5 = this.getCustomerColumns();

    const columnsList = {
      tabColumns0,
      tabColumns1,
      tabColumns2,
      tabColumns3,
      tabColumns4,
      tabColumns5,
    };
    return columnsList[`tabColumns${index}`];
  }

  generateTabList = () => {
    return TabList.map((tab, index) => {
      const {
        loading,
        current = 1,
        total = 0,
        pageSize = 7,
        dataSource,
      } = this.props[`${tab.actionName}Result`] || {};
      const listProps = {
        loading,
        rowKey: 'statisticalDate',
        pagination: {
          current,
          total,
          pageSize,
        },
        dataSource,
      };
      if (index === 0) {
        listProps.editable = true;
        listProps.onSave = this.onEditRecord;
      }
      return (<TabPane tab={tab.title} key={tab.key}>
        <PageList {...listProps} columns={this.getColumns(index)} />
      </TabPane>);
    });
  }

  onEditRecord = (values, record) => {
    let { statisticsDate } = record;
    statisticsDate = dateFormat(statisticsDate);
    this.props.dispatch(serviceCenterActions.modTelRecordStats({ ...values, statisticsDate }, () => {
      message.success('编辑成功');
      this.fetchList();
    }));
  }

  render() {
    //filter
    const {
      applyDownloadComplainResult: {
        loading,
      },
    } = this.props;

    const modalOpts = {
      title: '数据下载',
      visible: this.state.visible,
      width: 600,
      footer: null,
      onCancel: () => this.toggleDownloadReport(false),
      maskClosable: false,
      destroyOnClose: true,
    };

    const listDate = formatDateToMoment(this.state.queryDate);
    return (
      <div className="page-report-center">
        <div className="content-header">
          <h2>数据汇总</h2>
          <div className="operation">
            <Button className="g-btn-black" type="primary" onClick={() => this.toggleDownloadReport(true)}>
              <Icon type="download" theme="outlined" />数据下载
            </Button>
            <Button className="g-btn-black" type="primary" onClick={() => this.toggleDownloadManage(true)}>
              下载管理
            </Button>
          </div>
        </div>
        <div className="content-wrapper">
          <Form>
            <FormItem label="请选择时间：" {...formItemLayout}>
              <RangePicker
                allowClear={false}
                value={listDate}
                onChange={this.onListDateChange}
                disabledDate={this.disabledDate}
              />
            </FormItem>
          </Form>
          <Tabs size="large" onChange={this.handleTabChange} activeKey={this.getTabCurrent()} >
            { this.generateTabList() }
          </Tabs>
        </div>
        <Modal {...modalOpts} className="download-modal">
          <Form>
            <p style={{ marginBottom: 20, fontSize: 16 }}>数据支持按时间段下载excel表格</p>
            <FormItem label="请选择时间：" {...formItemLayout}>
              <RangePicker onChange={this.onDateChange} disabledDate={this.disabledDate} />
            </FormItem>
            <div style={{ textAlign: 'center' }}>
              <Button
                type="primary"
                onClick={this.downloadReportDetail}
                loading={loading}
              >
                生成报表
              </Button>
            </div>
          </Form>
        </Modal>
        <DownloadModal taskType={CUSTOMER_REPORT} />
      </div>
    );
  }
}

ComplainReportPage.propTypes = {
  dispatch: PropTypes.func.isRequired,
  getCompainTypeStatsResult: PropTypes.object.isRequired,
  getDeviceProblemStatsResult: PropTypes.object.isRequired,
  getComplainVersionStatsResult: PropTypes.object.isRequired,
  getTelRecordStatsResult: PropTypes.object.isRequired,
  getTelResolveStatsResult: PropTypes.object.isRequired,
  getTelCustomerStatsResult: PropTypes.object.isRequired,
  modTelRecordStatsResult: PropTypes.object.isRequired,
  versionListResult: PropTypes.object.isRequired,
  getProblemListResult: PropTypes.object.isRequired,
  getAllCustomerResult: PropTypes.object.isRequired,
  applyDownloadComplainResult: PropTypes.object,
};

ComplainReportPage.defaultProps = {
  applyDownloadComplainResult: {},
};


export default connect(({
  serviceCenter: {
    getCompainTypeStatsResult,
    getDeviceProblemStatsResult,
    getComplainVersionStatsResult,
    getTelRecordStatsResult,
    getTelResolveStatsResult,
    getTelCustomerStatsResult,
    modTelRecordStatsResult,
    getProblemListResult,
    getAllCustomerResult,
    applyDownloadComplainResult,
  },
  active: {
    versionListResult,
  },
}) => ({
  getCompainTypeStatsResult,
  getDeviceProblemStatsResult,
  getComplainVersionStatsResult,
  getTelRecordStatsResult,
  getTelResolveStatsResult,
  getTelCustomerStatsResult,
  modTelRecordStatsResult,
  versionListResult,
  getProblemListResult,
  getAllCustomerResult,
  applyDownloadComplainResult,
}))(ComplainReportPage);
