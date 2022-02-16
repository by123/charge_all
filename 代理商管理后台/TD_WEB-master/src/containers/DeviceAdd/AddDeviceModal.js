import React from 'react';
import PropTypes from 'prop-types';
import { Modal } from 'antd';
import { connect } from 'react-redux';
import { action as deviceActions } from '../../pages/Device/store';
import { AddDevice } from './AddDevice';

class AddDeviceModal extends React.PureComponent {
  handleCancel = () => {
    this.props.dispatch(deviceActions.toggleAddDeviceModal(false));
  }
  render() {
    const {
      visible,
    } = this.props;
    const modalOpts = {
      title: '分配设备',
      visible,
      width: 800,
      footer: null,
      onCancel: this.handleCancel,
      destroyOnClose: true,
      maskClosable: false,
    };
    return (
      <div>
        <Modal {...modalOpts}>
          <AddDevice />
        </Modal>
      </div>
    );
  }
}

AddDeviceModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
};

const Container = connect(({ device: { addModalVisible } }) => ({
  visible: addModalVisible,
}))(AddDeviceModal);

export { Container as AddDeviceModal };
