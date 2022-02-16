import React from 'react';
import PropTypes from 'prop-types';
import { Input } from 'antd';

import './style.less';

const { TextArea } = Input;


export class NumberInput extends React.PureComponent {
  onChange = (e) => {
    this.props.onChange(e.target.value);
  }
  render() {
    const { value, label, disabled } = this.props;
    return (<div className="device-number-input">
      <p className="label">{label}</p>
      <TextArea value={value} onChange={this.onChange} disabled={disabled} rows={4} placeholder="支持中英文逗号、换行及空格分隔设备号，例如：9810230000000003,9810230000000004，9810230000000005" />
    </div>);
  }
}

NumberInput.propTypes = {
  value: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired,
  label: PropTypes.string,
  disabled: PropTypes.bool,
};

NumberInput.defaultProps = {
  label: '输入设备编号：',
  disabled: false,
};
