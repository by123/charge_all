import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Select, Form, Input, message } from 'antd';
import { connect } from 'react-redux';
import { action } from './store';
import { mapArrayToOptions, mapObjectToOptions } from '../../utils';
import { ADD, EDIT } from '../../utils/constants';
import { wireTypes1 } from '../../utils/enum';

const FormItem = Form.Item;
const InputGroup = Input.Group;

const formItemLayout = {
  wrapperCol: {
    xs: { span: 16 },
    sm: { span: 16 },
    xl: { span: 16 },
  },
  labelCol: {
    xs: { span: 5 },
    sm: { span: 5 },
    xl: { span: 5 },
  },
};

class AddSnConfigModal extends React.PureComponent {
  handleSubmit = () => {
    const { dispatch, form, editType, selectedRowData } = this.props;
    form.validateFieldsAndScroll((err, values) => {
      if (err) return;
      let { deviceSnRightBegin, deviceSnRightEnd } = values;
      deviceSnRightBegin = String(deviceSnRightBegin);
      deviceSnRightEnd = String(deviceSnRightEnd);
      if (!deviceSnRightBegin || !deviceSnRightEnd) {
        message.error('请输入编号区间');
        return false;
      }
      if (deviceSnRightBegin.length !== 10
        || deviceSnRightEnd.length !== 10
        || isNaN(deviceSnRightEnd)
        || isNaN(deviceSnRightBegin)
        || Number(deviceSnRightEnd) < Number(deviceSnRightBegin)
        || deviceSnRightEnd.indexOf('.') > -1
        || deviceSnRightBegin.indexOf('.') > -1
      ) {
        message.error('请输入正确的编号区间');
        return false;
      }
      editType === EDIT && (values.id = selectedRowData.id);
      dispatch(action.editSnConfig(values, editType));
    });
  }
  render() {
    const {
      visible,
      dispatch,
      editSnConfigResult,
      editType,
      selectedRowData,
      form: {
        getFieldDecorator,
      },
      versionListResult,
    } = this.props;
    const versionList = versionListResult.result || [];
    const modalOpts = {
      title: `${editType === ADD ? '新建' : '编辑'}号段`,
      visible,
      width: 630,
      onOk: this.handleSubmit,
      okText: '提交',
      onCancel: () => dispatch(action.toggleAddModal(false)),
      destroyOnClose: true,
      confirmLoading: editSnConfigResult.loading,
      cancelButtonProps: {
        disabled: editSnConfigResult.loading,
      },
      maskClosable: false,
    };
    return (
      <div>
        <Modal {...modalOpts}>
          <Form>
            <div style={{ padding: 20 }}>
              <FormItem label="设备类型" required {...formItemLayout} hasFeedback={false}>
                {getFieldDecorator('deviceType', {
                  initialValue: selectedRowData.deviceType !== undefined ? String(selectedRowData.deviceType) : undefined,
                  rules: [
                    { required: true, message: '请选择设备类型' },
                  ],
                })(
                  <Select
                    allowClear
                    placeholder="请选择设备类型"
                    style={{ width: 220 }}
                  >
                    {mapObjectToOptions(wireTypes1)}
                  </Select>
                )}
              </FormItem>
              <FormItem label="编号区间" required {...formItemLayout} hasFeedback={false}>
                <InputGroup compact>
                  {getFieldDecorator('deviceSnRightBegin', {
                    initialValue: selectedRowData.deviceSnRightBegin,
                  })(
                    <Input maxLength={10} style={{ width: '45%', textAlign: 'center' }} placeholder="请输入起始编号" />
                  )}
                  <Input style={{ width: '10%', borderLeft: 0, pointerEvents: 'none', backgroundColor: '#fff' }} placeholder="~" disabled />
                  {getFieldDecorator('deviceSnRightEnd', {
                    initialValue: selectedRowData.deviceSnRightEnd,
                  })(
                    <Input maxLength={10} style={{ width: '45%', textAlign: 'center', borderLeft: 0 }} placeholder="请输入终止编号" />
                  )}
                </InputGroup>
              </FormItem>
              <FormItem label="软件版本" required {...formItemLayout} hasFeedback={false}>
                {getFieldDecorator('deviceVersion', {
                  initialValue: selectedRowData.deviceVersion,
                  rules: [
                    { required: true, message: '请选择软件版本' },
                  ],
                })(
                  <Select
                    allowClear
                    placeholder="请选择软件版本"
                    style={{ width: 220 }}
                  >
                    {mapArrayToOptions(versionList, 'deviceVersion', 'deviceVersion')}
                  </Select>
                )}
              </FormItem>
            </div>
          </Form>
        </Modal>
      </div>
    );
  }
}

AddSnConfigModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  editSnConfigResult: PropTypes.object,
  editType: PropTypes.string,
  selectedRowData: PropTypes.object,
  versionListResult: PropTypes.object,
  form: PropTypes.object.isRequired,
};

AddSnConfigModal.defaultProps = {
  ids: [],
  editSnConfigResult: {},
  editType: ADD,
  selectedRowData: {},
  versionListResult: {},
};

const AddSnConfigModalForm = Form.create()(AddSnConfigModal);

const Container = connect(({ active: {
  editSnConfigResult,
  addSnConfigVisible,
  editType,
  selectedRowData,
  versionListResult,
} }) => ({
  visible: addSnConfigVisible,
  editSnConfigResult,
  editType,
  selectedRowData,
  versionListResult,
}))(AddSnConfigModalForm);

export { Container as AddSnConfigModal };
