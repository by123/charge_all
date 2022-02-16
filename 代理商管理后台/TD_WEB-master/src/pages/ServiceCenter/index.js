import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Row, Col } from 'antd';
import { DataCard } from '../../components/Charts/DataCard';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import ComplainDetails from './ComplainDetails';
import { OperationLink } from '../../components/OperationLink';
import { INDEX_WIDTH, ACTION_WIDTH } from '../../utils/constants';
import { datetimeFormat } from '../../utils';
import { serviceCenterStatusList, serviceCenterStatus } from '../../utils/enum';
import { action as serviceCenterActions } from './store';
import { RefundModal } from '../../containers/Refund/RefundModal';
import { push } from '../../store/router-helper';
import './style.less';

const ColProps = {
  xs: 12,
  lg: 12,
  xl: 6,
  style: {
    marginBottom: 16,
  },
};

class ServiceCenter extends Component {
  openDetail = (complaintId) => {
    const { dispatch } = this.props;
    dispatch(serviceCenterActions.viewComplainDetails({ complaintId }));
    dispatch(serviceCenterActions.toggleComplainDetailModal(true));
  }

  fetchList = () => {
    const { dispatch, location: { query } } = this.props;
    dispatch(serviceCenterActions.getComplainList(query));
  }

  componentDidMount() {
    const { location } = this.props;
    this.props.dispatch(push({ ...location, query: { complainState: 0 } }));
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  onRefundOk = (fields) => {
    this.props.dispatch(serviceCenterActions.orderRefund(fields));
  }

  onRefundCancel = () => {
    this.props.dispatch(serviceCenterActions.toggleRefundModal(false));
  }

  render() {
    const { location: { search },
      complainList: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
        originalData,
      } = {},
      currentOrder,
      refundVisible,
      refundData,
    } = this.props;
    //客服中心删选查询条件
    const filterProps = {
      search,
      columns: [
        { dataIndex: 'date', title: '投诉提交时间', type: 'dateArea', startKey: 'beginDate', endKey: 'endDate' },
        { dataIndex: 'phone', title: '搜索手机号' },
        { dataIndex: 'complainState', title: '问题状态', type: 'select', initialValue: '1', list: serviceCenterStatusList, itemAlias: { value: 'id', label: 'status' } },
      ],
    };
    const { onHandleNum, waitForHandleNum } = originalData || {};
    const dataList = [
      {
        label: '待处理（条）',
        value: waitForHandleNum || 0,
        icon: {
          type: 'money-collect',
        },
        // background: '#fff',
      },
      {
        label: '处理中（条）',
        value: onHandleNum || 0,
        icon: {
          type: 'pushpin',
        },
        background: 'rgb(255,153,0)',
      },
    ];
    //客服中心投诉状态列表
    const listProps = {
      rowKey: 'id',
      loading,
      pagination: {
        current,
        total,
        pageSize,
      },
      dataSource,
      columns: [
        { dataIndex: 'id', title: '编号', fixed: 'left', width: INDEX_WIDTH },
        { dataIndex: 'createTime', title: '投诉提交时间', render: text => datetimeFormat(text) },
        { dataIndex: 'classifyType', title: '分类' },
        { dataIndex: 'orderId', title: '订单编号' },
        { dataIndex: 'complainContent', title: '投诉内容', width: 300 },
        { dataIndex: 'phone', title: '手机号' },
        { dataIndex: 'complainState', title: '状态', render: text => serviceCenterStatus[text] },
        { dataIndex: 'solveTime', title: '投诉解决时间', render: text => datetimeFormat(text) },
        {
          dataIndex: 'b',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            let text = record.complainState < 2 ? '去处理' : '查看';
            let options = [
              { text, action: () => { this.openDetail(record.id); } },
            ];
            return <OperationLink options={options} />;
          },
        },
      ],
    };
    return (
      <div className="page-servicecenter">
        <div className="content-header">
          <h2>客服中心</h2>
        </div>
        <div style={{ marginBottom: 20 }}>
          <Row className="data-collect" gutter={16}>
            {dataList.map((item, index) => (<Col key={index} {...ColProps}>
              <DataCard {...item} />
            </Col>))}
          </Row>
        </div>
        <PageFilter {...filterProps} />
        <div className="list-desc">
          <p>共搜索到 {total} 条记录</p>
        </div>
        <PageList {...listProps} />
        <ComplainDetails />
        <RefundModal
          order={currentOrder}
          visible={refundVisible}
          saveData={refundData}
          onOk={this.onRefundOk}
          onCancel={this.onRefundCancel}
        />
      </div>
    );
  }
}

ServiceCenter.propTypes = {
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  complainList: PropTypes.object.isRequired,
  currentOrder: PropTypes.object.isRequired,
  refundVisible: PropTypes.bool.isRequired,
  refundData: PropTypes.object.isRequired,
};

const mapStateToProps = ({ serviceCenter: { complainList, visible, refundVisible, refundData, current } }) => {
  return { complainList, visible, refundVisible, refundData, currentOrder: current };
};

export default connect(mapStateToProps)(ServiceCenter);
