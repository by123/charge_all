import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin, Input, Modal, Radio, Form, Row, Button } from 'antd';
import { DetailList } from '../../components/DetailList';
import { serviceCenterStatusList, allAgentLevelTypes, orderStatus, serviceCenterStatus, payTypes } from '../../utils/enum';
import { datetimeFormat, formatDecimal, addAgentList } from '../../utils';
import { action as serviceCenterActions } from './store';
import { action as orderActions } from '../Order/store';

import './style.less';

const { Panel } = Collapse;
const { TextArea } = Input;
const RadioGroup = Radio.Group;
const FormItem = Form.Item;

function isDisable(complainState) {
  return complainState === 2 || complainState === 3;
}

const itemProps = {
  wrapperCol: {
    xs: {
      span: 21,
    },
    sm: {
      span: 21,
    },
    xl: {
      span: 21,
    },
  },
  labelCol: {
    xs: {
      span: 3,
    },
    sm: {
      span: 3,
    },
    xl: {
      span: 3,
    },
  },
};
const colSpan = { xs: 24, sm: 24, md: 24, lg: 24, xl: 24 };

class ComplainDetails extends Component {
  handleCancel = () => {
    this.props.dispatch(serviceCenterActions.toggleComplainDetailModal(!this.props.visible));
    this.setState({ alarmCheckMessage: '' });
  }

  submitHandle = () => {
    const { form, dispatch, viewComplainDetails: { result = {} } } = this.props;
    const { id, complainState } = result.tblComplainRecord;
    if (isDisable(complainState)) {
      dispatch(serviceCenterActions.toggleComplainDetailModal(false));
    } else {
      form.validateFieldsAndScroll((err, values) => {
        if (!err) {
          dispatch(serviceCenterActions.changeComplainState({ ...values, complaintId: id }));
        }
      });
    }
  }

  openRefundModal = (record) => {
    this.props.dispatch(orderActions.toggleRefundModal(true, record));
  }

  render() {
    const complainColumns = [
      { key: 'id', label: '问题编号' },
      { key: 'classifyType', label: '问题分类' },
      { key: 'complainState', label: '状态', render: text => serviceCenterStatus[text] },
      { key: 'phone', label: '用户手机号' },
      { key: 'createTime', label: '投诉提交时间', render: (text) => datetimeFormat(text) },
      { key: 'solveTime', label: '投诉解决时间', render: (text) => datetimeFormat(text) },
      { key: 'complainContent', label: '问题描述', colSpan, itemProps },
    ];

    const orderColumns = [
      { key: 'orderId', label: '订单号', render: text => { return text === null ? '无' : text; } },
      { key: 'deviceSn', label: '设备编号' },
      { key: 'mchName', label: '商户名称' },
      { key: 'myAgentLevel1', label: allAgentLevelTypes[1] },
      { key: 'myAgentLevel2', label: allAgentLevelTypes[2] },
      { key: 'myAgentLevel3', label: allAgentLevelTypes[3] },
      { key: 'myAgentLevel4', label: allAgentLevelTypes[4] },
      { key: 'servicePriceYuan', label: '订单消费金额', render: text => formatDecimal(text) },
      { key: 'orderName', label: '商品名' },
      { key: 'deviceCode', label: '充电密码' },
      { key: 'orderStateWeb', label: '订单状态', render: text => orderStatus[text] },
      { key: 'payType', label: '支付平台', render: text => payTypes[text] },
    ];

    const deviceColumns = [
      { key: 'platform', label: '操作系统' },
      { key: 'system', label: '操作系统版本' },
      { key: 'version', label: '小程序版本号' },
      { key: 'brand', label: '手机品牌' },
      { key: 'model', label: '手机型号' },
    ];
    const {
      viewComplainDetails: {
        loading = false,
        result,
      },
      visible,
      changeStateRusult: {
        loading: submitLoading = false,
      },
      form: {
        getFieldDecorator,
      },
    } = this.props;
    const { orderDetailModel = {}, tblComplainRecord = {}, tblOrderUsermobile = {} } = result || {};
    const { lstParents, priceRule, tblOrder, ...otherInfo } = orderDetailModel || {};
    let orderDetail = { lstParents, ...priceRule, ...tblOrder, ...otherInfo, complaintId: tblComplainRecord.id };
    orderDetail = addAgentList(orderDetail);
    const textAreaConfig = {
      rows: 4,
      placeholder: '请输入备注',
    };
    const complainState = tblComplainRecord.complainState;
    const disabled = isDisable(complainState);
    const modalOptions = {
      visible,
      width: 900,
      title: '投诉详情',
      destroyOnClose: true,
      maskClosable: false,
      footer: null,
      onCancel: this.handleCancel,
    };
    const typeLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 18, offset: 1 },
    };
    const { orderStateWeb } = orderDetailModel || {};
    const canOrderRefund = orderStateWeb === 2 || orderStateWeb === 3;
    // const canOrderRefund = true;
    return (
      <div className="page-warninghandle">
        <Modal {...modalOptions} className="page-warninghandle-modal">
          <Collapse bordered={false} defaultActiveKey={['a', 'b', 'c', 'd']}>
            <Panel header={<h3>投诉详情</h3>} key="a">
              <Spin spinning={loading}>
                <DetailList columns={complainColumns} dataSource={tblComplainRecord} />
              </Spin>
            </Panel>
            <Panel header={<h3>订单详情</h3>} key="b">
              <Spin spinning={loading}>
                <DetailList columns={orderColumns} dataSource={orderDetail} />
              </Spin>
            </Panel>
            <Panel header={<h3>用户设备详情</h3>} key="c">
              <Spin spinning={loading}>
                <DetailList columns={deviceColumns} dataSource={tblOrderUsermobile} />
              </Spin>
            </Panel>
            <Panel header={<h3>投诉处理</h3>} key="d">
              <Form>
                {!disabled && <Row>
                  <FormItem label="问题处理备注" {...typeLayout}>
                    {getFieldDecorator('solution', {
                      initialValue: tblComplainRecord.solution || '',
                    })(
                      <TextArea {...textAreaConfig} onChange={(e) => { this.setState({ alarmCheckMessage: e.target.value }); }} />
                    )}
                  </FormItem>
                </Row>}
                {!disabled && <Row>
                  <FormItem label="问题状态" {...typeLayout}>
                    {getFieldDecorator('complainState', {
                      initialValue: complainState,
                    })(
                      <RadioGroup name="complainState">
                        {serviceCenterStatusList.map((val, ind) => {
                          return <Radio disabled={ind === 0 && complainState > 0} value={val.id} key={val.id}>{val.status}</Radio>;
                        })}
                      </RadioGroup>
                    )}
                  </FormItem>
                </Row>}
                {disabled && <Row>
                  <FormItem label="问题处理备注" {...typeLayout}>{tblComplainRecord.solution || ''}</FormItem>
                </Row>}
              </Form>
            </Panel>
          </Collapse>
          {!disabled && <div className="complain-btn-wrapper">
            <Button onClick={this.handleCancel}>关闭</Button>
            {/* 退款有条件 */}
            {canOrderRefund && <Button type="primary" loading={submitLoading} onClick={() => this.openRefundModal(orderDetail || {})}>退款</Button>}
            <Button type="primary" loading={submitLoading} onClick={this.submitHandle}>确定</Button>
          </div>}
          {disabled && <div className="complain-btn-wrapper">
            <Button onClick={this.handleCancel}>关闭</Button>
          </div>}
        </Modal>
      </div>
    );
  }
}

const mapStateToProps = ({
  serviceCenter: { viewComplainDetails, visible, changeStateRusult },
}) => ({
  viewComplainDetails,
  visible,
  changeStateRusult,
});

ComplainDetails.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  form: PropTypes.object.isRequired,
  viewComplainDetails: PropTypes.object.isRequired,
  changeStateRusult: PropTypes.object.isRequired,
};

export default connect(mapStateToProps)(Form.create()(ComplainDetails));
