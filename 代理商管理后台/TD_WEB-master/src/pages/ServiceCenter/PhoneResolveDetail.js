import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin, Form, Button, message } from 'antd';
import { DetailList } from '../../components/DetailList';
import {
  allAgentLevelTypes,
  payTypes,
  complaintsType,
  resolveType,
} from '../../utils/enum';
import { datetimeFormat, formatDecimal, addAgentList } from '../../utils';
import { action as serviceCenterActions } from './store';
import { DETAIL, EDIT } from '../../utils/constants';
import { action as orderActions } from '../Order/store';
import { EditComplainForm } from '../../containers/EditComplainModal/EditComplainForm';

import './style.less';

const { Panel } = Collapse;

class PhoneResolveDetail extends Component {
  handleCancel = () => {
    this.props.dispatch(serviceCenterActions.togglePhoneResolveDetail(false));
  }

  handleSubmit = () => {
    const { form, dispatch, complainId } = this.props;
    form.validateFieldsAndScroll((err, values) => {
      if (err) return;
      values.id = complainId;
      dispatch(serviceCenterActions.modTelComplain(values, () => {
        message.success('编辑客服处理成功');
        dispatch(serviceCenterActions.getTelComplainDetail({ id: complainId }));
        dispatch(serviceCenterActions.togglePhoneResolveDetail(true, complainId, DETAIL));
        dispatch(serviceCenterActions.refreshTelComplainList());
      }));
    });
  }

  openRefundModal = (record) => {
    this.props.dispatch(orderActions.toggleRefundModal(true, record));
  }

  render() {
    const {
      orderDetail: {
        loading: orderLoading = false,
        result: orderDetail = {},
      },
      form,
      getTelComplainDetailResult: {
        loading = false,
        result: complainDetail,
      },
      getProblemListResult,
      editType = DETAIL,
      hasOrder = false,
      editTelComplainResult,
    } = this.props;

    const complainTypeList = getProblemListResult.result || {};
    let orderDetailData = addAgentList(orderDetail);
    if (orderDetailData.tblOrder) {
      const { userName, orderName, payType, orderId } = orderDetailData.tblOrder;
      orderDetailData = {
        ...orderDetailData,
        userName,
        orderName,
        payType,
        orderId,
      };
    }
    const complainColumns = [
      { key: 'telephone', label: '来电号码' },
      {
        key: 'complainType',
        label: '投诉类型',
        render: text => complaintsType[text],
      },
      { key: 'problemState', label: '解决情况', render: text => resolveType[text] },
      { key: 'problemType', label: '设备投诉问题', render: text => complainTypeList[text] },
      { key: 'createTime', label: '提交时间', render: text => datetimeFormat(text) },
      { key: 'handlerUserName', label: '处理客服' },
      { key: 'problemContent', label: '其他备注' },
    ];

    const orderColumns = [
      { key: 'orderId', label: '订单号', render: text => { return text === null ? '无' : text; } },
      { key: 'deviceSn', label: '设备编号' },
      { key: 'deviceVersion', label: '设备版本', render: text => (text !== null ? `V${text}` : '') },
      { key: 'mchName', label: '商户名称' },
      { key: 'myAgentLevel1', label: allAgentLevelTypes[1] },
      { key: 'myAgentLevel2', label: allAgentLevelTypes[2] },
      { key: 'myAgentLevel3', label: allAgentLevelTypes[3] },
      { key: 'myAgentLevel4', label: allAgentLevelTypes[4] },
      { key: 'servicePriceYuan', label: '订单消费金额', render: text => formatDecimal(text) },
      { key: 'orderName', label: '商品名' },
      { key: 'payType', label: '支付平台', render: text => payTypes[text] },
      { key: 'userName', label: '支付用户ID' },
    ];

    return (
      <div className="page-warninghandle">
        <Collapse bordered={false} defaultActiveKey={['a', 'b', 'c', 'd']}>
          <Panel header={<h3>电话处理详情</h3>} key="a">
            {editType === DETAIL && <Spin spinning={loading}>
              <DetailList columns={complainColumns} dataSource={complainDetail} />
            </Spin>}
            {editType === EDIT && (<EditComplainForm
              form={form}
              orderId={hasOrder ? orderDetailData.orderId : ''}
              complainTypeList={complainTypeList}
              complainDetail={complainDetail}
            />)}
          </Panel>
          {hasOrder && <Panel header={<h3>订单详情</h3>} key="b">
            <Spin spinning={orderLoading}>
              <DetailList columns={orderColumns} dataSource={orderDetailData} />
            </Spin>
          </Panel>}
        </Collapse>
        <div className="complain-btn-wrapper">
          <Button onClick={this.handleCancel}>{editType === DETAIL ? '返回' : '取消' }</Button>
          {editType === EDIT && <Button
            type="primary"
            loading={editTelComplainResult.loading}
            onClick={this.handleSubmit}
          >提交</Button>}
        </div>
      </div>
    );
  }
}

PhoneResolveDetail.propTypes = {
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  getTelComplainDetailResult: PropTypes.object.isRequired,
  getProblemListResult: PropTypes.object.isRequired,
  orderDetail: PropTypes.object.isRequired,
  editType: PropTypes.string,
  hasOrder: PropTypes.bool.isRequired,
  editTelComplainResult: PropTypes.object.isRequired,
  complainId: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
};

PhoneResolveDetail.defaultProps = {
  complainId: '',
  editType: '',
};

const mapStateToProps = ({
  serviceCenter: {
    getProblemListResult,
    getTelComplainDetailResult,
    editTelComplainResult,
    editType,
    complainId,
  },
  order: {
    orderDetail,
  },
}) => ({
  getProblemListResult,
  getTelComplainDetailResult,
  editTelComplainResult,
  orderDetail,
  editType,
  complainId,
});

const Container = connect(mapStateToProps)(Form.create()(PhoneResolveDetail));
export { Container as PhoneResolveDetail };
