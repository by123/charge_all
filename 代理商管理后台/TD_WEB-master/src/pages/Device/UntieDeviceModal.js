import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Alert } from 'antd';
import { connect } from 'react-redux';
import { action as deviceActions } from './store';
import { action as globalActions } from '../../store/global';
import { getFailDevice } from '../../utils';

class UntieDeviceModal extends React.PureComponent {
  handleSubmit = () => {
    const { ids, dispatch } = this.props;
    dispatch(deviceActions.untieDeviceBySn({
      deviceSnLst: ids,
    }, (_, getState) => {
      const { editDeviceResult: { result } } = getState().device;
      if (Array.isArray(result) && result.length && getFailDevice(result).length) {
        dispatch(globalActions.toggleErrorList(true));
      } else {
        message.success('设备解绑成功');
        dispatch(deviceActions.toggleUntieDeviceModal(false));
        dispatch(deviceActions.refreshList());
      }

      // if (isEditDeviceSuccess(editDevice.result)) {
      //   message.success(`批量绑定${values.agentType === 1 ? '代理商' : '商户'}成功`);
      // } else {
      //   dispatch(deviceActions.toggleDeviceResultModal(true)); // 显示添加设备结果
      // }
      // if (success.length > 0) {
      //   // 只要有一个提交成功，关闭表单窗口，刷新列表
      //   dispatch(deviceActions.toggleBindAgentModal(false));
      //   dispatch(deviceActions.refreshList());
      // }
    }));
  }
  render() {
    const {
      visible,
      dispatch,
      ids,
      editDeviceResult,
    } = this.props;
    const modalOpts = {
      title: '批量解绑设备',
      visible,
      width: 630,
      onOk: this.handleSubmit,
      okText: '解绑',
      onCancel: () => dispatch(deviceActions.toggleUntieDeviceModal(false)),
      destroyOnClose: true,
      confirmLoading: editDeviceResult.loading,
      cancelButtonProps: {
        disabled: editDeviceResult.loading,
      },
      maskClosable: false,
    };
    return (
      <div>
        <Modal {...modalOpts}>
          <Alert type="info" showIcon message="解绑将恢复成未绑定未激活状态，设备将无法使用，请谨慎操作" />
          <p style={{ marginTop: 10 }}>已选择{ids.length}个设备</p>
          <div className="g-selected-area">{ids.join(',')}</div>
          {/* <Card title="绑定代理商／商户">
            <BindAgent form={form} queryAgent={queryAgent} />
          </Card> */}
        </Modal>
      </div>
    );
  }
}

UntieDeviceModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  ids: PropTypes.array,
  editDeviceResult: PropTypes.object.isRequired,
};

UntieDeviceModal.defaultProps = {
  ids: [],
};

const Container = connect(({ device: { editDeviceResult, selectedKeys, untieDeviceVisible } }) => ({
  visible: untieDeviceVisible,
  ids: selectedKeys,
  editDeviceResult,
}))(UntieDeviceModal);

export { Container as UntieDeviceModal };
