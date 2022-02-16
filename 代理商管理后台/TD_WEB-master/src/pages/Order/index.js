import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Drawer, Button, Icon, message, Modal } from 'antd';
import moment from 'moment';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { action as orderActions } from './store';
import { action as deviceActions } from '../Device/store';
import { action as serviceCenterActions } from '../ServiceCenter/store';
import { orderStatus, payTypes, endTypes } from '../../utils/enum';
import { mapObjectToRadios, datetimeFormat, formatDecimal, formatMoney, dateFormat, checkIsSuperAdmin } from '../../utils';
import { OperationLink } from '../../components/OperationLink';
import { OrderDetail } from '../../containers/OrderDetail';
import { RefundModal } from '../../containers/Refund/RefundModal';
import { DownloadModal } from '../DownloadModal';
import { action as downloadAction } from '../DownloadModal/store';
import { push } from '../../store/router-helper';
import { INDEX_WIDTH, ACTION_WIDTH, ORDER_DOWNLOAD } from '../../utils/constants';
import { OrderDownloadModal } from './OrderDownloadModal';
import { QueryPasswordModal } from './QueryPasswordModal';
import { EditComplainModal } from '../../containers/EditComplainModal';

class OrderPage extends React.Component {
  state = {
    orderId: '',
    isModalVisible: false,
    recoverOrder: null,
  }

  componentDidMount() {
    const { location: { query }, dispatch } = this.props;
    if (!query.payTimeStart && !query.payTimeEnd) {
      const today = dateFormat(moment().subtract('days'));
      const payTimeStart = encodeURIComponent(`${today} 00:00:00`);
      const payTimeEnd = encodeURIComponent(`${today} 23:59:59`);
      dispatch(push(`/order?payTimeEnd=${payTimeEnd}&payTimeStart=${payTimeStart}`));
    } else {
      this.fetchList();
    }
    this.queryAgent();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  openDetail = (orderId) => {
    this.setState({
      orderId,
    });
    this.getOrderDetail(orderId);
    this.props.dispatch(orderActions.toggleDetailModal(true));
  }

  closeDetail = () => {
    this.props.dispatch(orderActions.toggleDetailModal(false));
  }

  openRefundModal = (record) => {
    this.props.dispatch(orderActions.toggleRefundModal(true, record));
  }

  handleOk = () => {
    const { recoverOrder } = this.state;
    this.setState({
      isModalVisible: false,
    });
    const data = { orderId: recoverOrder.orderId, profit: false };
    this.props.dispatch(orderActions.recoverOrder(data));
  };

  handleCancel = () => {
    this.setState({
      isModalVisible: false,
    });
  };

  recoverOrder = (record) => {
    this.setState({
      isModalVisible: true,
      recoverOrder: record,
    });
    console.log(record);
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(orderActions.fetchOrderList(search));
  }

  getOrderDetail = (orderId) => {
    this.props.dispatch(orderActions.fetchOrderDetail({ orderId }));
  }

  queryAgent = () => {
    const { profile: { mchId }, dispatch } = this.props;
    dispatch(deviceActions.queryAgent({ mchId }));
  }

  handleChangeTime(fields) {
    const { location, dispatch } = this.props;
    dispatch(push({ ...location, query: fields }));
  }

  toggleDownloadReport = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(orderActions.generateOrderDownloadLink(search, () => {
      this.toggleDownloadManage(true);
    }));
  }

  checkDownload = (total) => {
    const { location: { query } } = this.props;
    if (total === 0) {
      message.warn('当前条件无订单数据，请重新选择筛选条件');
    } else if (!query.payTimeStart || !query.payTimeEnd) {
      message.warn('请选择订单支付时间');
    } else {
      this.toggleDownloadReport();
    }
  }

  onRefundOk = (fields) => {
    this.props.dispatch(orderActions.orderRefund(fields));
  }

  onRefundCancel = () => {
    this.props.dispatch(orderActions.toggleRefundModal(false));
  }

  toggleDownloadManage = (visible) => {
    this.props.dispatch(downloadAction.toggleDownloadModal(visible, ORDER_DOWNLOAD));
  }

  toggleCustomerModal = (visible) => {
    this.props.dispatch(serviceCenterActions.toggleCustomerModal(visible));
  }

  onAddPhoneRecord = () => {
    this.getOrderDetail(this.state.orderId);
  }

  getRealPrice = (text) => {
    return text;
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
      orderDetail: {
        result: orderDetail = {},
      },
    } = this.props;
    const { orderId, isModalVisible } = this.state;
    const isSuperAdmin = checkIsSuperAdmin(profile);
    let filterProps = {
      search,
      columns: [
        { dataIndex: 'orderId', title: '订单号' },
        { dataIndex: 'orderState', title: '订单状态', type: 'select', list: mapObjectToRadios(orderStatus) },
        {
          dataIndex: 'date',
          title: '支付时间',
          type: 'dateArea',
          startKey: 'payTimeStart',
          endKey: 'payTimeEnd',
          isTime: true,
          toZero: true,
        },
        { dataIndex: 'deviceSn', title: '设备编号' },
        { dataIndex: 'mchName', title: '所属商户' },
        { dataIndex: 'payType', title: '支付方式', type: 'select', list: mapObjectToRadios(payTypes) },
        { dataIndex: 'userName', title: '用户昵称' },
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
    // if (isSuperAdmin) {
    //   filterProps.columns.push({
    //     dataIndex: 'lstMchId',
    //     title: '代理商账号',
    //     type: 'agentFilter',
    //     isFull: true,
    //     changeOnSelect: true,
    //     childUseable: true,
    //     showAll: false,
    //     width: 250,
    //   });
    // } else {
    //   filterProps.columns.push({
    //     dataIndex: 'lstMchId',
    //     title: '代理商账号',
    //     type: 'select',
    //     colProps: agentAccountColProps,
    //     list: agentList,
    //     width: 300,
    //     itemAlias: { value: agentAccountValue, label: agentAccountLabel },
    //   });
    // }
    let columns = [
      { dataIndex: 'id', title: '序号', fixed: 'left', width: INDEX_WIDTH },
      { dataIndex: 'orderId', title: '订单号', fixed: 'left', width: 140 },
      { dataIndex: 'orderName', title: '商品名', fixed: 'left', width: 100 },
      { dataIndex: 'payTime', title: '订单支付时间', width: 130, render: text => datetimeFormat(text) },
      { dataIndex: 'endMode', title: '结束方式', render: text => endTypes[text] },
      { dataIndex: 'orderPriceYuan', title: '订单金额', render: text => formatDecimal(text) },
      { dataIndex: 'depositPriceYuan', title: '押金', render: text => formatDecimal(text) },
      { dataIndex: 'servicePriceYuan', title: '消费金额', render: (text, record) => formatDecimal(text - record.refundMoneyYuan - record.refundingMoneyYuan) },
      { dataIndex: 'myProfit', title: '我的收益', render: text => formatDecimal(text) },
      { dataIndex: 'descendantsTotalProfit', title: '下级收益', render: text => formatDecimal(text) },
      { dataIndex: 'payType', title: '支付方式', render: (text) => payTypes[text] },
      { dataIndex: 'userName', title: '用户昵称' },
      { dataIndex: 'deviceSn', title: '设备编号', width: 140 },
      { dataIndex: 'mchName', title: '所属商户', width: 120 },
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
          if (record.showType === 0 && isSuperAdmin) {
            options.push({ text: '恢复', action: () => { this.recoverOrder(record); } });
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

    const detailTitle = (<div>
      <span>订单详情</span>
      <Button
        style={{ marginLeft: 30 }}
        type="primary"
        disabled={orderDetail.addTelComplainExsit}
        onClick={() => this.toggleCustomerModal(true)}
      >
        客服处理
      </Button>
    </div>);

    return (<div className="page-order">
      <div className="content-header">
        <h2>订单管理</h2>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-desc">
        <p>
          <span>共搜索到 {total} 笔订单，订单金额：{formatMoney(originalData.serviceSumYuan) || 0.00}元</span>
          <Button
            style={{ marginLeft: 30 }}
            className="g-btn-black"
            type="primary"
            onClick={() => this.checkDownload(total)}
          >
            <Icon type="download" theme="outlined" />订单下载
          </Button>
          <Button
            style={{ marginLeft: 30 }}
            className="g-btn-black"
            type="primary"
            onClick={() => this.toggleDownloadManage(true)}
          >
            下载管理
          </Button>
        </p>
      </div>
      <PageList {...listProps} />
      <div style={{ marginLeft: 20 }}>订单超过24小时不可退款</div>
      <Drawer title={detailTitle} width="80%" visible={detailVisible} onClose={this.closeDetail}>
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
      <Modal title="确认恢复这笔订单吗？" visible={isModalVisible} onOk={this.handleOk} onCancel={this.handleCancel}>
        <p>恢复订单</p>
      </Modal>
      <DownloadModal taskType={ORDER_DOWNLOAD} />
      <EditComplainModal orderId={orderId} onOk={() => this.getOrderDetail(orderId)} />
    </div>);
  }
}

OrderPage.propTypes = {
  orderList: PropTypes.object,
  queryAgent: PropTypes.object,
  profile: PropTypes.object,
  refundVisible: PropTypes.bool.isRequired,
  current: PropTypes.object,
  refundData: PropTypes.object,
  authCode: PropTypes.string.isRequired,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  detailVisible: PropTypes.bool,
  orderDetail: PropTypes.object,
};

OrderPage.defaultProps = {
  orderList: {},
  queryAgent: {},
  profile: {},
  current: {},
  refundData: {},
  detailVisible: false,
  orderDetail: {},
};

export default connect(({ order: {
  orderList,
  detailVisible,
  downloadLink,
  refundVisible,
  current,
  refundData,
  orderDetail,
}, device: { queryAgent }, global: { profile, authCode } }) => ({
  orderList,
  detailVisible,
  queryAgent,
  downloadLink,
  profile,
  refundVisible,
  current,
  refundData,
  authCode,
  orderDetail,
}))(OrderPage);
