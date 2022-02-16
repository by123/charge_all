import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Form, Spin, Row, Col, Divider, InputNumber } from 'antd';
import { connect } from 'react-redux';
import { DeviceInfo } from '@/components/Device/DeviceInfo';
import { isEditDeviceSuccess, processBillingRules, sub, getPriceFromService } from '@/utils';
import { action as deviceActions } from './store';

const FormItem = Form.Item;

const styles = {
  divider: { marginTop: 0, marginBottom: 10 },
};

const formWrapLayout = {
  xs: 24,
  md: 12,
};

const childAgentLayout = {
  labelCol: { md: 11, xs: 10 },
  wrapperCol: { md: 12, xs: 12 },
};

class EditDeviceModal extends React.PureComponent {
  onSubmit = () => {
    const { dispatch, form, deviceDetail } = this.props;
    const deviceSN = deviceDetail.result ? deviceDetail.result.deviceDetail.deviceSn : '';
    form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        if (Number(values.price) <= 0) {
          message.error('设备价格须大于0元');
          return;
        }
        const service = processBillingRules([{ price: values.price, time: 120 }]);
        const serviceType = values.serviceType;
        dispatch(deviceActions.editDevice({
          sn: deviceSN,
          profitPercent: values.profitSubAgent,
          service,
          serviceType,
        }, (_, getState) => {
          const { editDevice } = getState().device;
          const { success } = editDevice.result;
          if (isEditDeviceSuccess(editDevice.result)) {
            message.success('编辑设备成功');
          } else {
            dispatch(deviceActions.toggleDeviceResultModal(true)); // 显示添加设备结果
          }
          if (success.length > 0) {
            // 只要有一个提交成功，关闭表单窗口，刷新列表
            dispatch(deviceActions.toggleEditDeviceModal(false));
            dispatch(deviceActions.refreshList());
          }
        }));
      }
    });
  }
  render() {
    const {
      visible,
      dispatch,
      deviceDetail = {},
      editDeviceResult,
      form,
      selfInfo,
    } = this.props;
    const totalPercent = selfInfo.totalPercent;
    let formData = deviceDetail.result || {};

    const modalOpts = {
      title: '编辑设备信息',
      visible,
      width: 900,
      onOk: this.onSubmit,
      onCancel: () => dispatch(deviceActions.toggleEditDeviceModal(false)),
      destroyOnClose: true,
      confirmLoading: editDeviceResult.loading,
      cancelButtonProps: {
        disabled: editDeviceResult.loading,
      },
      maskClosable: false,
      // style: { top: 20 },
    };
    const { getFieldDecorator, getFieldValue } = form;
    const remainProfit = () => {
      const agentProfit = getFieldValue('profitSubAgent');
      if (!agentProfit) return totalPercent;
      let remain = sub(totalPercent, getFieldValue('profitSubAgent'));
      remain = remain > totalPercent ? totalPercent : remain;
      return remain < 0 ? 0 : remain.toFixed(2);
    };
    // const defaultPrice = getDefaultPrice(formData);
    const service = formData.devicePriceCfg ? formData.devicePriceCfg.service : '';
    const defaultPrice = getPriceFromService(service);
    const deviceInfo = (formData.deviceDetail) || {};
    return (
      <div>
        <Modal {...modalOpts}>
          <Spin spinning={!!deviceDetail.loading}>
            <DeviceInfo dataSource={deviceInfo} loading={false} colSpan={{ span: 8 }} />
            <Divider style={styles.divider} />
            <Row>
              <Col {...formWrapLayout}>
                <FormItem label="设置司机分润比例" {...childAgentLayout}>
                  {getFieldDecorator('profitSubAgent', {
                    initialValue: formData.profitToTaxi,
                    rules: [{
                      required: true,
                      type: 'number',
                      message: '司机分润比例为必填项',
                    },
                    {
                      max: totalPercent,
                      type: 'number',
                      message: `最大值为${totalPercent}%`,
                    },
                    {
                      min: 0,
                      type: 'number',
                      message: '最小值为0%',
                    }],
                  })(<InputNumber precision={2} max={totalPercent} />)}  %
                </FormItem>
              </Col>
              <Col {...formWrapLayout}>
                <FormItem>我的总利润比例为：{totalPercent}%，剩余分润：{remainProfit()}%</FormItem>
              </Col>
            </Row>
            <Divider style={styles.divider} />
            <Row>
              <Col {...formWrapLayout}>
                <FormItem label="设备计费规则" {...childAgentLayout}>
                  {getFieldDecorator('price', {
                    initialValue: defaultPrice,
                    rules: [{
                      required: true,
                      type: 'number',
                      message: '设备计费规则为必填项',
                    }],
                  })(<InputNumber precision={2} />)}  元/2小时
                </FormItem>
              </Col>
              <Col {...formWrapLayout}>
                <FormItem>出租车所用设备只有1档计费规则</FormItem>
              </Col>
            </Row>
          </Spin>
        </Modal>
      </div>
    );
  }
}

EditDeviceModal.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  deviceDetail: PropTypes.object.isRequired,
  editDeviceResult: PropTypes.object.isRequired,
  selfInfo: PropTypes.object.isRequired,
};

const BindBillingForm = Form.create()(EditDeviceModal);

const Container = connect(({
  taxiDevice: {
    queryAgent,
    currentSn,
    deviceDetail,
    editDeviceResult,
    editDevice,
    editVisible,
  },
  taxiGroup: {
    selfInfo,
  },
}) => ({
  visible: editVisible,
  currentSn,
  deviceDetail,
  editDevice,
  editDeviceResult,
  queryAgent,
  selfInfo,
}))(BindBillingForm);

export { Container as EditDeviceModal };
