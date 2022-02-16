import React from 'react';
import PropTypes from 'prop-types';
import { Modal } from 'antd';
import { connect } from 'react-redux';
import { RefundForm } from './RefundForm';
import { action as orderActions } from '../../pages/Order/store';

class RefundModal extends React.PureComponent {
  componentDidMount() {
    this.props.dispatch(orderActions.getRefundReason());
  }
  handleOk = () => {
    const { form } = this.refundForm.props;
    const { refundReason } = this.props;
    form.validateFieldsAndScroll({ force: true }, (errors) => {
      if (errors) {
        return;
      }
      let fields = form.getFieldsValue();
      let { reason, reasonText } = fields;
      const selected = refundReason[reason];
      if (selected.id === 7) {
        fields.reason = reasonText;
      } else {
        fields.reason = selected.desc;
      }
      delete fields.reasonText;
      this.props.onOk && this.props.onOk(fields);
      // this.props.dispatch(orderActions.orderRefund(fields));
    });
  };
  handleCancel = () => {
    this.props.onCancel && this.props.onCancel();
    // this.props.dispatch(orderActions.toggleRefundModal(false));
  }
  render() {
    const {
      visible,
      order = {},
      saveData: {
        loading,
      } = {},
      refundReason,
    } = this.props;
    const modalOpts = {
      title: '退款',
      visible,
      onOk: this.handleOk,
      confirmLoading: loading,
      onCancel: this.handleCancel,
      zIndex: 1001,
    };
    return (
      <Modal {...modalOpts}>
        <RefundForm
          key={order.orderId}
          reason={refundReason}
          order={order}
          wrappedComponentRef={inst => { this.refundForm = inst; }}
        />
      </Modal>
    );
  }
}

RefundModal.propTypes = {
  refundReason: PropTypes.array.isRequired,
  dispatch: PropTypes.func.isRequired,
  onOk: PropTypes.func.isRequired,
  onCancel: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  order: PropTypes.object.isRequired,
  saveData: PropTypes.object.isRequired,
};

RefundModal.defaultProps = {
  refundReason: [],
};

const Container = connect(({ order: { refundReason } }) => ({
  refundReason: refundReason.result ? JSON.parse(refundReason.result.cfgValue || '[]') : [],
}))(RefundModal);

export { Container as RefundModal };
