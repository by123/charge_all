import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Drawer, message } from 'antd';
import moment from 'moment';
import { PageFilter } from '@/containers/PageFilter';
import { PageList } from '@/containers/PageList';
import { orderStatus, payTypes, endTypes } from '@/utils/enum';
import {
  checkIsSuperAdmin,
  mapObjectToRadios,
  datetimeFormat,
  formatDecimal,
  formatMoney,
  dateFormat,
  formatGroupListToRadio,
} from '@/utils';
import { OperationLink } from '@/components/OperationLink';
import { RefundModal } from '@/containers/Refund/RefundModal';
import { push } from '@/store/router-helper';
import { INDEX_WIDTH, ACTION_WIDTH } from '@/utils/constants';
import { action as orderActions } from './store';
import { OrderDetail } from './OrderDetail';
import { action as deviceActions } from '../Device/store';
import { OrderDownloadModal } from './OrderDownloadModal';
import { QueryPasswordModal } from './QueryPasswordModal';
import { NoGroupModal } from '../Group/NoGroupModal';

class OrderPage extends React.Component {
  openDetail = (orderId) => {
    this.props.dispatch(orderActions.fetchOrderDetail({ orderId }));
    this.props.dispatch(orderActions.toggleDetailModal(true));
  }

  closeDetail = () => {
    this.props.dispatch(orderActions.toggleDetailModal(false));
  }

  openRefundModal = (record) => {
    this.props.dispatch(orderActions.toggleRefundModal(true, record));
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(orderActions.fetchOrderList(search));
  }

  componentDidMount() {
    const { location: { query }, dispatch } = this.props;
    if (!query.payTimeStart && !query.payTimeEnd) {
      const today = dateFormat(moment().subtract('days'));
      const payTimeStart = encodeURIComponent(`${today} 00:00:00`);
      const payTimeEnd = encodeURIComponent(`${today} 23:59:59`);
      dispatch(push(`/taxi/order?payTimeEnd=${payTimeEnd}&payTimeStart=${payTimeStart}`));
    } else {
      this.fetchList();
    }
    this.queryAllGroup();
  }

  queryAllGroup = () => {
    const { profile: { mchId }, dispatch } = this.props;
    dispatch(deviceActions.queryGroup({ mchId }));
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  handleChangeTime(fields) {
    const { location, dispatch } = this.props;
    dispatch(push({ ...location, query: fields }));
  }

  toggleDownloadReport = (visible) => {
    const { dispatch, location: { search } } = this.props;
    dispatch(orderActions.toggleDownloadReport(visible));
    dispatch(orderActions.generateOrderDownloadLink(search, () => {
      const { result } = this.props.downloadLink || {};
      if (!result || !result.resourceUrl) {
        message.error('生成下载链接失败，请重试');
        dispatch(orderActions.cleanDownloadLink());
      }
    }));
  }

  checkDownload = (total) => {
    if (total === 0) {
      message.warn('当前条件无订单数据，请重新选择筛选条件');
    } else if (total > 5000) {
      message.warn('提示：下载报表订单数不可超过5000条');
    } else {
      this.toggleDownloadReport(true);
    }
  }

  onRefundOk = (fields) => {
    this.props.dispatch(orderActions.orderRefund(fields));
  }

  onRefundCancel = () => {
    this.props.dispatch(orderActions.toggleRefundModal(false));
  }

  render() {
    const {
      location: { search },
      detailVisible,
      orderList: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
        originalData = {},
      },
      profile,
      refundData,
      refundVisible,
      current: currentOrder,
      authCode,
      groupList,
    } = this.props;
    const isSuperAdmin = checkIsSuperAdmin(profile, 4);
    let filterProps = {
      search,
      columns: [
        { dataIndex: 'orderId', title: '订单号' },
        { dataIndex: 'orderState', title: '订单状态', type: 'select', list: mapObjectToRadios(orderStatus) },
        { dataIndex: 'date', title: '支付时间', type: 'dateArea', startKey: 'payTimeStart', endKey: 'payTimeEnd', isTime: true },
        { dataIndex: 'deviceSn', title: '设备编号' },
        { dataIndex: 'payType', title: '支付方式', type: 'select', list: mapObjectToRadios(payTypes) },
        { dataIndex: 'userName', title: '用户昵称' },
        { dataIndex: 'contactPhone', title: '司机手机号' },
        { dataIndex: 'lstGroupId', title: '所属分组', type: 'select', list: formatGroupListToRadio(groupList.result || []) },
      ],
    };
    filterProps.columns.push({
      dataIndex: 'lstMchId',
      title: '代理商账号',
      type: 'agentFilter',
      isFull: true,
      changeOnSelect: true,
      childUseable: authCode[0] === '1',
      showAll: false,
      width: 350,
      showMchId: true,
    });

    let columns = [
      { dataIndex: 'id', title: '序号', fixed: 'left', width: INDEX_WIDTH },
      { dataIndex: 'orderId', title: '订单号', fixed: 'left', width: 140 },
      { dataIndex: 'orderName', title: '商品名', fixed: 'left', width: 100 },
      { dataIndex: 'payTime', title: '订单支付时间', width: 130, render: text => datetimeFormat(text) },
      { dataIndex: 'endMode', title: '结束方式', render: text => endTypes[text] },
      { dataIndex: 'orderPriceYuan', title: '订单金额', render: text => formatDecimal(text) },
      { dataIndex: 'depositPriceYuan', title: '押金', render: text => formatDecimal(text) },
      { dataIndex: 'servicePriceYuan', title: '消费金额', render: text => formatDecimal(text) },
      { dataIndex: 'myProfit', title: '我的收益', render: text => formatDecimal(text) },
      { dataIndex: 'descendantsTotalProfit', title: '下级收益', render: text => formatDecimal(text) },
      { dataIndex: 'payType', title: '支付方式', render: (text) => payTypes[text] },
      { dataIndex: 'userName', title: '用户昵称' },
      { dataIndex: 'deviceSn', title: '设备编号', width: 140 },
      { dataIndex: 'groupName', title: '所属分组', width: 120 },
      { dataIndex: 'orderStateWeb', title: '支付状态', fixed: 'right', render: (text) => orderStatus[text], width: 74 },
      {
        dataIndex: 'x',
        title: '操作',
        fixed: 'right',
        width: ACTION_WIDTH,
        render: (_, record) => {
          const options = [
            { text: '查看', action: () => { this.openDetail(record.orderId); } },
          ];
          if ((record.orderStateWeb === 2 || record.orderStateWeb === 3) && (isSuperAdmin || record.canRefund)) {
            options.push({ text: '退款', action: () => { this.openRefundModal(record); } });
          }
          return <OperationLink options={options} />;
        },
      },
    ];
    const listProps = {
      loading,
      rowKey: 'orderId',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns,
      dataSource,
      scroll: { x: 1500 },
    };
    return (<div className="page-order">
      <div className="content-header">
        <h2>订单管理</h2>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-desc">
        <p>
          <span>共搜索到 {total} 笔订单，订单金额：{formatMoney(originalData.serviceSumYuan) || 0.00}元</span>
          {/* <Button style={{ marginLeft: 30 }} className="g-btn-black" type="primary" onClick={() => this.checkDownload(total)}>
            <Icon type="download" theme="outlined" />订单下载
          </Button> */}
        </p>
      </div>
      <PageList {...listProps} />
      <div style={{ marginLeft: 20 }}>订单超过24小时不可退款</div>
      <Drawer title="订单详情" width="80%" visible={detailVisible} onClose={this.closeDetail}>
        <OrderDetail />
      </Drawer>
      <RefundModal
        order={currentOrder}
        visible={refundVisible}
        saveData={refundData}
        onOk={this.onRefundOk}
        onCancel={this.onRefundCancel}
      />
      <OrderDownloadModal filterColumns={filterProps.columns} params />
      <QueryPasswordModal />
      <NoGroupModal />
    </div>);
  }
}

OrderPage.propTypes = {
  orderList: PropTypes.object,
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  profile: PropTypes.object,
  refundVisible: PropTypes.bool.isRequired,
  current: PropTypes.object,
  refundData: PropTypes.object,
  authCode: PropTypes.string.isRequired,
  downloadLink: PropTypes.object.isRequired,
  detailVisible: PropTypes.bool.isRequired,
  groupList: PropTypes.object.isRequired,
};

OrderPage.defaultProps = {
  orderList: {},
  profile: {},
  current: {},
  refundData: {},
};

export default connect(({ taxiOrder: {
  orderList,
  detailVisible,
  downloadLink,
  refundVisible,
  current,
  refundData,
}, taxiDevice: { groupList }, global: { profile, authCode } }) => ({
  orderList,
  detailVisible,
  downloadLink,
  profile,
  refundVisible,
  current,
  refundData,
  authCode,
  groupList,
}))(OrderPage);
