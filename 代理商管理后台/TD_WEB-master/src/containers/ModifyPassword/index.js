import React from 'react';
import PropTypes from 'prop-types';
import { Modal } from 'antd';
import { connect } from 'react-redux';
import { action as globalActions } from '../../store/global';

import ModifyPassword from './form';

class ModifyPasswordModal extends React.PureComponent {
  handleOk = () => {
    const { form } = this.modifyPassword.props;
    const { isFirst } = this.props;

    form.validateFieldsAndScroll((errors) => {
      if (errors) {
        return;
      }
      let fields = form.getFieldsValue();
      fields.needCheck = !isFirst ? 0 : 1;
      this.props.dispatch(globalActions.updatePassword(fields, isFirst));
    });
  };
  handleCancel = () => {
    this.props.dispatch(globalActions.toggleMPModal(false, this.props.isFirst));
  }
  render() {
    const {
      visible,
      isFirst,
    } = this.props;
    const modalOpts = {
      title: '修改密码',
      visible,
      onOk: this.handleOk,
      onCancel: this.handleCancel,
    };
    return (
      <Modal {...modalOpts}>
        <ModifyPassword key={Date.now()} isFirst={isFirst} wrappedComponentRef={inst => { this.modifyPassword = inst; }} />
      </Modal>
    );
  }
}

ModifyPasswordModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  saveData: PropTypes.object.isRequired,
  isFirst: PropTypes.bool,
};

ModifyPasswordModal.defaultProps = {
  isFirst: false,
};

const Container = connect(({ global: { mpVisible, mpUpdate, isFirst } }) => ({
  visible: mpVisible,
  saveData: mpUpdate,
  isFirst,
}))(ModifyPasswordModal);

export { Container as ModifyPasswordModal };
