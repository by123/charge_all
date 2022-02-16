import React from 'react';
import PropTypes from 'prop-types';
import { Form, Input, Radio } from 'antd';
import isNumber from 'lodash/isNumber';
import { mapObjectToRadioItem } from '../../utils';
import { complaintsType, resolveType } from '../../utils/enum';
import { pattern } from '../../utils/constants';

const { TextArea } = Input;
const RadioGroup = Radio.Group;
const FormItem = Form.Item;

const formItemLayout = {
  labelCol: {
    span: 6,
  },
  wrapperCol: {
    span: 14,
  },
};

class EditComplainForm extends React.Component {
  render() {
    const {
      form,
      orderId,
      complainTypeList = {},
      complainDetail,
    } = this.props;

    const { getFieldDecorator } = form;
    if (orderId) {
      getFieldDecorator('orderId', { initialValue: orderId });
    }
    if (complainDetail) {
      const { complainType, problemType, problemState } = complainDetail;
      complainDetail.complainType = isNumber(complainType) ? String(complainType) : complainType;
      complainDetail.problemType = isNumber(problemType) ? String(problemType) : problemType;
      complainDetail.problemState = isNumber(problemState) ? String(problemState) : problemState;
    }
    return (<Form layout="horizontal" autoComplete="off">
      <FormItem label="来电号码" {...formItemLayout}>
        {getFieldDecorator('telephone', {
          initialValue: complainDetail.telephone,
          validateFirst: true,
          rules: [
            {
              required: true,
              message: '请输入来电号码',
            },
            {
              validator(rule, value, callback) {
                if (pattern.mobile.test(value) || pattern.phone.test(value)) {
                  callback();
                } else {
                  callback('请输入正确的来电号码');
                }
              },
            },
          ],
        })(<Input type="number" maxLength={11} placeholder="请输入来电号码" />)}
      </FormItem>
      <FormItem label="投诉类型" {...formItemLayout}>
        {getFieldDecorator('complainType', {
          initialValue: !orderId ? complainDetail.complainType : '0',
          rules: [
            {
              required: true,
              message: '投诉类型为必填项',
            }],
        })(<RadioGroup disabled={!!orderId}>
          {mapObjectToRadioItem(complaintsType)}
        </RadioGroup>)}
      </FormItem>
      <FormItem label="设备投诉问题" {...formItemLayout}>
        {getFieldDecorator('problemType', {
          initialValue: complainDetail.problemType,
          rules: [
            {
              required: true,
              message: '设备投诉问题为必填项',
            }],
        })(<RadioGroup>
          {mapObjectToRadioItem(complainTypeList)}
        </RadioGroup>)}
      </FormItem>
      <FormItem label="解决情况" {...formItemLayout}>
        {getFieldDecorator('problemState', {
          initialValue: complainDetail.problemState,
          rules: [
            {
              required: true,
              message: '解决情况为必填项',
            }],
        })(<RadioGroup>
          {mapObjectToRadioItem(resolveType)}
        </RadioGroup>)}
      </FormItem>
      <FormItem label="其他备注" {...formItemLayout}>
        {getFieldDecorator('problemContent', {
          initialValue: complainDetail.problemContent,
        })(<TextArea style={{ marginLeft: 10, verticalAlign: 'top' }} />)}
      </FormItem>
    </Form>);
  }
}

EditComplainForm.propTypes = {
  form: PropTypes.object.isRequired,
  orderId: PropTypes.string,
  complainDetail: PropTypes.object,
};

EditComplainForm.defaultProps = {
  orderId: '',
  complainDetail: {},
};

export { EditComplainForm };
