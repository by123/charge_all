/**
 * 批量编辑计费规则弹窗
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Form } from 'antd';
import { connect } from 'react-redux';

import { action as deviceActions } from './store';
import { BindBilling } from '../../components/BindBilling/BindBilling';
import { isEditDeviceSuccess, processBillingRules, processBillingRulesWithPre } from '../../utils';
import { Card } from '../../components/Card';

class BindBillingModal extends React.PureComponent {
  handleSubmit = () => {
    const { ids, dispatch } = this.props;
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        const serviceType = values.serviceType;
        const service = (serviceType === '1' || serviceType === 1) ? processBillingRules(values.service) : processBillingRulesWithPre(values.service);
        const pledge = values.pledge.toString();
        console.log('触发2');
        console.log(serviceType);
        dispatch(deviceActions.editDevice({
          deviceSN: ids,
          pledge,
          service,
          serviceType,
        }, (_, getState) => {
          const { editDevice } = getState().device;
          const { success } = editDevice.result;
          if (isEditDeviceSuccess(editDevice.result)) {
            message.success('批量编辑计费规则成功');
          } else {
            dispatch(deviceActions.toggleDeviceResultModal(true)); // 显示添加设备结果
          }
          if (success.length > 0) {
            // 只要有一个提交成功，关闭表单窗口，刷新列表
            dispatch(deviceActions.toggleEditBillingModal(false));
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
      ids,
      editDevice,
      form,
    } = this.props;
    const modalOpts = {
      title: '批量编辑计费规则',
      visible,
      width: 600,
      onOk: this.handleSubmit,
      onCancel: () => dispatch(deviceActions.toggleEditBillingModal(false)),
      destroyOnClose: true,
      confirmLoading: editDevice.loading,
      cancelButtonProps: {
        disabled: editDevice.loading,
      },
      maskClosable: false,
    };
    return (
      <div>
        <Modal {...modalOpts}>
          <p>已选择设备总数：{ids.length}个</p>
          <div className="g-selected-area">{ids.join(',')}</div>
          <Card title="设置计费规则">
            <BindBilling form={form} />
          </Card>
        </Modal>
      </div>
    );
  }
}

BindBillingModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  ids: PropTypes.array,
  form: PropTypes.object.isRequired,
  editDevice: PropTypes.object.isRequired,
};

BindBillingModal.defaultProps = {
  ids: [],
};

const BindBillingForm = Form.create()(BindBillingModal);
const Container = connect(({ device: { editDevice, editBillingVisible, selectedKeys } }) => ({
  visible: editBillingVisible,
  ids: selectedKeys,
  editDevice,
}))(BindBillingForm);

export { Container as BindBillingModal };
