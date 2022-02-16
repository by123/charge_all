import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Form, Card, Select } from 'antd';
import { connect } from 'react-redux';
import { action as deviceActions } from './store';
import { action as globalActions } from '../../store/global';
import { getFailDevice, mapArrayToOptions } from '../../utils';
import { agentAccountLabel } from '../../utils/enum';

const FormItem = Form.Item;
const formItemLayout = {
  wrapperCol: {
    xs: {
      span: 19,
    },
    sm: {
      span: 19,
    },
    xl: {
      span: 19,
    },
  },
  labelCol: {
    xs: {
      span: 5,
    },
    sm: {
      span: 5,
    },
    xl: {
      span: 5,
    },
  },
};

class TransferDeviceModal extends React.PureComponent {
  handleSubmit = () => {
    const { ids, dispatch, form } = this.props;
    form.validateFieldsAndScroll((err, values) => {
      if (err) return;
      const { destMchId } = values;
      dispatch(deviceActions.transferDeviceBySn({
        deviceSnLst: ids,
        destMchId,
      }, (_, getState) => {
        const { editDeviceResult: { result } } = getState().device;
        if (Array.isArray(result) && result.length && getFailDevice(result).length) {
          dispatch(globalActions.toggleErrorList(true));
        } else {
          message.success('设备转移成功');
          dispatch(deviceActions.toggleTransferDeviceModal(false));
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
      editDeviceResult,
      queryAgent,
      form: {
        getFieldDecorator,
      },
    } = this.props;
    const modalOpts = {
      title: '批量转移设备',
      visible,
      width: 630,
      okText: '转移',
      onOk: this.handleSubmit,
      onCancel: () => dispatch(deviceActions.toggleTransferDeviceModal(false)),
      destroyOnClose: true,
      confirmLoading: editDeviceResult.loading,
      cancelButtonProps: {
        disabled: editDeviceResult.loading,
      },
      maskClosable: false,
    };
    let agentList = queryAgent.result || [];
    agentList = agentList.filter((agent) => {
      return agent.mchType === 1;
    });
    return (
      <div>
        <Modal {...modalOpts}>
          <p>已选择{ids.length}个设备</p>
          <div className="g-selected-area">{ids.join(',')}</div>
          <Card title="选择新商户">
            {/* <BindAgent form={form} category={category} queryAgent={queryAgent} /> */}
            <Form>
              <div style={{ padding: 20 }}>
                <FormItem label="转移设备至" {...formItemLayout} hasFeedback={false}>
                  {getFieldDecorator('destMchId', {
                    rules: [
                      { required: true, message: '请选择新商户' },
                    ],
                  })(
                    <Select
                      allowClear
                      placeholder="请选择新商户"
                      style={{ width: 320 }}
                    >
                      {mapArrayToOptions(agentList, 'mchId', agentAccountLabel)}
                    </Select>
                  )}
                </FormItem>
              </div>
            </Form>
          </Card>
        </Modal>
      </div>
    );
  }
}

TransferDeviceModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  ids: PropTypes.array,
  queryAgent: PropTypes.object.isRequired,
  form: PropTypes.object.isRequired,
  editDeviceResult: PropTypes.object.isRequired,
};

TransferDeviceModal.defaultProps = {
  ids: [],
};

const TransferDeviceForm = Form.create()(TransferDeviceModal);
const Container = connect(({ device: { editDeviceResult, queryAgent, selectedKeys, transferDeviceVisible } }) => ({
  visible: transferDeviceVisible,
  ids: selectedKeys,
  editDeviceResult,
  queryAgent,
}))(TransferDeviceForm);

export { Container as TransferDeviceModal };
