/**
 * 批量绑定商户或者代理商弹窗
 */

import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Form } from 'antd';
import { connect } from 'react-redux';
import { action as deviceActions } from './store';
import { BindAgent } from '../../components/BindAgent/BindAgent';
import { isEditDeviceSuccess } from '../../utils';
import { Card } from '../../components/Card';

class BindAgentModal extends React.PureComponent {
  handleSubmit = () => {
    const { ids, dispatch, form } = this.props;

    form.validateFieldsAndScroll((err, values) => {
      if (err) return;
      let mchId = values.agentType === 1 ? values.agent : values.biz;
      if (Array.isArray(mchId)) {
        mchId = mchId[mchId.length - 1];
      }
      dispatch(deviceActions.editDevice({
        deviceSN: ids,
        mchId,
      }, (_, getState) => {
        const { editDevice } = getState().device;
        const { success } = editDevice.result;
        if (isEditDeviceSuccess(editDevice.result)) {
          message.success(`批量绑定${values.agentType === 1 ? '代理商' : '商户'}成功`);
        } else {
          dispatch(deviceActions.toggleDeviceResultModal(true)); // 显示添加设备结果
        }
        if (success.length > 0) {
          // 只要有一个提交成功，关闭表单窗口，刷新列表
          dispatch(deviceActions.toggleBindAgentModal(false));
          dispatch(deviceActions.refreshList());
        }
      }));
    });
  }
  render() {
    const {
      visible,
      dispatch,
      ids,
      editDevice,
      form,
      queryAgent,
    } = this.props;
    const modalOpts = {
      title: '批量绑定商户',
      visible,
      width: 830,
      onOk: this.handleSubmit,
      onCancel: () => dispatch(deviceActions.toggleBindAgentModal(false)),
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
          <Card title="绑定代理商／商户">
            <BindAgent form={form} queryAgent={queryAgent} multiple={!!true} />
          </Card>
        </Modal>
      </div>
    );
  }
}

BindAgentModal.propTypes = {
  form: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  ids: PropTypes.array,
  editDevice: PropTypes.object.isRequired,
};

BindAgentModal.defaultProps = {
  ids: [],
};

const BindAgentForm = Form.create()(BindAgentModal);
const Container = connect(({ device: { queryAgent, editDevice, bindAgentVisible, selectedKeys } }) => ({
  visible: bindAgentVisible,
  ids: selectedKeys,
  editDevice,
  queryAgent,
}))(BindAgentForm);

export { Container as BindAgentModal };
