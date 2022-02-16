import React from 'react';
import PropTypes from 'prop-types';
import { Modal } from 'antd';
import { connect } from 'react-redux';
import { action as deviceActions } from './store';

const styles = {
  tipText: {
    textAlign: 'center',
  },
  wrapper: {
    display: 'flex',
    fontWeight: 'bold',
    marginTop: 20,
  },
  itemLabel: {
    flex: 2,
    textAlign: 'right',
  },
  itemValue: {
    flex: 3,
    textAlign: 'left',
  },
};
class TransferConfirmModal extends React.PureComponent {
  state = {
    loading: false,
  }
  handleSubmit = () => {
    const { dispatch, onConfirm } = this.props;
    this.setState({
      loading: true,
    });
    dispatch(deviceActions.confirmTransferDevice(true, () => {
      onConfirm && onConfirm();
      this.closeModal();
    }));
  }
  closeModal = () => {
    const { dispatch } = this.props;
    this.setState({
      loading: false,
    });
    dispatch(deviceActions.confirmTransferDevice(false));
    dispatch(deviceActions.toggleTransferConfirmModal(false));
  }
  render() {
    const {
      visible,
      target,
      total = 0,
    } = this.props;
    const modalOpts = {
      title: '确认更换分组',
      visible,
      onOk: this.handleSubmit,
      okText: '确认更换分组',
      onCancel: this.closeModal,
      destroyOnClose: true,
      maskClosable: false,
      confirmLoading: this.state.loading,
    };
    return (
      <div>
        <Modal {...modalOpts} >
          <p style={styles.tipText}>设备更换分组后，立即生效。设备价格将使用新分组的定价和分润比例。</p>
          <div style={styles.wrapper}>
            <div style={styles.itemLabel}>更换分组设备数：</div>
            <div style={styles.itemValue}>{total}个</div>
          </div>
          <div style={styles.wrapper}>
            <div style={styles.itemLabel}>转移至：</div>
            <div style={styles.itemValue}>{target}</div>
          </div>
        </Modal>
      </div>
    );
  }
}

TransferConfirmModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  onConfirm: PropTypes.func.isRequired,
  queryDeviceByMchId: PropTypes.object.isRequired,
  target: PropTypes.string.isRequired,
  total: PropTypes.number.isRequired,
};

const Container = connect(({ device: { transferConfirmVisible, queryDeviceByMchId } }) => ({
  visible: transferConfirmVisible,
  queryDeviceByMchId,
}))(TransferConfirmModal);

export { Container as TransferConfirmModal };
