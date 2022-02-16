import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message } from 'antd';
import { connect } from 'react-redux';
import { action as globalActions } from '../../store/global';

import FindPassword from './form';

class FindPasswordModal extends React.PureComponent {
  state = {
    step: 1,
    userName: '',
    token: '',
    tmpData: {},
  }
  handleOk = () => {
    const { form } = this.modifyPassword.props;

    form.validateFieldsAndScroll((errors) => {
      if (errors) {
        return;
      }
      let fields = form.getFieldsValue();
      this.handleStep(fields);
      // this.props.dispatch(globalActions.updatePassword(fields));
    });
  };
  handleStep = (fields) => {
    const { step } = this.state;
    switch (step) {
      case 1:
        this.findGetSmsCode(fields);
        break;
      case 2:
        this.findCheckSmsCode(fields);
        break;
      case 3:
        this.findResetPassword(fields);
        break;
      default:
        this.findGetSmsCode(fields);
        break;
    }
  }
  goNextStep = () => {
    this.setState({
      step: this.state.step + 1,
    });
  }
  findGetSmsCode = (fields) => {
    this.props.dispatch(globalActions.findGetSmsCode(fields, (_, getState, codeKey) => {
      this.goNextStep();
      const tmpData = {
        ...fields,
        codeKey,
        phoneNumber: this.props.findPasswordResult.result || '',
      };
      this.setState({
        userName: fields.userName,
        tmpData,
      });
    }));
  }
  findCheckSmsCode = (fields) => {
    const { userName } = this.state;
    fields.userName = userName;
    this.props.dispatch(globalActions.findCheckSmsCode(fields, () => {
      const { findPasswordResult } = this.props;
      const token = findPasswordResult.result || '';
      this.setState({
        token,
      });
      this.goNextStep();
      this.setState({
        tmpData: {},
      });
    }));
  }
  findResetPassword = (fields) => {
    const { userName, token } = this.state;
    fields.userName = userName;
    fields.token = token;
    this.props.dispatch(globalActions.findResetPassword(fields, () => {
      message.success('找回密码成功');
      this.setState({
        step: 1,
        tmpData: {},
        userName: '',
        token: '',
      });
      this.props.dispatch(globalActions.toggleFindPassword(false));
    }));
  }
  handleCancel = () => {
    this.props.dispatch(globalActions.toggleFindPassword(false));
    this.setState({
      step: 1,
    });
  }
  render() {
    const {
      visible,
      findPasswordResult: {
        loading,
      },
    } = this.props;
    const okText = this.state.step < 3 ? '下一步' : '确认';
    const modalOpts = {
      title: '找回密码',
      visible,
      onOk: this.handleOk,
      onCancel: this.handleCancel,
      confirmLoading: loading,
      okText,
      destroyOnClose: true,
    };
    return (
      <Modal {...modalOpts}>
        <FindPassword key={Date.now()} tmpData={this.state.tmpData} step={this.state.step} wrappedComponentRef={inst => { this.modifyPassword = inst; }} />
      </Modal>
    );
  }
}

FindPasswordModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  findPasswordResult: PropTypes.object.isRequired,
};

const Container = connect(({ global: { findPasswordVisible, findPasswordResult } }) => ({
  visible: findPasswordVisible,
  findPasswordResult,
}))(FindPasswordModal);

export { Container as FindPasswordModal };
