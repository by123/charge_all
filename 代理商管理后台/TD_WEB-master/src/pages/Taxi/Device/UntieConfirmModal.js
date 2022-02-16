import React from 'react';
import PropTypes from 'prop-types';
import { Modal } from 'antd';
import { connect } from 'react-redux';
import { action as deviceActions } from './store';

const styles = {
  tipText: {
    textAlign: 'center',
  },
  warnText: {
    color: '#ef4f5e',
  },
  wrapper: {
    display: 'flex',
    fontWeight: 'bold',
    marginTop: 20,
  },
  itemLabel: {
    flex: 1,
    textAlign: 'right',
  },
  itemValue: {
    flex: 1,
    textAlign: 'left',
  },
};
class UntieConfirmModal extends React.PureComponent {
  state = {
    loading: false,
  }
  handleSubmit = () => {
    const { dispatch, onConfirm } = this.props;
    this.setState({
      loading: true,
    });
    dispatch(deviceActions.confirmUntieDevice(true, () => {
      onConfirm && onConfirm();
      this.closeModal();
    }));
  }
  closeModal = () => {
    const { dispatch } = this.props;
    dispatch(deviceActions.toggleUntieConfirmModal(false));
    dispatch(deviceActions.confirmUntieDevice(false));
  }
  render() {
    const {
      visible,
      total = 0,
    } = this.props;
    const modalOpts = {
      title: '确认解绑',
      visible,
      onOk: this.handleSubmit,
      okText: '确认解绑',
      onCancel: this.closeModal,
      destroyOnClose: true,
      maskClosable: false,
      confirmLoading: this.state.loading,
    };
    return (
      <div>
        <Modal {...modalOpts} >
          <p style={styles.tipText}>解绑后设备将变为未绑定未激活状态，<span style={styles.warnText}>设备将无法使用</span>，请谨慎操作</p>
          <div style={styles.wrapper}>
            <div style={styles.itemLabel}>解绑设备数：</div>
            <div style={styles.itemValue}>{total}个</div>
          </div>
        </Modal>
      </div>
    );
  }
}

UntieConfirmModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  onConfirm: PropTypes.func.isRequired,
  queryDeviceByMchId: PropTypes.object.isRequired,
  total: PropTypes.number.isRequired,
};

const Container = connect(({ device: { untieConfirmVisible, queryDeviceByMchId } }) => ({
  visible: untieConfirmVisible,
  queryDeviceByMchId,
}))(UntieConfirmModal);

export { Container as UntieConfirmModal };
