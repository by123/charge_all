import React from 'react';
import PropTypes from 'prop-types';
import { Form, Input, Cascader } from 'antd';
import moment from 'moment';

import { DatePicker, Select } from '../pop';

const FormItem = Form.Item;

export class FormInput extends React.PureComponent {
  renderField = () => {
    const {
      type,
      label,
      options,
      defaultValue,
      formItemLayout,
      ...otherOptions
    } = this.props;
    switch (type) {
      case 'select': {
        return <Select allowClear placeholder={`请选择${label}`} {...otherOptions}>{options}</Select>;
      }
      case 'date': {
        return <DatePicker placeholder={`请选择${label}`} {...otherOptions} />;
      }
      case 'cascader': {
        return <Cascader placeholder={`请选择${label}`} options={options} {...otherOptions} />;
      }
      // case 'number': {
      //   return <Input placeholder={`请输入${label}`} type="number" {...otherOptions} />;
      // }
      default: {
        return <Input placeholder={`请输入${label}`} {...otherOptions} />;
      }
    }
  };
  render() {
    const {
      form: {
        getFieldDecorator,
      },
      formItemLayout,
      label,
      name,
      type,
      required,
    } = this.props;

    // form会把null识别为一个初始值，会覆盖placeholder，所以为空设置成undefined
    let defaultValue = this.props.defaultValue || undefined;
    let valType = 'string';
    if (type === 'date') {
      valType = 'object';
    } else if (type === 'cascader') {
      valType = 'array';
    }
    const defaultRules = required ? [{
      required: true,
      whitespace: type === 'text',
      type: valType,
      message: `${label}为必填项`,
    }] : [];

    if (type === 'date' && defaultValue) {
      defaultValue = moment(defaultValue, 'x');
    }
    const rules = this.props.rules ? defaultRules.concat(this.props.rules) : defaultRules;
    return (<FormItem label={label} {...formItemLayout} >
      {getFieldDecorator(name, {
        initialValue: defaultValue,
        rules,
      })(this.renderField())}
    </FormItem>);
  }
}

FormInput.propTypes = {
  form: PropTypes.object.isRequired,
  formItemLayout: PropTypes.object,
  name: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
  rules: PropTypes.array,
  required: PropTypes.bool,
  type: PropTypes.string,
  options: PropTypes.array,
  defaultValue: PropTypes.any,
};

FormInput.defaultProps = {
  defaultValue: null,
  options: [],
  formItemLayout: {
    labelCol: {
      span: 7,
    },
    wrapperCol: {
      span: 14,
    },
  },
  rules: null,
  required: true,
  type: 'text',
};
