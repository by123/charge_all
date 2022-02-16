import React from 'react';
import PropTypes from 'prop-types';
import { Form, Input, InputNumber, Radio } from 'antd';
import isNumber from 'lodash/isNumber';

const { TextArea } = Input;
const RadioGroup = Radio.Group;

const formItemLayout = {
  labelCol: {
    span: 6,
  },
  wrapperCol: {
    span: 14,
  },
};

const radioStyle = {
  display: 'block',
  height: '30px',
  lineHeight: '30px',
};

const FormItem = Form.Item;

class RefundForm extends React.Component {
  render() {
    const {
      form,
      order,
      reason = [],
    } = this.props;

    const { getFieldDecorator, getFieldValue, setFieldsValue, setFields } = form;
    const reasonIndex = getFieldValue('reason');
    const isUseable = isNumber(reasonIndex) && (reason[reasonIndex].id === 7);
    getFieldDecorator('orderId', { initialValue: order.orderId });
    return (<Form layout="horizontal" autoComplete="off">
      <FormItem label="退款原因" {...formItemLayout}>
        {getFieldDecorator('reason', {
          validateFirst: true,
          rules: [
            {
              required: true,
              message: '退款原因为必填项',
            },
            {
              validator: (rule, value, callback) => {
                if (reason[value].id !== 7) {
                  setFieldsValue({ reasonText: '' });
                } else {
                  !getFieldValue('reasonText') && callback('请输入退款原因');
                }
                callback();
              },
            }],
        })(<RadioGroup style={{ marginTop: 5 }}>
          {reason.map((val, ind) => {
            if (val.id === 7) {
              return (<Radio value={ind} key={val.id}>
                {val.desc}
                {getFieldDecorator('reasonText', {
                  initialValue: '',
                  rules: [
                    {
                      validator: (rule, value, callback) => {
                        setFields({
                          reason: {
                            value: getFieldValue('reason'),
                            errors: value ? null : [new Error('请输入退款原因')],
                          },
                        });
                        callback();
                      },
                    },
                  ],
                })(<TextArea disabled={!isUseable} style={{ marginLeft: 10, verticalAlign: 'top' }} />)}
              </Radio>);
            }
            return <Radio style={radioStyle} value={ind} key={val.id}>{val.desc}</Radio>;
          })}
        </RadioGroup>)}
      </FormItem>
      <FormItem label="退款方式" {...formItemLayout}>
        <span>原路退回</span>
      </FormItem>
      <FormItem label="退款金额" {...formItemLayout}>
        {getFieldDecorator('refundMoney', {
          initialValue: '',
          validateFirst: true,
          rules: [{
            required: true,
            type: 'number',
            message: '退款金额为必填项',
          }, {
            max: order.servicePriceYuan,
            type: 'number',
            message: `最大退款金额为${order.servicePriceYuan}元`,
          }],
        })(<InputNumber />)}
        <span style={{ marginLeft: 20 }}>最大退款金额为{order.servicePriceYuan}元</span>
      </FormItem>
    </Form>);
  }
}

RefundForm.propTypes = {
  form: PropTypes.object.isRequired,
  order: PropTypes.object.isRequired,
  reason: PropTypes.array.isRequired,
};

const Container = Form.create()(RefundForm);

export { Container as RefundForm };
