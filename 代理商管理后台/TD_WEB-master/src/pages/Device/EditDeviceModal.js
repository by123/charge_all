import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Form, Spin } from 'antd';
import { connect } from 'react-redux';
import { action as deviceActions } from './store';
import { EditDevice } from '../../components/Device/EditDevice';
import { isEditDeviceSuccess, processBillingRules, processBillingRulesWithPre } from '../../utils';

class EditDeviceModal extends React.PureComponent {
  onSubmit = () => {
    const { selectedKeys, dispatch, form, deviceDetail } = this.props;
    const deviceSN = deviceDetail.result ? [deviceDetail.result.deviceDetail.deviceSn] : selectedKeys;
    form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        const mchUserId = values.agentType === 1 ? values.agent : values.biz;
        const serviceType = values.serviceType;
        const service = (serviceType === '1' || serviceType === 1) ? processBillingRules(values.service) : processBillingRulesWithPre(values.service);
        const pledge = values.pledge.toString();
        console.log('触发3');
        console.log(values);
        const isActive = deviceDetail.result.deviceDetail.deviceState === 2;
        dispatch(deviceActions.editDevice({
          deviceSN,
          pledge,
          service,
          serviceType,
          mchUserId: isActive ? '' : mchUserId,
        }, (_, getState) => {
          const { editDevice } = getState().device;
          const { success } = editDevice.result;
          if (isEditDeviceSuccess(editDevice.result)) {
            message.success('批量编辑设备成功');
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
      selectedKeys,
      deviceDetail,
      editDevice,
      currentSn,
      form,
      queryAgent,
    } = this.props;
    let current = null;
    const modalOpts = {
      title: '编辑设备',
      visible,
      width: currentSn ? 900 : 700,
      onOk: this.onSubmit,
      onCancel: () => dispatch(deviceActions.toggleEditDeviceModal(false)),
      destroyOnClose: true,
      confirmLoading: editDevice.loading,
      cancelButtonProps: {
        disabled: editDevice.loading,
      },
      maskClosable: false,
      style: { top: 20 },
    };
    let key = selectedKeys[0] || null;
    if (currentSn) {
      key = currentSn;
      current = deviceDetail.result;
    }
    return (
      <div>
        <Modal {...modalOpts}>
          <Spin spinning={!!deviceDetail.loading}>
            <EditDevice key={key} form={form} queryAgent={queryAgent} ids={selectedKeys} current={current} />
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
  selectedKeys: PropTypes.array.isRequired,
  deviceDetail: PropTypes.object.isRequired,
  editDevice: PropTypes.object.isRequired,
  currentSn: PropTypes.string,
  queryAgent: PropTypes.object.isRequired,
};

EditDeviceModal.defaultProps = {
  currentSn: '',
};

const BindBillingForm = Form.create()(EditDeviceModal);

const Container = connect(({ device: { queryAgent, currentSn, deviceDetail, editDevice, editVisible, selectedKeys } }) => ({
  visible: editVisible,
  selectedKeys,
  currentSn,
  deviceDetail,
  editDevice,
  queryAgent,
}))(BindBillingForm);

export { Container as EditDeviceModal };
