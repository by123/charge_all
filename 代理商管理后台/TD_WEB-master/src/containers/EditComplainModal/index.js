import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Form, message } from 'antd';
import { connect } from 'react-redux';
import { action } from '../../pages/ServiceCenter/store';
import { EditComplainForm } from './EditComplainForm';

class EditComplainModal extends React.Component {

  componentDidMount() {
    this.props.dispatch(action.getProblemList());
  }

  toggleModal = (visible) => {
    this.props.dispatch(action.toggleCustomerModal(visible));
  }

  onOk = () => {
    const { form: { validateFieldsAndScroll }, dispatch, onOk } = this.props;
    validateFieldsAndScroll((err, values) => {
      if (err) return;
      dispatch(action.addTelComplain(values, () => {
        this.toggleModal(false);
        message.success('新增客服处理成功');
        onOk && onOk();
      }));
    });
  }

  onCancel = () => {}

  render() {
    const {
      visible,
      editTelComplainResult: {
        loading,
      },
      form,
      orderId,
      getProblemListResult: {
        result: complainTypeList,
      },
    } = this.props;

    const modalOpts = {
      title: '客服处理',
      centered: true,
      visible,
      width: 600,
      onCancel: () => this.toggleModal(false),
      onOk: this.onOk,
      maskClosable: false,
      destroyOnClose: true,
      okText: '提交',
      confirmLoading: loading,
    };

    return (
      <div>
        <Modal {...modalOpts} className="">
          <EditComplainForm
            form={form}
            orderId={orderId}
            complainTypeList={complainTypeList}
          />
        </Modal>
      </div>
    );
  }
}

EditComplainModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  form: PropTypes.object.isRequired,
  editTelComplainResult: PropTypes.object,
  getTelComplainDetailResult: PropTypes.object,
};

EditComplainModal.defaultProps = {
  editTelComplainResult: {},
  getTelComplainDetailResult: {},
};

const EditCustomerModalForm = Form.create()(EditComplainModal);
const Container = connect(({ serviceCenter: {
  customerModalVisible,
  editTelComplainResult,
  getTelComplainDetailResult,
  getProblemListResult,
} }) => ({
  visible: customerModalVisible,
  editTelComplainResult,
  getTelComplainDetailResult,
  getProblemListResult,
}))(EditCustomerModalForm);

export { Container as EditComplainModal };
